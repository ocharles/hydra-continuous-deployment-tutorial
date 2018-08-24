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
}
