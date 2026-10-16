{ config, pkgs, ... }:

{
# Bootloader
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;

# User Preferences
  networking.hostName = "nixos";
  users.users.oscar = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "networkmanager"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
# Drivers
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
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];
# Internet
  networking.networkmanager.enable = true;

# Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
# Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# SSH
  services.openssh.enable = true;

# Virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  boot.kernelModules = [ "kvm-intel" "nvidia_uvm" ];

# Dark Mode 
qt = {
  enable = true;
  style = "adwaita-dark";
};
# Ly
services.displayManager.ly = {
  enable = true;

  settings = {
    # Built-in animation
    animation = "matrix"; # doom, matrix, colormix
    animation_timeout_sec = 0;

    # Make the login box cleaner
    hide_borders = true;
    box_title = "WELCOME";
    hide_key_hints = true;
    hide_version_string = true;

    # Colors
    bg = "0x00000000";
    fg = "0x00FFFFFF";
    border_fg = "0x00FF00FF";
    error_fg = "0x00FF0055";

    # Clock
    bigclock = true;
    clock = "%A %d %B %H:%M:%S";

    # Spacing
    margin_box_h = 2;
    margin_box_v = 1;
  };
};
}
