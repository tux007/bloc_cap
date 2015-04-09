

#import "ForgotViewController.h"
#import <Parse/Parse.h>

@implementation ForgotViewController





- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
  
}



-(IBAction)forgotPW:(id)sender{
 
    [PFUser requestPasswordResetForEmailInBackground:self.Email.text block:^(BOOL succeeded,NSError *error)
    {
        
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat: @"Link to reset the password has been send to specified email"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat: @"Password reset failed: %@",errorString] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }];
//[PFUser requestPasswordResetForEmailInBackground:_Email.text];
 //  NSLog(@" Was ist Email.text %@", self.Email.text);
}



@end
