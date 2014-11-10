//
//  UIImage+ImageWithJPGFile.m
//  Periop
//
//  Created by Kirill on 10/2/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "UIImage+ImageWithJPGFile.h"

@implementation UIImage (ImageWithJPGFile)

+ (UIImage *)imageNamedFile:(NSString *)imageNameInLocalBundle
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageNameInLocalBundle ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        NSString *name = [NSString stringWithFormat:@"%@@2x", imageNameInLocalBundle];
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (!image) {
        NSString *name = [NSString stringWithFormat:@"%@", imageNameInLocalBundle];
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:path];
    }
    
    return image;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end