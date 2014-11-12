//
//  TLFacebookSharing.m
//  Trill
//
//  Created by Stas Volskyi on 16.07.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTFacebookManager.h"
#import <FacebookSDK.h>

static NSString *const FSFacebookPublishPermissions = @"publish_actions";
static NSString *const FSFacebookReadPermissions = @"public_profile";
static NSString *const FSFacebookFriendsReadPermissions = @"user_friends";

@interface PTFacebookManager ()

@property (strong, nonatomic) NSMutableArray *friendsIDS;

@end

@implementation PTFacebookManager

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceTocken;
    
    dispatch_once(&onceTocken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public

- (void)loginWithFacebook
{
    if (!FBSession.activeSession.isOpen) {
        NSArray *permissions = @[FSFacebookReadPermissions, FSFacebookFriendsReadPermissions];
        FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:permissions defaultAudience:FBSessionDefaultAudienceFriends urlSchemeSuffix:nil tokenCacheStrategy:[FBSessionTokenCachingStrategy defaultInstance]];
        [FBSession setActiveSession:session];
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error || session.state == FBSessionStateClosedLoginFailed) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(failedLoginToFacebook:)]) {
                    [self.delegate failedLoginToFacebook:error];
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginToFacebookSuccessful)]) {
                    [self.delegate loginToFacebookSuccessful];
                }
                if ([FBSession.activeSession.permissions indexOfObject:FSFacebookPublishPermissions] == NSNotFound && status == FBSessionStateOpen) {
                    [self requestPublishPermissions];
                } else if (status != FBSessionStateClosed){
                    [self getUserInfo];
                }
            }
        }];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginToFacebookSuccessful)]) {
            [self.delegate loginToFacebookSuccessful];
        }
        [self getUserInfo];
    }
}

- (void)shareWithFacebook
{
//    UIImage *image = [TLPhotoManager sharedInstance].photoWithFilter;
//    NSString *postText;
//    if ([TLPhotoManager sharedInstance].hashtags.count) {
//        NSMutableString *text = [[NSMutableString alloc] init];
//        for (NSString *hashtag in [TLPhotoManager sharedInstance].hashtags) {
//            [text appendString:[NSString stringWithFormat:@"%@ ", hashtag]];
//        }
//        postText = text;
//    }
//    NSDictionary *params = @{@"message" : postText ? : @"", @"picture" : UIImageJPEGRepresentation(image, 0.8f)};
//    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(FBSharingPhotoFinishedWithResult:)]) {
//            [self.delegate FBSharingFinishedWithResult: error ? NO :YES];
//        }
//    }];
}

#pragma mark - Private

- (void)requestPublishPermissions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:FSFacebookPublishPermissions] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error){
            if (!error) {
                [self getUserInfo];
            }
        }];
    });
}

- (void)getUserInfo
{
//    [[FBRequest requestForMe] startWithCompletionHandler:
//     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
//         if (!error) {
//             [TLProfileManager sharedProfile].facebookNickname = user.name;
//             [TLProfileManager sharedProfile].facebookUserID = user.objectID;
//             [TLProfileManager sharedProfile].facebookEmail = user[@"email"];
//             NSString *profileImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square&height=200&width=200", user.objectID];
//             UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageURL]]];
//             [TLProfileManager sharedProfile].facebookProfilePicture = profileImage;
//             [self getUserFriends];
//         }
//     }];
}

- (void)getUserFriends
{
    self.friendsIDS = [[NSMutableArray alloc] init];
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error){
        if (!error) {
            NSArray *friends = [[NSArray alloc] initWithObjects:result[@"data"], nil];
            for (FBGraphObject<FBGraphUser> * user in friends[0]) {
                [self.friendsIDS addObject:user.objectID];
            }
            [self checkForNewFriends];
        }
    }];
}

- (void)checkForNewFriends
{
//    NSArray *oldFriends = [[NSUserDefaults standardUserDefaults] objectForKey:FSFriendsIDS];
//    if (self.friendsIDS.count != oldFriends.count) {
//        [[NSUserDefaults standardUserDefaults] setObject:self.friendsIDS forKey:FSFriendsIDS];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self sendFriendsIDS];
//    }
}

- (void)sendFriendsIDS
{
//    TLNetworkManager *networkManager = [TLNetworkManager sharedInstance];
//    if ([TLProfileManager sharedProfile].profileSocialNetworkType == TLSocialNetworkFacebook && networkManager.isActiveSession) {
//        [networkManager friends:self.friendsIDS socialName:@"facebook"];
//    }
}

@end
