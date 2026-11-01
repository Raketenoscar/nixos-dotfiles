{
  description = "Rocketflake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, flatpak, home-manager, ... }: 
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {

         home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.oscar = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
