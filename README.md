# dot-files

## CLI utils
If you're here just to check all the cool CLI utils I'm using, go straight to home.nix and view the `CLI utils` section, 
or use the `cli` command available after configuring dotfiles to display it.

## Usage
Install nix in multi-user mode:
https://nixos.org/manual/nix/stable/installation/installing-binary.html#multi-user-installation

Configure:
1. Append to `/etc/nix/nix.conf`:
```
extra-experimental-features = nix-command flakes
```

Building for the first time:
```sh
nix build .#homeConfigurations.kc.activationPackage
result/activate
```

After that configurations can be switched using:
```sh
home-manager switch --flake path:/home/kc/workspace/dot-files
```

To update nixpkgs, use `nix flake lock --update-input nixpkgs`
To update all, use `nix flake lock --update-all`
After updating nixpkgs, use `home-manager switch ...` to apply updates
