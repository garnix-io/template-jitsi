{
  description = "Jitsi";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    garnix-lib.url = "github:garnix-io/garnix-lib";
  };

  outputs = inputs : {
    nixosConfigurations.jitsi = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.garnix-lib.nixosModules.garnix
        # This is where the work happens
        ./hosts/jitsi.nix
      ];
    };
  };
}
