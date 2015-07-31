with import <nixpkgs> { };
rec {
    nixGit = stdenv.lib.overrideDerivation nix (attrs : rec {
      src = ./.;
      #buildInputs = nix.buildInputs ++ [ bison flex bzip2 ];
      buildInputs = [ curl openssl sqlite libsodium bison flex bzip2 autoconf automake ];
      # ${nix.configureFlags}
      preConfigure = ''
        ./bootstrap.sh
        configureFlagsArray=(
          CPPFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
          LDFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-L${p}/lib") buildInputs)}"
        )
      '';
      #     CPPFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
      preBuild = ''
         export GLOBAL_CXXFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
         export GLOBAL_CFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
         export GLOBAL_LDFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-L${p}/lib") buildInputs)}"
         buildFlagsArray=(
           -j9 V=1
         )
      '';
      preInstall = ''
         export GLOBAL_CXXFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
         export GLOBAL_CFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
         export GLOBAL_LDFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-L${p}/lib") buildInputs)}"
         installFlagsArray=(
           -j9 V=1
         )
      '';
      #configureFlagsArray = nix.configureFlags ++ [
      #  CPPFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-I${p}/include") buildInputs)}"
      #  LDFLAGS="${stdenv.lib.concatStringsSep " " (map (p: "-L${p}/lib") buildInputs)}"
      #];
      #configureFlags = "";
      #doInstallCheck = "";
      #doCheck = "";
    });
    nixGitEnv = stdenv.mkDerivation rec {
      name = "nix-git-env";
      #version = "1.1.1.1";
      src = ./.;
      buildInputs = [ nix curl openssl sqlite libsodium bison flex bzip2 ];
    };
}
