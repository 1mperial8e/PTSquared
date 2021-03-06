//
//  UIImage+ImageWithJPGFile.h
//  Periop
//
//  Created by Kirill on 10/2/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

@interface UIImage (ImageAddition)

+ (UIImage *)imageNamedFile:(NSString *)imageNameInLocalBundle;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
