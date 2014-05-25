stills2life
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

## Tracking progress

Generating a movie file from a large amount of images can take a few seconds. `stills2life` reports it's mp4 generation progress using a `NSProgress` instance. This allows other Cocoa processes to tap into this data.

Provided you have `NSURL` pointing to the `output.mp4` file specified as second command line argument you can track the generation progress using: 

    [NSProgress addSubscriberForFileURL:fileURL withPublishingHandler:^NSProgressUnpublishingHandler(NSProgress *progress) {
        // observe progress here
        
        return nil;
    }];
    

[twitter]: http://twitter.com/kluivers
