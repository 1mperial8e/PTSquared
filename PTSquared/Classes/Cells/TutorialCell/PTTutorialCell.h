//
//  PTTutorialCell.h
//  PTSquared
//
//  Created by Kirill on 11/10/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

@protocol PTTutorialCell <NSObject>

@required

- (void)endTutorialConfirmed;

@end

@interface PTTutorialCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tutorialImageView;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *endTutorialButton;

@property (strong, nonatomic) id <PTTutorialCell>delegate;

@end
