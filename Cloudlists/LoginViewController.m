//
//  LoginViewController.m
//  Cloudlists
//
//  Created by Ruth Reinert on 17.09.14.
//  Copyright (c) 2014 Ruth Reinert. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import <Parse/Parse.h>

@implementation LoginViewController

@synthesize userTextField = _userTextField;
@synthesize  passTextField = _passTextField;



- (void) dismissKeyboard {
    
    [userTextField resignFirstResponder];
    [passTextField resignFirstResponder];
}



/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self dismissKeyboard];
    [super viewDidLoad];
    
  

}




- (void)viewDidUnload
{
    [super viewDidUnload];

    self.userTextField = nil;
    self.passTextField = nil;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-10,320,400);
    [UIView commitAnimations];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated { [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:YES];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = self.view.frame; rect.size.height -= keyboardSize.height;
    
    
    if (!CGRectContainsPoint(rect, self.userTextField.frame.origin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.userTextField.frame.origin.y - (keyboardSize.height - self.userTextField.frame.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark IB Actions

-(IBAction)logInPressed:(id)sender
{
    
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //Open the wall
             [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
            
           
           
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
           [self dismissViewControllerAnimated:NO completion:nil];
           
            return ;
        }
    }];
}

- (IBAction)DismissMail:(id)sender {
    
    [userTextField resignFirstResponder];
}


- (IBAction)DismissPasswort:(id)sender{
    
    [passTextField resignFirstResponder];
}

@end
