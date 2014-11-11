//
//  PTProfileManager.h
//  PTSquared
//
//  Created by Kirill on 11/11/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

typedef enum {
    PERSONAL_TRAINER,
    CLIENT
} ProfileType;

@interface PTProfileManager : NSObject

@property (assign, nonatomic) ProfileType profileType;

+ (instancetype)sharedManager;

- (void)setupWithProfile:(ProfileType)profileType;

@end