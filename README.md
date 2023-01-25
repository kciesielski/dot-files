# dot-files

Install nix:
https://nixos.org/manual/nix/stable/installation/installing-binary.html#multi-user-installation

Building for the first time:
```sh
nix build .#homeConfigurations.kc.activationPackage
result/activate
```
After that configurations can be switched using:
```sh
home-manager switch --flake path:/home/kc/workspace/dot-files
```
