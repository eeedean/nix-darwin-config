{
  config,
  lib,
  pkgs,
  ...
}: {
  # Visual Studio Code
  # https://mipmip.github.io/home-manager-option-search/?programs.vscode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      dotjoshjohnson.xml
      dracula-theme.theme-dracula
      jnoortheen.nix-ide
      mkhl.direnv
      ms-azuretools.vscode-docker
      redhat.java
      scala-lang.scala
      vscjava.vscode-gradle
      vscjava.vscode-java-debug
      vscjava.vscode-java-dependency
      vscjava.vscode-java-test
      vscjava.vscode-maven
      yzhang.markdown-all-in-one
    ];
  };
}
