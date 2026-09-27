{
  description = "Dell G15 NixOS Flake with NVIDIA, Steam, treefmt, and pre-commit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, treefmt-nix, git-hooks-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixpkgs-fmt.enable = true; # Formatter for .nix files
        programs.rustfmt.enable = true;     # Formatter for .rs files
      };

      gitHooks = git-hooks-nix.lib.${system}.run {
        src = ./.;
        hooks = {
          treefmt = {
            enable = true;
            package = treefmtEval.config.build.wrapper;
          };
        };
      };
    in
    {
       formatter.${system} = treefmtEval.config.build.wrapper;

      
      devShells.${system}.default = pkgs.mkShell {
        inherit (gitHooks) shellHook;
        buildInputs = gitHooks.enabledPackages ++ [
          treefmtEval.config.build.wrapper
          pkgs.git
        ];
      };

      
      nixosConfigurations.dell-g15 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
    };
}
