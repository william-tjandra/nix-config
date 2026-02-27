{ pkgs }:

{
  # We put custom scripts and shared configurations here
  customScripts = with pkgs; [
    
    # This creates a command called "sys-update" that you can run in your terminal
    (writeShellScriptBin "sys-update" ''
      echo "Pulling latest changes from Git..."
      git -C ~/.config/nix-config pull

      echo "Updating Nix Flake lockfile..."
      nix flake update --flake ~/.config/nix-config

      echo "Upgrading Nix Profile..."
      nix profile upgrade '.*'

      echo "System updated successfully!"
    '')

    # You can add more custom scripts here separated by spaces
    # (writeShellScriptBin "another-script" '' ... '')
  ];
}
