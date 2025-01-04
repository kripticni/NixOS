{ pkgs, config, ... }:
{
  #for some reason, this is awfully buggy and slow, so i wont use it
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver (
      let
        aurPatches = pkgs.fetchgit {
          url = "https://aur.archlinux.org/nvidia-390xx-utils.git";
          rev = "94dffc01e23a93c354a765ea7ac64484a3ef96c1";
          hash = "sha256-c94qXNZyMrSf7Dik7jvz2ECaGELqN7WEYNpnbUkzeeU=";
        };
      in
      {
        version = "470.256.02";
        sha256_64bit = "sha256-1kUYYt62lbsER/O3zWJo9z6BFowQ4sEFl/8/oBNJsd4=";
        sha256_aarch64 = "sha256-e+QvE+S3Fv3JRqC9ZyxTSiCu8gJdZXSz10gF/EN6DY0=";
        settingsSha256 = "sha256-kftQ4JB0iSlE8r/Ze/+UMnwLzn0nfQtqYXBj+t6Aguk=";
        persistencedSha256 = "sha256-iYoSib9VEdwjOPBP1+Hx5wCIMhW8q8cCHu9PULWfnyQ=";
        patches = [
          "${aurPatches}/gcc-14.patch"
          # fixes 6.10 follow_pfn
          ./follow_pfn.patch
          # https://gist.github.com/joanbm/a6d3f7f873a60dec0aa4a734c0f1d64e
          (pkgs.fetchpatch {
            url = "https://gist.github.com/joanbm/a6d3f7f873a60dec0aa4a734c0f1d64e/raw/6bae5606c033b6c6c08233523091992370e357b7/nvidia-470xx-fix-linux-6.12.patch";
            hash = "sha256-6nbzcRTRCxW8GDAhB8Zwx9rVcCzwPtVYlqoUhL9gxlY=";
            stripLen = 1;
            extraPrefix = "kernel/";
          })
        ];
      }
    );
  };

  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:9:0:0";
  };
}
