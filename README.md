# SkiSafe

To do: project descrition

### Installing Dependencies
This project uses docker for deployment, so install docker and  
you will be able to build the image from the Dockerfile and run it.

### Installing Dependencies (Nix)
Alternatively, you can install nix (the package manager): [here](https://nixos.org/download/)  
Nix will use flake.nix file to create an isolated environment with the dependencies for you and expose build scripts.  
Optional: enable flakes in the nix config to not have to add the flag to each command (--experimental-features nix-command flakes)   
In the config (~/.config/nix/nix.conf) add:

```
experimental-features = nix-command flakes
```

Then you will have acess to the following commands (from project root):

`nix develop` : Creates and enters a dev shell with docker available to you  
`nix run .#buildImage` : Builds the image, zips it and places it int0 ./bin  
`nix run` : Executes .#buildImage, then runs it in docker

### Project Structure
./bin/ : Used for zipped images (ignored by git)  
./Data/ : Used for training and testing data. Required, but not tracked by git  
./src/ : source code for the model  
./Scratch/ : scratchpad folder, not used by the docker image  
./requirements.txt : The list of python dependencies for pip
