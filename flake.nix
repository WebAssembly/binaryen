{
  description = "Binaryen development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
            ninja
            clang_19
            python3
          ];
          shellHook = ''
            export CC=${pkgs.clang_19}/bin/clang
            export CXX=${pkgs.clang_19}/bin/clang++
          '';
        };
      });
}
