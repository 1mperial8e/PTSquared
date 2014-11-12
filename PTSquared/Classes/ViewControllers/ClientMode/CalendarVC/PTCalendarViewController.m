//
//  PTCalendarViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTCalendarViewController.h"
#import "PTClientNavController.h"

@interface PTCalendarViewController ()

@end

@implementation PTCalendarViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((PTClientNavController *)self.navigationController) setTitleLabelToNavigationBar:@"Hello"];
}

@end
