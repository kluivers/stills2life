jbw-stills2life
===============

An OS X commandline utility to create a movie file from a sequence of still images. Useful for creating a timelapse movie for example.

By **Joris Kluivers**

- Follow [@kluivers on Twitter][twitter]

## Usage

The utility expects two command line arguments

    ./stills2life image-directory/ output.mp4
    
Where:

 - **image-directory** is a directory path from which the input images will be read
 - **output.mp4** is the destination movie file

Currently the fps used for the movie is hardcoded in `main.m`, this will be an optional command line parameter in the future.

[twitter]: http://twitter.com/kluivers
