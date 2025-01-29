{ lib, pkgs, ... }:
{
  systemd.services.xmrig.serviceConfig.wantedBy = lib.mkForce [ ];
  systemd.services.xmrig.wantedBy = lib.mkForce [ ];
  services.xmrig = {
    enable = true;
    package = pkgs.xmrig-mo;
    settings = {
      cpu = {
        enabled = true;
        asm = "intel";
        max-threads-hint = 75;
        huge-pages = true;
        memory-pool = true;
        hw-aes = true;
        priority = 2;
        argon2-impl = "AVX2";
      };
      randomx = {
        init-avx2 = 1;
        mode = "fast";
        "1gb-pages" = true;
      };
      autosave = true;
      opencl = false;
      ## REQUIRES DRIVERS FOR CUDA9, SO BEFORE 470
      ## BECAUSE OF KEPLER ARCH
      #cuda = {
      # enabled = true;
      #loader = "${
      #  pkgs.callPackage ./cuda-plugin.nix {
      #    libcuda = "${config.hardware.nvidia.package}/lib/libcuda.so";
      #  }
      #}/libxmrig-cuda.so";
      #};
      pools = [
        {
          enabled = true;
          donate-level = 0;
          donate-over-proxy = 0;
          url = "gulf.moneroocean.stream:10032";
          user = "46MtVdJvWmBDB9ZrsGFFpq8igfBogkSHeL8kQxcJ6tEzAadd77udvYGF57FoNUyWUTdvLEPcCLkvWRSmQPLeAQtxEqSQkU8";
          keepalive = false;
          tls = false;
        }
      ];
    };
  };
}
