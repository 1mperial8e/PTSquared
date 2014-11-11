//
//  PTProfileManager.m
//  PTSquared
//
//  Created by Kirill on 11/11/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTProfileManager.h"

@implementation PTProfileManager

#pragma mark - Initialisation

+ (instancetype)sharedManager
{
    static PTProfileManager *sharedManger = nil;
    static dispatch_once_t token;
    dispatch_once (&token, ^ {
        sharedManger = [[PTProfileManager alloc] init];
    });
    return sharedManger;
}

#pragma mark - Public

- (void)setupWithProfile:(ProfileType)profileType
{
    if (self) {
        self.profileType = profileType;
    }
}


@end
