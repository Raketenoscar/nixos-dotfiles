{ config, pkgs, ... }:

{
  home.username = "oscar";
  home.homeDirectory = "/home/oscar";
  home.stateVersion = "26.05";

# Dark Mode
    gtk = {
    enable = true;

    colorScheme = "dark";

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
    home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";

    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_STYLE_OVERRIDE = "Adwaita-dark";

    MOZ_ENABLE_WAYLAND = "1";
  };
   dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

# KDE apps (gwenview, dolphin) dark theme
  home.file.".config/kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark
    Name=BreezeDark
    TerminalApplication=alacritty
    TerminalService=Alacritty.desktop
    font=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0
    menuFont=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0
    toolBarFont=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0
    smallestReadableFont=JetBrainsMono Nerd Font,9,-1,5,50,0,0,0,0,0
    fixed=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0

    [Colors:Window]
    BackgroundNormal=49,54,59
    BackgroundAlternate=35,38,41
    BackgroundSelected=61,174,233
    ForegroundNormal=239,240,241
    ForegroundInactive=152,154,158
    ForegroundActive=29,153,243
    ForegroundLink=61,174,233
    ForegroundVisited=148,108,187
    DecorationFocus=61,174,233
    DecorationHover=61,174,233

    [Colors:View]
    BackgroundNormal=35,38,41
    BackgroundAlternate=49,54,59
    BackgroundSelected=61,174,233
    ForegroundNormal=239,240,241
    ForegroundInactive=152,154,158
    ForegroundActive=61,174,233
    ForegroundLink=61,174,233
    ForegroundVisited=148,108,187
    DecorationFocus=61,174,233
    DecorationHover=61,174,233

    [Colors:Selection]
    BackgroundNormal=61,174,233
    ForegroundNormal=35,38,41

    [Colors:Complement]
    BackgroundNormal=57,66,73
    ForegroundNormal=220,227,232

    [Colors:Header]
    BackgroundNormal=61,174,233
    ForegroundNormal=49,54,59

    [Colors:Tooltip]
    BackgroundNormal=49,54,59
    ForegroundNormal=239,240,241
  '';

#Zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
                        config = "nvim /home/oscar/nixos/configuration.nix";
                        hardware-config = "nvim /home/oscar/nixos/hardware-configuration.nix";
                        pkgs = "nvim /home/oscar/nixos/pkgs.nix";
                        home-config = "nvim /home/oscar/nixos/home.nix";
                        nrs = "sudo nixos-rebuild switch --flake /home/oscar/nixos";
			                  update = "nix flake update --flake /home/oscar/nixos; sudo nixos-rebuild switch --flake /home/oscar/nixos";
                        user-config = "nvim /home/oscar/nixos/user.nix";
                        internet = "impala";
                        conf = "cd /home/oscar/nixos/config/";
                        neofetch = "bash /home/oscar/nixos/config/neofetch/neofetch.sh";
                        dot = "cd /home/oscar/nixos";
                        freespace = "sudo nix-collect-garbage -d; sudo nixos-rebuild switch --flake /home/oscar/nixos";
                        rocketserver = "ssh oscar@192.168.88.50";
                        nixos-commit = ''cp -rf /home/oscar/nixos/* /home/oscar/nixos-dotfiles; 
                        git -C /home/oscar/nixos-dotfiles add -A; 
                        git -C /home/oscar/nixos-dotfiles commit -m "Update"; 
                        git -C /home/oscar/nixos-dotfiles push origin main'';
    };
    oh-my-zsh = {
      enable = true;
      custom = "/home/oscar/nixos/config/oh-my-zsh/custom";
      theme = "powerlevel10k";
      plugins = [
        "git"
        "sudo"
        "docker"
        "dirhistory"
        "history"
      ];
    };
    initContent = ''
        source /home/oscar/nixos/config/p10k/.p10k.zsh
        eval "$(zoxide init --cmd cd zsh)"
        pfetch
        source /etc/set-environment SDL_VIDEODRIVER=x11
      '';
};

# Quickshell
  xdg.configFile."quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/oscar/nixos/config/quickshell";
    recursive = true;
  };

# Hypr
    xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/oscar/nixos/config/hypr";
    recursive = true;
  };
# Wlogout
    xdg.configFile."wlogout" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/oscar/nixos/config/wlogout";
    recursive = true;
  };
# Nvim
    xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/oscar/nixos/config/nvim";
    recursive = true;
  };

# Rofi
  xdg.configFile."rofi".source = ./config/rofi;

# Foot
  xdg.configFile."foot".source = ./config/foot;

# Wallpapers
  home.file."walls".source = ./walls;

# Cursor
  home.file.".local/share/icons".source = ./config/cursors;

# Desktop Files
  home.file.".local/share/applications".source = ./desktop-files;

# Icons (installed into the hicolor icon theme so .desktop files can
# reference icons by name regardless of the user's home dir)
  home.file.".icons/hicolor/scalable/apps".source = ./desktop-files/icons;

}
