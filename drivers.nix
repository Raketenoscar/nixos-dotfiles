{ pkgs, ... }:

{

# Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    hplip
    brlaser
    epson-escpr
    epson-escpr2
  ];

# GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    LD_LIBRARY_PATH = [ "/run/opengl-driver/lib" ];
  };

  hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      videoAcceleration = true;
      open = false;
      branch = "legacy_580";
      gsp.enable = false;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
}
