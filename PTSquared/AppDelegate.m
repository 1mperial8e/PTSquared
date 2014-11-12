//
//  AppDelegate.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - LifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
// login to Facebook
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession  openActiveSessionWithPublishPermissions:@[@"public_profile", @"user_friends", @"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:NO completionHandler:nil];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

@end
