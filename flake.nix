{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    colmena.url = "github:zhaofengli/colmena";
    xlibre.url = "git+https://codeberg.org/takagemacoed/xlibre-overlay";
  };
  outputs = { nixpkgs, colmena, xlibre, ... }: {
    colmenaHive = colmena.lib.makeHive {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          #overlays = [xlibre];
        };
      };

      nixos = {
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
