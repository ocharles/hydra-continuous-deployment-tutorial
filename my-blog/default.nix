{ stdenv, blog-engine }:
stdenv.mkDerivation
  { name = "my-blog";

    src = ./.;

    buildInputs = [ blog-engine ];

    buildPhase = ''
      blog-engine build
    '';

    installPhase = ''
      mv _site $out
    '';
  }
