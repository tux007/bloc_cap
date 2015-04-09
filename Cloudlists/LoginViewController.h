//
//  LoginViewController.h
//  Cloudlists
//
//  Created by Ruth Reinert on 17.09.14.
//  Copyright (c) 2014 Ruth Reinert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    UITextField *passTextField;
    UITextField *userTextField;
}


@property (nonatomic, strong) IBOutlet UITextField *userTextField;
@property (nonatomic, strong) IBOutlet UITextField *passTextField;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


-(IBAction)logInPressed:(id)sender;
- (void) dismissKeyboard;
- (IBAction)DismissMail:(id)sender;
- (IBAction)DismissPasswort:(id)sender;

@end
