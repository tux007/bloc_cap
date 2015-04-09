

#import "NewItemViewController.h"
#import "ListDetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import "List.h"


@interface NewItemViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UILabel *listTextView;

@end

@implementation NewItemViewController
@synthesize list;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  

    _itemTextField.delegate = self;
     self.title = list.listname;
    _ListField.text = _labelText;

    
    
    
   
        self.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate



- (IBAction)save:(id)sender {
    
    PFObject *listen = [PFObject objectWithClassName:@"List"];

    [listen setObject:_itemTextField.text forKey:@"item"];
   [listen setObject:_ListField.text forKey:@"listname"];
    [listen setObject:_labelText3 forKey:@"user"];
   //   [listen setObject: @" " forKey:@"friends"];
   
    
    if (_labelText2 == nil) {
        
       // NSLog(@"ist null");
         }
        else {
            
          [listen setObject:_labelText2 forKey:@"friend"];

         //   NSLog(@"saving friend");
            
            
            if (_labelMulti == nil) {
                
           //     NSLog(@"ist null");
            }
            else {
                
                [listen setObject:_labelMulti  forKey:@"multi"];
                
              //  NSLog(@"saving friend");
            }
    }

 
    

    [listen saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
      
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            [listen saveEventually];
     
        
            
            [self performSegueWithIdentifier:@"ItemView" sender:self];
            
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


    [self setItemTextField:nil];
    
    [super viewDidUnload];
}




#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end

