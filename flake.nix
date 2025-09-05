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
          pkgs.docker
          pythonEnv
        ];
        shellHook = ''
          echo "Entering dev environment"
        '';
      };

      apps.${system} = {

        # "nix run .#buildImage" : builds the docker image, places it in ./bin, and loads it
        buildImage = {
          type = "app";
          program =
            (pkgs.writeShellApplication {
              name = "buildImage";
              runtimeInputs = [ pythonEnv ];
              text = ''
                mkdir -p ./bin
                cp -f ${dockerImage} ./bin/skisafe-train-image.tar.gz
              '';
            })
            + "/bin/buildImage";
        };

        # "nix run" : builds and runs the docker image, removing the old one with the same tag and its container
        default = {
          type = "app";
          program =
            (pkgs.writeShellApplication {
              name = "dockerRun";
              runtimeInputs = with pkgs; [ docker ];
              text = ''
                nix run .#buildImage
                (docker ps -a -q --filter "ancestor=skisafe-train-image:latest" | xargs docker rm -f) || true
                docker rmi skisafe-train-image:latest -f || true
                docker load -i ./bin/skisafe-train-image.tar.gz
                docker run skisafe-train-image
              '';
            })
            + "/bin/dockerRun";
        };

        # "nix run .#localRun" : runs everything locally without docker, good for testing
        localRun = {
          type = "app";
          src = ./.;
          program =
            (pkgs.writeShellApplication {
              name = "localRun";
              runtimeInputs = [
                pythonEnv
              ];
              text = ''
                python ./src/train.py
              '';
            })
            + "/bin/localRun";
        };
      };
    };
}
