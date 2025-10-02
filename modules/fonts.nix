{
  flake.modules.homeManager.home = {pkgs, ...}: {
    home.packages = with pkgs; [
      cascadia-code
      nerd-fonts.caskaydia-cove
    ];

    fonts.fontconfig.enable = true;
  };
}
