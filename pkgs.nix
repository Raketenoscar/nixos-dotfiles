{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.mullvad-vpn.enable = true;
  services.udisks2.enable = true;
  programs.nix-ld.enable = true;
  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    unrar-wrapper
    kdePackages.dolphin
    python3
    neovim
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
    bluetui
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    yazi
    gcc
    pamixer
    fetch
    cava
    cmatrix
    zsh
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
   

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "JetBrainsMono Nerd Font" ];
    serif = [ "JetBrainsMono Nerd Font" ];
    monospace = [ "JetBrainsMono Nerd Font" ];
    emoji = [ "Noto Color Emoji" ];
  };

  fonts.packages = with pkgs; [
  dejavu_fonts
  liberation_ttf
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-color-emoji
  corefonts
  vista-fonts
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  nerd-fonts.hack
  nerd-fonts.iosevka
  fira-code
  jetbrains-mono
  hack-font
  font-awesome
  pixel-code
  ];
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing.drivers = with pkgs; [
    gutenprint
    hplip
    brlaser
    epson-escpr
    epson-escpr2
  ];
  
  system.stateVersion = "26.05";
}
