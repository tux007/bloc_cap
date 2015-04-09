//
//  RegisterViewController.m
//  Cloudlists
//
//  Created by Ruth Reinert on 17.09.14.
//  Copyright (c) 2014 Ruth Reinert. All rights reserved.
//

#import "RegisterViewController.h"

#import <Parse/Parse.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize userRegisterTextField = _userRegisterTextField, passwordRegisterTextField = _passwordRegisterTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userRegisterTextField = nil;
    self.passwordRegisterTextField = nil;
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
    
    
    if (!CGRectContainsPoint(rect, self.userRegisterTextField.frame.origin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.userRegisterTextField.frame.origin.y - (keyboardSize.height - self.userRegisterTextField.frame.size.height));
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

- (IBAction)registerAction:(id)sender {
    [_userRegisterTextField resignFirstResponder];
    [_passwordRegisterTextField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
    [self checkFieldsComplete];
}

- (void) checkFieldsComplete {
    if ([_userRegisterTextField.text isEqualToString:@""]  || [_passwordRegisterTextField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Alle Felder müssen ausgefüllt werden" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch {
    if (![_passwordRegisterTextField.text isEqualToString:_reEnterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Passwort stimmt nicht überein" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self registerNewUser];
    }
}


- (void) registerNewUser {
   // NSLog(@"registering....");
    PFUser *newUser = [PFUser user];
    newUser.username = _userRegisterTextField.text;
    newUser.password = _passwordRegisterTextField.text;
    newUser.email = _userRegisterTextField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
           // NSLog(@"Registration success!");
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        else {
            
            //NSLog(@"There was an error in registration");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Fehler beim Registrieren, Name oder Email wurde schon gebraucht" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)DismissMail:(id)sender {
    
    [username resignFirstResponder];
}


- (IBAction)DismissPasswort:(id)sender{
    
    [password resignFirstResponder];
}
- (IBAction)DismissPasswort2:(id)sender{
    
    [password2 resignFirstResponder];
}


@end
