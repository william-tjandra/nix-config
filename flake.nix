{
  description = "Portable Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Define the systems you want to support
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate outputs for all systems
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          
          # Import our modules, passing 'pkgs' into them
          commonPackages = import ./pkgs/default.nix     { inherit pkgs; };
          commonLogic    = import ./modules/common.nix   { inherit pkgs; };
          suse           = import ./modules/opensuse.nix { inherit pkgs; };
        in {
          
          # The base target (Run: nix profile add .#default)
          default = pkgs.buildEnv {
            name = "base-env";
            paths = commonPackages ++ commonLogic.customScripts;
          };

          # The "openSUSE" target (Run: nix profile add .#opensuse)
          # This runs default AND adds the SUSE tools
          opensuse = pkgs.buildEnv {
            name = "opensuse-env";
            paths = commonPackages ++ commonLogic.customScripts ++ suse.linuxTools;
          };
          
        }
      );
    };
}
