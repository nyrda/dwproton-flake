# DW-Proton for Nix

A Nix flake that packages the latest [DW-Proton](https://dawn.wine/) compatibility layer for Steam Play.

## Features

- Automatically tracks the latest DW-Proton releases
- Daily GitHub Actions workflow to check for updates
- Simple flake-based installation

## Usage

### NixOS

Add the flake to your inputs and add the package to `programs.steam.extraCompatPackages`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dw-proton.url = "github:nyrda/dwproton-flake";
  };

  outputs = { self, nixpkgs, dw-proton, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          programs.steam = {
            enable = true;
            extraCompatPackages = [
              dw-proton.packages.${pkgs.stdenv.hostPlatform.system}.dw-proton
            ];
          };
        })
      ];
    };
  };
}
```


## Development

```bash
# Enter development shell
nix develop

# Build the package
nix build
```

## Updates

This fork tracks the original packaging at <https://github.com/imaviso/dwproton-flake>.

The GitHub Actions workflow checks Dawn Winery releases daily and creates pull requests when updates are available.

## License

This packaging is provided under the MIT license. DW-Proton itself may contain proprietary components.
