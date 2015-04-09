//
//  RegisterViewController.h
//  Cloudlists
//
//  Created by Ruth Reinert on 17.09.14.
//  Copyright (c) 2014 Ruth Reinert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface RegisterViewController : UIViewController {
    
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *password2;
    IBOutlet UITextField *email;
}

@property (nonatomic, strong) IBOutlet UITextField *userRegisterTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordRegisterTextField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;



- (IBAction)registerAction:(id)sender;
- (IBAction)DismissMail:(id)sender;
- (IBAction)DismissPasswort:(id)sender;
- (IBAction)DismissPasswort2:(id)sender;

@end
