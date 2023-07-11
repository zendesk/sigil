{
  description = "Zendesk fork of Sigil";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        zd-sigil = pkgs.buildGoModule {
          pname = "zd-sigil";
          version = "0.8.1";
          src = ./.;
          vendorSha256 = "sha256-GJ83KdSD5P30HQn2PYX7WdiLXIKkiU8vWHZls1Ne7RM=";
          doCheck = false;
        };
      in {
        packages = rec {
          inherit zd-sigil;
          default = zd-sigil;
        };
        apps = rec {
          zd-sigil = flake-utils.lib.mkApp {
            drv = self.packages.${system}.zd-sigil;
            exePath = "/bin/sigil";
          };
          default = zd-sigil;
        };
      });
}
