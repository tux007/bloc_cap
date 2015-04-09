


#import "ShareViewController.h"
#import "ListViewController.h"
#import "EmailViewController.h"
#import "Face2FriendsViewController.h"
#import "MultiViewController.h"
#import <Parse/Parse.h>
#import "List.h"

@interface ShareViewController ()

@property (weak, nonatomic) IBOutlet UILabel *listTextView;


@end

@implementation ShareViewController

@synthesize list;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title = list.listname;
    _ListField.text = _labelText2;
    

    
           self.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ListEmail"]) {
        EmailViewController *niv = [segue destinationViewController];
        niv.labelContact = _labelText2;
        niv.labelUser2 = _labelText3;
        niv.labelEmail2 = _labelEmail;
        
     
    }
    else if ([segue.identifier isEqualToString:@"ListFace"]){
        Face2FriendsViewController *niv2 = [segue destinationViewController];
        niv2.labelContact = _labelText2;
        niv2.labelUser2 = _labelText3;
     //   niv2.labelFaceEmail = _labelEmail;
        
    }
    else if ([segue.identifier isEqualToString:@"MultiList"]){
        MultiViewController *niv3 = [segue destinationViewController];
        niv3.labelList = _labelText2;
        niv3.labelUser = _labelText3;
        niv3.labelEmail = _labelEmail;
        
    }

    }




- (IBAction)deleteButton:(id)sender {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                    message:@"Are you sure you want to delete?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
    

    

    
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        if ([_labelText3 isEqualToString:[[PFUser currentUser]email]]) {
            
            PFQuery *deleteList = [PFQuery queryWithClassName:@"List"];
            
            
            [deleteList whereKey:@"listname" equalTo:_labelText2];
            
            
            [deleteList whereKey:@"user" equalTo:[[PFUser currentUser]email]];
            
            
            [deleteList findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                
                    
                    
                    
                    
                    
                    for (PFObject *object in objects) {
                        [object deleteInBackground];
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                } else {
                    // Log details of the failure
                    NSLog(@"Error Deleting: %@ %@", error, [error userInfo]);
                }
            }];
            
        }
        else {
            
          
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                            message:@"You can't delete this list"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
             [self.navigationController popToRootViewControllerAnimated:YES];
        }
      
    } else if (buttonIndex == 0) {
      
    }
}
@end
