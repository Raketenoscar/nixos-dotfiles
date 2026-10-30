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
  # SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    wayland.compositor = "kwin";
    theme = "catppuccin-mocha-mauve";
    settings.Theme = {
      CursorTheme = "Bibata-Modern-Ice";
      CursorSize = 24;
    };
  };
  systemd.services.display-manager.environment = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    XCURSOR_PATH = "/run/current-system/sw/share/icons:${pkgs.bibata-cursors}/share/icons";
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
  (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
    vim
    wget
    fastfetch
    kdePackages.kfind
    unrar-wrapper
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
    lf
    durdraw
    caligula
    pastel
    astroterm
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
