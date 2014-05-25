//
//  JBWMovieGenerator.m
//  still2life
//
//  Created by Joris Kluivers on 12/05/14.
//  Copyright (c) 2014 Joris Kluivers. All rights reserved.
//

#import <AppKit/AppKit.h>

@import AVFoundation;

#import "JBWMovieGenerator.h"

#import "NSArray+JKFiltering.h"

@interface JBWMovieGenerator ()
@property(nonatomic, strong) NSArray *imageURLs;
@property(nonatomic, assign) NSUInteger framesPerSecond;
@end

@implementation JBWMovieGenerator

+ (instancetype) generatorWithImageURLs:(NSArray *)imageURLs framesPerSecond:(NSUInteger)fps
{
    JBWMovieGenerator *generator = [[self alloc] init];
    
    generator.imageURLs = [imageURLs jk_filter:^(NSURL *imageURL) {
        return [[imageURL pathExtension] isCaseInsensitiveLike:@"jpg"];
    }];
    generator.framesPerSecond = fps;
    
    return generator;
}

- (void) writeToFileAtURL:(NSURL *)fileURL
{
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:[self.imageURLs count]];
    [progress setUserInfoObject:fileURL forKey:NSProgressFileURLKey];
    progress.pausable = NO;
    
    [progress publish];
    
    NSImage *firstImage = [[NSImage alloc] initWithContentsOfURL:self.imageURLs[0]];
    
    CGSize frameSize = firstImage.size;
    
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:fileURL fileType:AVFileTypeQuickTimeMovie error:&error];
    
    if (!videoWriter) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    NSDictionary *settings = @{
        AVVideoCodecKey: AVVideoCodecH264,
        AVVideoWidthKey: @(frameSize.width),
        AVVideoHeightKey: @(frameSize.height)
    };
    
    BOOL canApplySettings = [videoWriter canApplyOutputSettings:settings forMediaType:AVMediaTypeVideo];
    if (!canApplySettings) {
        NSLog(@"Cannot apply media settings for output");
        return;
    }
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
    
    NSDictionary *attributes = @{
        (id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32ARGB),
        (id)kCVPixelBufferWidthKey: @(frameSize.width),
        (id)kCVPixelBufferHeightKey: @(frameSize.height)
    };
    
    AVAssetWriterInputPixelBufferAdaptor *adapter = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:attributes];
    
    [videoWriter addInput:writerInput];
    
    // needed?
//    writerInput.expectsMediaDataInRealTime = YES;
    
    BOOL start = [videoWriter startWriting];
    if (!start) {
        NSLog(@"Failed to start writing");
        return;
    }
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    
    for (int i=0; i<[self.imageURLs count]; i++) {
        
        if ([progress isCancelled]) {
            break;
        }
        
        NSURL *imageURL = self.imageURLs[i];
    
        buffer = [self fastImageFromImageURL:imageURL];
        if (!buffer) {
            [progress setCompletedUnitCount:i+1];
            continue;
        }
        
        while (!writerInput.readyForMoreMediaData) {
            NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
            [[NSRunLoop currentRunLoop] runUntilDate:maxDate];
        }
        
        CMTime currentTime = CMTimeMake(i, (int32_t)self.framesPerSecond);
        
        BOOL result = [adapter appendPixelBuffer:buffer withPresentationTime:currentTime];
        
        if (!result) {
            NSLog(@"Failed to write frame to movie: %@", [videoWriter error]);
        }
        
        [progress setCompletedUnitCount:i+1];
        
        CVBufferRelease(buffer);
    }
    
    __block BOOL ready = NO;
    [videoWriter finishWritingWithCompletionHandler:^{
        ready = YES;
    }];
    
    while (!ready) {
        NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
        [[NSRunLoop currentRunLoop] runUntilDate:maxDate];
    }
}

- (CVPixelBufferRef)fastImageFromImageURL:(NSURL *)imageURL
{
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:imageURL];
    if (!image) {
        return NULL;
    }
    
    CVPixelBufferRef buffer = NULL;
    
    // config
    size_t width = [image size].width;
    size_t height = [image size].height;
    size_t bitsPerComponent = 8; // *not* CGImageGetBitsPerComponent(image);
    CGColorSpaceRef cs = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGBitmapInfo bi = kCGImageAlphaNoneSkipFirst; // *not* CGImageGetBitmapInfo(image);
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey, [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    
    // create pixel buffer
    CVPixelBufferCreate(kCFAllocatorDefault, width, height, k32ARGBPixelFormat, (CFDictionaryRef)CFBridgingRetain(d), &buffer);
    CVPixelBufferLockBaseAddress(buffer, 0);
    void *rasterData = CVPixelBufferGetBaseAddress(buffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    // context to draw in, set to pixel buffer's address
    CGContextRef ctxt = CGBitmapContextCreate(rasterData, width, height, bitsPerComponent, bytesPerRow, cs, bi);
    if(ctxt == NULL){
        NSLog(@"could not create context");
        return NULL;
    }
    
    // draw
    NSGraphicsContext *nsctxt = [NSGraphicsContext graphicsContextWithGraphicsPort:ctxt flipped:NO];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsctxt];
    [image drawAtPoint:NSMakePoint(0, 0) fromRect:NSMakeRect(0.0, 0.0, width, height) operation:NSCompositeCopy fraction:1.0];
    //[image compositeToPoint:NSMakePoint(0.0, 0.0) operation:NSCompositeCopy];
    [NSGraphicsContext restoreGraphicsState];
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    CFRelease(ctxt);
    
    return buffer;
}

@end
