# imported by lib.my.mkHost
{ inputs, config, lib, pkgs, ... }:
with lib;
with lib.my;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ]
  ++ (mapModulesRec' (toString ./modules) import);
  environment.variables = {
    DOTFILES = config.dotfiles.dir;
    DOTFILES_BIN = config.dotfiles.binDir;
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  nix =
    let filteredInputs = filterAttrs (n: _: n != "self") inputs;
        nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
        registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      nixPath = nixPathInputs ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
      registry = registryInputs // { dotfiles.flake = inputs.self; };
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        auto-optimise-store = true;
      };
    };

  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";
  networking.useDHCP = mkDefault false;
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = mkDefault pkgs.linuxPackages_6_1;
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
    ];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
  };
  environment.systemPackages = with pkgs; [
    bind
    cached-nix-shell
    git
    tmux
    wget
    gnumake
    unzip
  ];
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
    neovim = {
      enable = true;
      withPython3 = true;
      viAlias = true;
      vimAlias = true;
    };
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  system.copySystemConfiguration = true;
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "22.11";
}