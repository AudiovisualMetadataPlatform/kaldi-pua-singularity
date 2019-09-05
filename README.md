# Singularity Kaldi + PUA

Build (working) Singularity containers with Kaldi and the Pop-Up-Archive 
training with both CPU and GPU support.

Disclaimer:  With the exception of the scripts in the top directory, all 
of the content was either pulled directly or inspired by other sources, 
including (but not limited to):
*  https://hub.docker.com/r/hipstas/kaldi-pop-up-archive/tags
*  https://github.com/kaldi-asr/kaldi/blob/master/misc/docker/ubuntu-cuda/Dockerfile
*  https://github.com/brandeis-llc/aapb-pua-kaldi-docker
*  http://xtra.arloproject.com/datasets/kaldi-pop-up-archive/repo_backups/


Also, there are some really...unpleasant...scripts in this mix.  They're not mine and I have no idea how they work, but they seem to, so hooray!

## Building the containers

The build_singularity.sh script will build the container.  It takes one 
argument:  either 'gpu' or 'cpu'.  The build process is nearly identical,
but if you select the 'gpu' option, it will require SUDO access to build
the container.  It will ask you when it's time.


## Running the container
The containers are designed to be standalone, but due to the scripts inside,
the do require a writable overlay filesystem.  The script run_kaldi.sh
takes care of it -- it will create a sparce overlay filesystem which will
be discarded when the processing has finished.

When deploying, only the .sif files and run_kaldi.sh need to be copied to
the run-time server.  

The syntax to run it is:
````
    run_kaldi.sh <mode> <media_directory>
````

The mode is either 'cpu' or 'gpu', which is used to select which image to
use.

The media_directory should hold files and the transcripts will be placed
in this directory in a transcripts directory

To test it, try:
````
./run_kaldi.sh cpu test_files
````
