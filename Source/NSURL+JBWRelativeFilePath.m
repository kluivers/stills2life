//
//  NSURL+JBWRelativeFilePath.m
//  still2life
//
//  Created by Joris Kluivers on 12/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import "NSURL+JBWRelativeFilePath.h"

@implementation NSURL (JBWRelativeFilePath)

+ (NSURL *) fileURLWithPossibleRelativePath:(NSString *)path
{
    if ([path isAbsolutePath]) {
        return [self fileURLWithPath:path];
    }
    
    NSString *currentPath = [[NSFileManager defaultManager] currentDirectoryPath];
    NSURL *currentPathURL = [NSURL fileURLWithPath:currentPath];
    
    return [NSURL URLWithString:path relativeToURL:currentPathURL];
}

@end
