{
  libcuda,
  cmake,
  pkgs ? import <nixpkgs> { },
}:

let
  version = "6.22.0";
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
    cudaPackages_11.cudatoolkit
    gcc14
  ];

  nativeBuildInputs = [ cmake ];

  configurePhase = ''
    mkdir -p build
  '';

  buildPhase = ''
    cd build
    cmake .. -DCUDA_LIB=${libcuda} -DCUDA_TOOLKIT_ROOT_DIR=${pkgs.cudaPackages.cudatoolkit} -DCMAKE_C_COMPILER=${pkgs.gcc9}/bin/gcc
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
