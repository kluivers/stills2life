//
//  NSURL+JBWRelativeFilePath.h
//  still2life
//
//  Created by Joris Kluivers on 12/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (JBWRelativeFilePath)

+ (NSURL *) fileURLWithPossibleRelativePath:(NSString *)path;

@end
