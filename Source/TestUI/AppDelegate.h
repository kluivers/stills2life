//
//  AppDelegate.h
//  TestUI
//
//  Created by Joris Kluivers on 25/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSProgress *taskProgress;

@end
