{ pkgs, ... }:

{
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
}
