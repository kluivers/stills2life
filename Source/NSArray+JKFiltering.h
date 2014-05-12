//
//  NSArray+JKFiltering.h
//  still2life
//
//  Created by Joris Kluivers on 12/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JKFiltering)

- (NSArray *) jk_filter:(BOOL(^)(id obj))filterBlock;

@end
