{ pkgs, ... }:

{
  boot = {
    kernelParams = [
        "quiet"
        "splash"
        "nvidia_drm.modeset=1"
    ];
    kernelModules = [ "kvm-intel" "nvidia_uvm" ];
    initrd = {
      systemd.enable = true;
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];
      };
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          gfxmodeEfi = "1920x1080";
          gfxpayloadEfi = "keep";
        };
        efi.canTouchEfiVariables = true;
      };
      plymouth = {
          enable = true;
          theme = "pixels";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "pixels" ];
            })
          ];
        };
    };
}
