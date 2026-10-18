{ config, pkgs, ... }:

{
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

# Internet
  networking.networkmanager.enable = true;

# Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

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
    animation = "matrix";
    animation_timeout_sec = 0;

    hide_borders = true;
    box_title = "WELCOME";
    hide_key_hints = true;
    hide_version_string = true;

    bg = "0x00000000";
    fg = "0x00FFFFFF";
    border_fg = "0x00FF00FF";
    error_fg = "0x00FF0055";

    bigclock = true;
    clock = "%A %d %B %H:%M:%S";

    margin_box_h = 2;
    margin_box_v = 1;
  };
};
}
