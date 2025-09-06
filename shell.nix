{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_20
    yarn
  ];

  shellHook = ''
    echo "Slidev development environment"
    echo "Run 'yarn install' to install dependencies"
    echo "Run 'yarn dev' to start the development server"
  '';
}