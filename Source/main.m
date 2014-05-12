//
//  main.m
//  still2life
//
//  Created by Joris Kluivers on 12/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSURL+JBWRelativeFilePath.h"

#import "JBWMovieGenerator.h"

static NSUInteger FPS = 12;

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSMutableArray *arguments = [@[] mutableCopy];
        
        for (int i=0; i<argc; i++) {
            [arguments addObject:[NSString stringWithUTF8String:argv[i]]];
        }
        
        if ([arguments count] < 3) {
            NSLog(@"Usage: ./still2life image-directory/ output.mp4");
            return 1;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *sourceURL = [NSURL fileURLWithPossibleRelativePath:arguments[1]];
        
        NSError *contentsError = nil;
        NSArray *inputFiles = [fileManager contentsOfDirectoryAtURL:sourceURL includingPropertiesForKeys:nil options:0 error:&contentsError];
        if (!inputFiles) {
            NSLog(@"Error: %@", [contentsError localizedDescription]);
            return 1;
        }
        
        NSLog(@"Input files: %@", inputFiles);
        
        JBWMovieGenerator *generator = [JBWMovieGenerator generatorWithImageURLs:inputFiles framesPerSecond:FPS];
        
        NSURL *movieURL = [NSURL fileURLWithPossibleRelativePath:arguments[2]];
        [generator writeToFileAtURL:movieURL];
    }
    return 0;
}

