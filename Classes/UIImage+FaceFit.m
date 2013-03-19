//
//  UIImage+FaceClip.m
//  UIImageFaceClipDemo
//
//  Created by Zeng Ke on 13-3-19.
//  Copyright (c) 2013年 zengke. All rights reserved.
//

#import "UIImage+FaceFit.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (FaceFit)

- (CGRect)frameToClip:(CGSize)viewSize {
    CGSize imageSize = self.size;
    if (viewSize.width / viewSize.height > imageSize.width / imageSize.height) {
        // wider
        CGFloat newImageHeight = viewSize.height * imageSize.width / viewSize.width;
        return CGRectMake(0, (imageSize.height - newImageHeight)/2, imageSize.width, newImageHeight);
    } else {
        CGFloat newImageWidth = viewSize.width * imageSize.height / viewSize.height;
        return CGRectMake((imageSize.width - newImageWidth)/2, 0, newImageWidth, imageSize.height);
    }
}


- (UIImage *)faceImageConstrainedToSize:(CGSize)viewSize {
    CIImage * ciImage = [CIImage imageWithCGImage:self.CGImage];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    NSArray * features = [detector featuresInImage:ciImage];
    CGFloat maxSize = 0;
    CGRect faceBounds;
    for (CIFaceFeature * feature in features) {
        CGRect bounds = feature.bounds;
        // or use the UIImage wherever you like
        if (maxSize < bounds.size.width * bounds.size.height) {
            maxSize = bounds.size.width * bounds.size.height;
            faceBounds = CGRectMake(bounds.origin.x, self.size.height - bounds.origin.y - bounds.size.height, bounds.size.width, bounds.size.height);
        }
    }
    if (maxSize <= 0) {
        return self;
    }
    CGPoint faceCenter = CGPointMake((faceBounds.origin.x + faceBounds.size.width)/2,
                                    (faceBounds.origin.y + faceBounds.size.height)/2);
    CGPoint startCenter = CGPointMake(self.size.width/2, self.size.height/2);
    CGRect clipedFrame = [self frameToClip:viewSize];
    CGPoint origin = clipedFrame.origin;
    CGSize clipedRange = CGSizeMake(abs(origin.x), abs(origin.y));
    CGPoint vector = CGPointMake(faceCenter.x - startCenter.x, faceCenter.y - startCenter.y);
    CGPoint offset = CGPointMake(MIN(MAX(-clipedRange.width, vector.x), clipedRange.width),
                                 MIN(MAX(-clipedRange.height, vector.y), clipedRange.height));
    clipedFrame = CGRectMake(clipedFrame.origin.x + offset.x, clipedFrame.origin.y + offset.y, clipedFrame.size.width, clipedFrame.size.height);    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], clipedFrame);
    UIImage * tImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return tImage;
}

@end
