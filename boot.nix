{
  boot = {
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
        };
        efi.canTouchEfiVariables = true;
      };
      plymouth = {
          enable = true;
          theme = "Pixels"
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "Pixels" ];
            })
          ];
        };
    };
  }
