{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = [
    pkgs.just
		pkgs.watchexec
  ];

  shellHook = 
    ''
      export LUA_PATH="$(pwd)/lua/github-utils/?.lua;$LUA_PATH"

      # FILES=$(find "$(pwd)" -type f -name "*.lua")
      # export LUA_PATH=$(echo "$FILES" | tr '\n' ';')
    '';
}


