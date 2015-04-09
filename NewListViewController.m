



#import "NewListViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>


@interface NewListViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *listTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;


@end

@implementation NewListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _listTextField.delegate = self;

        self.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate


- (IBAction)save:(id)sender {

    PFObject *list = [PFObject objectWithClassName:@"List"];
    [list setObject:_listTextField.text forKey:@"listname"];
    [list setObject: @" " forKey:@"item"];
    // [list setObject: @" " forKey:@"friends"];

    
    [list setObject:[PFUser currentUser].email forKey:@"user"];
   
     
   
    [list addUniqueObject:[PFUser currentUser].email forKey:@"friend"];
  
    

    [list saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the list" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            [list saveEventually];
            // Dismiss the controller
         
             [self performSegueWithIdentifier:@"ListView" sender:self];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {

    [self setListTextField:nil];


    [super viewDidUnload];
}



#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
