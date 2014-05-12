//
//  NSArray+JKFiltering.m
//  still2life
//
//  Created by Joris Kluivers on 12/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import "NSArray+JKFiltering.h"

@implementation NSArray (JKFiltering)

- (NSArray *) jk_filter:(BOOL(^)(id obj))filterBlock
{
    NSMutableArray *newArray = [@[] mutableCopy];
    
    for (id obj in self) {
        if (filterBlock(obj)) {
            [newArray addObject:obj];
        }
    }
    
    return [NSArray arrayWithArray:newArray];
}

@end
