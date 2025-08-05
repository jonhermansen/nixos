{
  inputs = {
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xlibre = {
      url = "git+https://codeberg.org/jonhermansen/xlibre-overlay?ref=nvidia-470-testing";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { colmena, nixpkgs, xlibre, ... }: {
    colmenaHive = colmena.lib.makeHive {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      };

      desktop = {
        imports = [
          ./configuration.nix
          xlibre.nixosModules.overlay-xlibre-xserver
          xlibre.nixosModules.overlay-all-xlibre-drivers
          xlibre.nixosModules.nvidia-ignore-ABI
        ];

        deployment.allowLocalDeployment = true;
      };
    };
  };
}
