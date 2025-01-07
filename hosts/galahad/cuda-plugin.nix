{
  # apparently none of this works if the driver is above
  # 390 because of cuda compatability
  # horrendous documentation...
  libcuda,
  cmake,
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
    inherit system;
  },
  ...
}:

with pkgs;
let
  version = "6.22.0";
  cpkgs =
    import
      (builtins.fetchGit {
        # Descriptive name to make the store path easier to identify
        name = "my-old-revision";
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixpkgs-unstable";
        rev = "c6b5632d7066510ec7a2cb0d24b1b24dac94cf82";
      })
      {
        config.allowUnfree = true;
        inherit system;
      };
  cuda7 = cpkgs.cudaPackages.cudatoolkit_8;
in
pkgs.stdenv.mkDerivation {
  name = "xmrig-cuda";
  version = version;

  src = pkgs.fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-cuda";
    rev = "v${version}";
    sha256 = "sha256-AyHqkk9ujY7fJuwLJaI/kiQIQia+RXH1qiQZ6l1pYFU=";
  };

  buildInputs = with pkgs; [
    cmake
    git
    gcc9
    cuda7
  ];

  nativeBuildInputs = [ cmake ];

  configurePhase = ''
    mkdir -p build
  '';

  buildPhase = ''
    cd build
    cmake .. -DCUDA_LIB=${libcuda} -DCUDA_TOOLKIT_ROOT_DIR=${cuda7} -DCMAKE_C_COMPILER=${pkgs.gcc9}/bin/gcc -DCUDA_ARCH=35
    make -j$(nproc)
  '';

  installPhase = ''
    cp -r /build/source/build $out
  '';

  meta = with pkgs.lib; {
    description = "NVIDIA CUDA plugin for XMRig miner";
    homepage = "https://github.com/xmrig/xmrig-cuda";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
