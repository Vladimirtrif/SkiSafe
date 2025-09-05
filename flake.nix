{
  description = "File to declare dependencies, build docker image, run it locally, and deploy to the cloud";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # Python environment for the project. Defines dependencies and libraries used for training the model
      pythonEnv = pkgs.python3.withPackages (
        ps: with ps; [
          numpy
        ]
      );

      devEnv = [
        pythonEnv
        pkgs.docker
      ];

      # docker image definition
      dockerImage = pkgs.dockerTools.buildImage {
        name = "SkiSafe-train-image";
        tag = "latest";
        copyToRoot = pkgs.buildEnv {
          name = "image-env";
          paths = [
            pythonEnv
            ./.
          ];
          pathsToLink = [
            "/bin"
            "/src"
            "/Data"
          ];
        };
        config = {
          WorkingDir = "/src";
          Env = [ "PATH=/bin/" ];
          Cmd = [
            "${pythonEnv}/bin/python"
            "train.py"
          ];
        };
      };

    in
    {
      # "nix develop" : Enters into Dev shell (if needed to debug, etc)
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          devEnv
        ];
        shellHook = ''
          echo "Entering dev environment"
        '';
      };

      apps.${system} = {

        # "nix run .#buildImage" : builds the docker image and places it in ./bin
        buildImage = {
          type = "app";
          program =
            (pkgs.writeShellApplication {
              name = "build-image";
              runtimeInputs = [ pythonEnv ];
              text = ''
                mkdir -p ./bin
                cp -f ${dockerImage} ./bin/skisafe-train-image.tar.gz
              '';
            })
            + "/bin/build-image";
        };
      };
    };
}
