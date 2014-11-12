//
//  TLFacebookSharing.h
//  Trill
//
//  Created by Stas Volskyi on 16.07.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

@protocol PTFacebookDelegate <NSObject>

@optional

- (void)failedLoginToFacebook:(NSError*)error;
- (void)loginToFacebookSuccessful;
- (void)FBSharingPhotoFinishedWithResult:(BOOL)success;

@end

@interface PTFacebookManager : NSObject

@property (weak, nonatomic) id<PTFacebookDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)loginWithFacebook;
- (void)shareWithFacebook;

@end
