{
  description = "DW-Proton compatibility layer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages.${system} = {
      default = self.packages.${system}.dw-proton;
      dw-proton = pkgs.callPackage ./default.nix {};
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        curl
        jq
        nix
      ];
    };
  };
}
