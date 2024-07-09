{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};

	outputs =
	{ self, nixpkgs, ... }:
	let
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
		version = "1.0.3";
	in
	rec {
		packages.${system} = {
			default =
			pkgs.stdenv.mkDerivation {
				name = "autogit";
				inherit version;

				src = ./.;
			};
		};


		overlays.default = final: prev:
		{
			autogit = pkgs.callPackage packages.${system}.default {};
		};

		nixosModules.default = import ./module.nix;
	};
}