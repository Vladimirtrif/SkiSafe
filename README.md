# SkiSafe

To do: project descrition

### Installing Dependencies
This project uses docker for deployment, so install docker and  
you will be able to build the image from the Dockerfile and run it.

### Installing Dependencies (Nix)
Alternatively, you can install nix (the package manager): [here]{https://nixos.org/download/}
This will download docker and all dependencies for you in an isolated environment. 
Optional: enable flakes in the nix config (so you don't have to add --experimental-features nix-command flakes) to each command  
In the config (~/.config/nix/nix.conf) add:

```
experimental-features = nix-command flakes
```

Then you will have acess to the following commands (from project root):

`nix develop` : Creates and enters a dev shell with docker available to you  
`nix run .#buildImage` : Builds the image, zips it and places it int0 ./bin  
`nix run` : Executes .#buildImage, then runs it in docker

### Project Structure
./bin : Used for zipped images (ignored by git)  
./Data : Used for training and testing data. Required, but not tracked by git  
./src : source code for the model  
./Scratch : scratchpad folder, not used by the docker image  
./requirements.txt : The list of python dependencies for pip
