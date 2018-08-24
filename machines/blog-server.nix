{ pkgs, ... }:
{ boot.loader.grub.device =
    "/dev/sda";

  fileSystems."/" =
    { device =
        "/dev/disk/by-uuid/303456ae-be43-44c5-9e7a-be1af285b470";

      fsType =
        "ext4";
    };

  nixpkgs.overlays =
    [ ( import ../nix/overlay.nix ) ];

  services.nginx =
    { enable =
        true;

      virtualHosts."my-blog.example.com" =
        { enableACME =
            true;

          forceSSL =
            true;

          locations."/".alias =
            "${pkgs.my-blog}/";
        };
    };
}
