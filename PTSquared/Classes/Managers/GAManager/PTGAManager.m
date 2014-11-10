//
//  PEGAManager.m
//  Periop
//
//  Created by Stas Volskyi on 30.10.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTGAManager.h"
#import "GAIDictionaryBuilder.h"

static NSString *const GATrackingID = @"PASTE REGISTERED APPLICATION ID HERE";
static NSString *const GATimeInterval = @"timeIntervalCaptured";
static NSString *const GATargetURLSocialAnalysing = @"https://developers.google.com/analytics";

@interface PTGAManager()

@property (strong, nonatomic) NSDictionary *requestTypeDescription;

- (NSDictionary *)configureRequestTypes;
- (void)saveLaunchDate;
- (NSInteger)calculateTimeBetweenLaunch;

@end

@implementation PTGAManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[GAI sharedInstance] trackerWithTrackingId:GATrackingID];
        self.tracker = [[GAI sharedInstance] defaultTracker];
        [GAI sharedInstance].dispatchInterval = 20;
        self.requestTypeDescription = [self configureRequestTypes];
    }
    return self;
}

#pragma mark - Singleton

+ (instancetype)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t tocken;
    dispatch_once(&tocken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Public

- (void)trackClientDownloads
{
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Client" action:@"Download" label:nil value:@1] build]];
}

- (void)trackSocialMediaSharing:(NSString *)mediaTypeName
{
    [self.tracker send:[[GAIDictionaryBuilder createSocialWithNetwork:mediaTypeName action:@"Sharing" target:GATargetURLSocialAnalysing] build]];
}

- (void)trackRequestToPersonalTraining:(RequestType)kRequestType
{
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Personal Trainer" action:@"Request" label:[self.requestTypeDescription objectForKey:@(kRequestType)] value:@1] build]];
}

- (void)trackApplicationLaunchCount
{
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Application" action:@"Launch" label:nil value:@1] build]];
}

- (void)trackTimeBetweenLaunch
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:GATimeInterval]) {
        NSInteger interval = [self calculateTimeBetweenLaunch];
        [self.tracker send:[[GAIDictionaryBuilder createTimingWithCategory:@"Time between Launch" interval:@(interval) name:@"Interval Time" label:nil] build]];
    }
    [self saveLaunchDate];
}

#pragma mark - Private

- (NSDictionary *)configureRequestTypes
{
    NSDictionary *request = @{@(WORKOUT_REQUEST) : @"Workout",
                              @(NUTRITION_REQUEST) : @"Nutrition",
                              @(SESSION_REQUEST) : @"Session"};
    return request;
}

- (void)saveLaunchDate
{
    NSDate *launchDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:launchDate forKey:GATimeInterval];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)calculateTimeBetweenLaunch
{
    NSDate *lastDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:GATimeInterval];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastDate];
    NSInteger intervalInSeconds =  (int)interval;
    return intervalInSeconds;
}

@end
