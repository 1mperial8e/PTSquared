//
//  PTTutorialCell.m
//  PTSquared
//
//  Created by Kirill on 11/10/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTTutorialCell.h"

@implementation PTTutorialCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.tutorialImageView.image = nil;
    self.skipButton.hidden = YES;
    self.endTutorialButton.hidden = YES;
}

#pragma mark - IBActions

- (IBAction)closeTutorialButton:(id)sender
{
    
}

@end
