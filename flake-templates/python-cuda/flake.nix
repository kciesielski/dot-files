{ pkgs ? import <nixpkgs> { }, pkgs_stable ? import <nixpkgs-stable> { } }:

let

  customNvidiaX11 = pkgs.linuxPackages.nvidia_x11_production.override {
    libsOnly = true;
    disable32Bit = true;
  };

  venvDirectory = ".venv";

  pythonPackages = pkgs.python310Packages;

in
pkgs.mkShell rec {
  name = "ai-test";
  venvDir = venvDirectory;
  buildInputs = [
    pkgs.zlib
    pkgs.stdenv.cc.cc
    pkgs.autoPatchelfHook

    # python interpreter and venv hook
    pythonPackages.python
    pythonPackages.venvShellHook

    # cuda stuff
    customNvidiaX11
    pkgs.cudaPackages_11_4.cudatoolkit
    pkgs.cudaPackages_11_4.cuda_cudart
    pkgs.cudaPackages_11_4.cudnn
  ];

  postVenvCreation = ''
    pip install -r ./requirements.txt
    autoPatchelf ${venvDirectory}
    autoPatchelf librt
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''
    autoPatchelf ${venvDirectory}
  '';

  CUDA_PATH = "${pkgs.cudaPackages_11_4.cudatoolkit}";
  LD_LIBRARY_PATH = "${customNvidiaX11}/lib:/${pkgs.cudaPackages_11_4.cudnn}/lib:${pkgs.cudaPackages_11_4.cudatoolkit}/lib64:${pkgs.cudaPackages_11_4.cudatoolkit}/lib:${pkgs.cudaPackages_11_4.cuda_cudart}/lib:librt/:$LD_LIBRARY_PATH";
}
