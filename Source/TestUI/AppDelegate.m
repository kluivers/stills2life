//
//  AppDelegate.m
//  TestUI
//
//  Created by Joris Kluivers on 25/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property(nonatomic, weak) IBOutlet NSTextField *inputPathField;
@property(nonatomic, weak) IBOutlet NSTextField *outputPathField;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction) selectImagesDirectory:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        NSURL *inputURL = [panel.URLs firstObject];
    
        [self.inputPathField setStringValue:[inputURL path]];
    }];
}

- (IBAction) selectOutputFile:(id)sender
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    [panel setAllowedFileTypes:@[@"mp4"]];
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        NSURL *outputURL = [panel URL];
        
        [self.outputPathField setStringValue:[outputURL path]];
    }];
}

- (IBAction) createMovie:(id)sender
{
    NSURL *fileURL = [NSURL fileURLWithPath:[self.outputPathField stringValue]];
    [NSProgress addSubscriberForFileURL:fileURL withPublishingHandler:^NSProgressUnpublishingHandler(NSProgress *progress) {
        self.taskProgress = progress;
        
        return nil;
    }];
    
    NSString *executablePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"stills2life"];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:executablePath];
    
    [task setArguments:@[
        [self.inputPathField stringValue],
        [self.outputPathField stringValue]
    ]];
    
    [task setTerminationHandler:^(NSTask *finishedTask) {
        NSLog(@"Task done running");
    }];
    
    [task launch];
}

@end
