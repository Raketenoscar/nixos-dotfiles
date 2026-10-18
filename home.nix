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

# KDE apps 
  home.file.".config/kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark
    terminalApplication=foot
    font=JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0

    [Colors:Window]
    BackgroundNormal=49,54,59
    ForegroundNormal=239,240,241

    [Colors:View]
    BackgroundNormal=35,38,41
    ForegroundNormal=239,240,241

    [Colors:Selection]
    BackgroundNormal=61,174,233
    ForegroundNormal=35,38,41  
    '';

# Zsh
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
                        conf = "cd /home/oscar/nixos/config/";
                        dot = "cd /home/oscar/nixos";
                        hypr = "nvim /home/oscar/nixos/config/hypr/hyprland.lua";
                        freespace = "sudo nix-collect-garbage -d; sudo nixos-rebuild switch --flake /home/oscar/nixos";
                        rocketserver = "ssh oscar@192.168.88.32";
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

# Icons 
  home.file.".icons/hicolor/scalable/apps".source = ./desktop-files/icons;
}
