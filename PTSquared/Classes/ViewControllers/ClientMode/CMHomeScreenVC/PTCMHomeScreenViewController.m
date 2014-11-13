//
//  PTCMHomeScreenViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTCMHomeScreenViewController.h"
#import "PTClientNavController.h"
#import <CoreData/CoreData.h>
#import "PTCoreDataManager.h"

@interface PTCMHomeScreenViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation PTCMHomeScreenViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialViewConfiguration];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [((PTClientNavController *)self.navigationController) setTitleImageToNavigationBar:[UIImage imageNamedFile:@"22"]];
}

#pragma mark - Private

- (void)initialViewConfiguration
{
    self.managedObjectContext = [[PTCoreDataManager sharedManager] managedObjectContext];
}

@end
