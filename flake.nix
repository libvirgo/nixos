{
  description = "LibVirgo's NixOS Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

#    emacs-overlay.url = "github:nix-community/emacs-overlays";
    nixos-cn = {
      url = "github:nixos-cn/flakes";
      # 强制 nixos-cn 和该 flake 使用相同版本的 nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs:
  let
    system = "x86_64-linux";
    HOST = "ragdoll";
  in
  {
    # overlays = [ ./overlays/emacs-overlay.nix ] ++ ./overlays;
    nixosConfigurations."${HOST}" = nixpkgs.lib.nixosSystem {
      system = "${system}";
      # overlays = map (f: f.overlay) [ emacs-overlay ];
      modules = let defaults = { pkgs, ...}: {
        _module.args.nixpkgs-unstable = import inputs.nixpkgs-unstable {
          inherit (pkgs.stdenv.targetPlatform) system;
          config.allowUnfree = true;
        };
      };
      in
      [
        defaults
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
	        home-manager.users.sakura = import ./home.nix;
	    }
      ];
    };
  };
}
