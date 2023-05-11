{ pkgs ? import <nixpkgs> { }, pkgs_stable ? import <nixpkgs-stable> { } }:

let
  venvDirectory = ".venv";
  pythonPackages = pkgs.python310Packages;

in
pkgs.mkShell rec {
  name = "ai-test";
  venvDir = venvDirectory;
  buildInputs = [
    # python interpreter and venv hook
    pythonPackages.python
    pythonPackages.venvShellHook

  ];

  postVenvCreation = ''
    pip install -r ./requirements.txt
    autoPatchelf ${venvDirectory}
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''
    autoPatchelf ${venvDirectory}
  '';
}
