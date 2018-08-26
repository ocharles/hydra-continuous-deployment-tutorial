{ nixpkgs
, declInput ? {}
}:

let
  pkgs =
    import nixpkgs {};

  make-jobset =
    { description, github }:
    { inherit description;
      enabled = 1;
      hidden = false;
      nixexprpath = "hydra/jobs.nix";
      nixexprinput = "src";
      checkinterval = 5;
      schedulingshares = 100;
      enableemail = false;
      emailoverride = "";
      keepnr = 3;
      inputs =
        { src =
            { type = "git";
              value = "git://github.com/${ github.owner }/${ github.repo } ${ github.ref }";
              emailresponsible = false;
            };
        };
    };

  jobsetAttrs =
    { master =
        make-jobset
          { description = "master";
            github =
              { owner = "circuithub";
                repo = "mono";
                ref = "master";
              };
          };
    };

  jobsetJson =
    pkgs.writeText "spec.json" ( builtins.toJSON jobsetAttrs );

in
{ jobsets =
    pkgs.runCommand
      "spec.json"
      {}
      ''
        cp ${jobsetJson} $out
      '';
}
