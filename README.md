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
    
## License

    The MIT License (MIT)
     
    Copyright (c) 2014 Joris Kluivers
        
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
      
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    

[twitter]: http://twitter.com/kluivers
