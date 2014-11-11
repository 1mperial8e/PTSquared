//
//  PTValidationViewController.m
//  PTSquared
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTValidationViewController.h"
#import "PTProfileManager.h"
#import "PTCalendarAccessViewController.h"

@interface PTValidationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *validationCodeTextField;

@end

@implementation PTValidationViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPress:(id)sender
{
    
}

- (IBAction)submitButtonPress:(id)sender
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
    [[PTProfileManager sharedManager] setupWithProfile:CLIENT];
}

@end
