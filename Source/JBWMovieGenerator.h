//
//  JBWMovieGenerator.h
//  still2life
//
//  Created by Joris Kluivers on 12/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBWMovieGenerator : NSObject

+ (instancetype) generatorWithImageURLs:(NSArray *)imageURLs framesPerSecond:(NSUInteger)fps;

- (void) writeToFileAtURL:(NSURL *)fileURL;

@end
