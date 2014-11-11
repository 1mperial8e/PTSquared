//
//  PTTrainerLoginViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTTrainerLoginViewController.h"
#import "PTProfileManager.h"
#import "PTCalendarAccessViewController.h"

@interface PTTrainerLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation PTTrainerLoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction)restorePassButtonPress:(id)sender
{
    
}

- (IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signInButtonPress:(id)sender
{
    [self configureProfileManager];
    PTCalendarAccessViewController *viewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"allowCalendar"];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private

- (void)configureProfileManager
{
    [[PTProfileManager sharedManager] setupWithProfile:PERSONAL_TRAINER];
}

@end
