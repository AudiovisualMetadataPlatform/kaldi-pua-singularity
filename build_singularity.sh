#!/bin/bash

TYPE=$1

if [ "x$TYPE" == "x" ]; then
    echo "Usage: $0 <cpu|gpu>"
    exit 1
fi

case $TYPE in
    cpu)
        TAG=latest        
        ;;
    gpu)
        TAG=gpu-latest
        ;;
    *)
        echo "Type must be either 'cpu' or 'gpu'"
        exit 2
        ;;

esac

if [ "x$TMPDIR" == "x" ]; then
    export SINGULARITY_TMPDIR=/tmp
else
    export SINGULARITY_TMPDIR=$TMPDIR
fi
echo "Building singularity image in $SINGULARITY_TMPDIR -- hope there's space!"
echo "   (We'll need ~13G here, and probably 40-50G in the temp directory)"

echo "Downloading exp2.tar.gz or checking sha1"
if [ ! -e exp2.tar.gz ] ||  ! sha1sum -c exp2.tar.gz.sha1 ; then 
    rm -f exp2.tar.gz
    #wget https://sourceforge.net/projects/popuparchive-kaldi/files/exp2.tar.gz
    wget http://xtra.arloproject.com/datasets/kaldi-pop-up-archive/model_data/exp2.tar.gz
fi

echo "Preparing Singularity recipe file"
sed -e "s/__TAG__/$TAG/g" < Singularity.in >Singularity.$TYPE

echo "Beginning build"
rm -f kaldi-pua-$TYPE.sif

if [ $TYPE == gpu ]; then
    # The GPU base image breaks when doing the apt-update because of selinux stuff
    # It could be because I'm building an ubuntu image on fedora, but in any case,
    # it needs to work.  To do it, I can't use the fakeroot option and I have to
    # be root to make it happen.  Grrr.
    sudo -E singularity build kaldi-pua-$TYPE.sif Singularity.$TYPE
else
    singularity build --fakeroot kaldi-pua-$TYPE.sif Singularity.$TYPE
fi
