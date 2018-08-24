self:
pkgs:

let
  inherit ( pkgs.lib ) composeExtensions;

  haskellOverrides =
    _self: haskell:
    { blog-engine =
        haskell.callCabal2nix "blog-engine" ../blog-engine {};
    };

in
{
  haskellPackages =
    pkgs.haskellPackages.override
    ( old:
      { overrides =
          composeExtensions
            ( old.overrides or ( _: _: {} ) )
            haskellOverrides;
      }
    );

  my-blog =
    pkgs.callPackage
      ../my-blog/default.nix
      { inherit ( self.haskellPackages ) blog-engine; };
}
