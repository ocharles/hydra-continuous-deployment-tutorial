{ src, nixpkgs }:

let
  pkgs =
    import
      nixpkgs
      { config = {};

        overlays = [ ( import ../nix/overlay.nix ) ];
      };

in
{ blog-engine = pkgs.haskellPackages.blog-engine;

  my-blog = pkgs.my-blog;

  my-blog-server =
    let
      build =
        import
          "${ pkgs.path }/nixos"
          { configuration = import ../machines/blog-server.nix; };

    in
    build.system;
}
