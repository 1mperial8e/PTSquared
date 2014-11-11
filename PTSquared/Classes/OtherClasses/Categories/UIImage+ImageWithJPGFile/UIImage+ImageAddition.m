//
//  UIImage+ImageWithJPGFile.m
//  Periop
//
//  Created by Kirill on 10/2/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "UIImage+ImageAddition.h"

@implementation UIImage (ImageAddition)

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

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
