{ pkgs, ... }:

{
  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
     xdg-desktop-portal-hyprland
     xdg-desktop-portal-gtk
    ];
   config.common.default = "hyprland";
  };

  # Services
  services.openssh.enable = true;
  services.mullvad-vpn.enable = true;
  services.udisks2.enable = true;
  programs.nix-ld.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # PKGS
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    unrar-wrapper
    chromium
    wine
    steam
    discord
    obs-studio
    kdePackages.dolphin
    python3
    zoxide
    jdk
    foot
    btop
    desktop-file-utils
    hyprpaper
    kdePackages.gwenview
    pfetch
    rofi
    gnome-disk-utility
    scrcpy
    qbittorrent
    wlroots
    jellyfin-desktop
    tree
    git
    wev
    fd
    lazygit
    unzip
    ghostscript
    imagemagick
    bat
    yt-dlp
    mpv
    tealdeer
    fzf
    xclip
    neovim
    ripgrep
    nixpkgs-fmt
    nodejs
    yazi
    gcc
    pamixer
    fetch
    cava
    cmatrix
    zsh
    kdePackages.kdenlive
    oh-my-zsh
    zsh-powerlevel10k
    libreoffice
    virt-manager
    librewolf
    quickshell
    libnotify
    hyprshutdown
    hyprlock
    hyprpicker
    hyprcursor
    bibata-cursors
    opencode
    wiremix
    wlogout
    vscodium
  ];

  system.stateVersion = "26.05";
}
