//
//  PTMenuViewController.h
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

@protocol PTMenuViewControllerDelegate

@required
- (void)selectMenuItem:(NSInteger)controllerIndex;

@end

@interface PTMenuViewController : UIViewController

@property (strong, nonatomic) id <PTMenuViewControllerDelegate>delegate;

@end
