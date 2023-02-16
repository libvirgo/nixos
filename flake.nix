{
  description = "LibVirgo's NixOS Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-cn = {
      url = "github:nixos-cn/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs:
  let
    system = "x86_64-linux";
    HOST = "ragdoll";
  in
  {
    nixosConfigurations."${HOST}" = nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules =
      [
        (./. + "/hosts/${HOST}/configuration.nix")
	    home-manager.nixosModules.home-manager
	    {
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        environment = {
              sessionVariables = {
                XDG_CACHE_HOME  = "$HOME/.cache";
                XDG_CONFIG_HOME = "$HOME/.config";
                XDG_DATA_HOME   = "$HOME/.local/share";
                XDG_BIN_HOME    = "$HOME/.local/bin";
              };
	        };
	        home-manager.extraSpecialArgs = { inherit inputs; };
	        home-manager.users.sakura = import ./home.nix;
	    }
      ];
    };
  };
}
