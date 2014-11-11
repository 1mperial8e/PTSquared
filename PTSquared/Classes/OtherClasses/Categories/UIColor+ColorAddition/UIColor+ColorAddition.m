//
//  UIColor+ColorAddition.m
//  PTSquared
//
//  Created by Kirill on 11/11/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "UIColor+ColorAddition.h"

@implementation UIColor (ColorAddition)

+ (UIColor *)colorFromImage:(NSString *)imageName
{
    return [UIColor colorWithPatternImage:[UIImage imageNamedFile:imageName]];
}

@end
