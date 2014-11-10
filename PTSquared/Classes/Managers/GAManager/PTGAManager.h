//
//  PEGAManager.h
//  Periop
//
//  Created by Stas Volskyi on 30.10.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "GAI.h"

typedef enum {
    WORKOUT_REQUEST,
    NUTRITION_REQUEST,
    SESSION_REQUEST
} RequestType;

@interface PTGAManager : NSObject

@property (strong, nonatomic) id<GAITracker> tracker;

+ (instancetype)sharedManager;

- (void)trackClientDownloads;
- (void)trackSocialMediaSharing:(NSString *)mediaTypeName;
- (void)trackRequestToPersonalTraining:(RequestType)kRequestType;
- (void)trackApplicationLaunchCount;
- (void)trackTimeBetweenLaunch;

@end
