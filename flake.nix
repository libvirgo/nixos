{
  description = "LibVirgo's NixOS Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    # Extras
#    emacs-overlay.url  = "github:nix-community/emacs-overlay";
#    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@ { self, nixpkgs, nixpkgs-unstable, ... }:
  let
    inherit (lib.my) mapModules mapModulesRec mapHosts;
    lib = nixpkgs.lib.extend (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
    system = "x86_64-linux";
      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;  # forgive me Stallman senpai
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      pkgs  = mkPkgs nixpkgs [ self.overlay ];
      pkgs' = mkPkgs nixpkgs-unstable [];
  in
  {
    lib = lib.my;
    overlay = self: super: {
      unstable = pkgs';
      my = self.packages."${system}";
    };
    overlays = mapModules ./overlays import;
    packages."${system}" = mapModules ./packages (p: pkgs.callPackage p {});
    nixosModules = { dotfiles = import ./.; } // mapModulesRec ./modules import;
    nixosConfigurations = mapHosts ./hosts {};
  };
}
