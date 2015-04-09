

#import "InviteViewController.h"
#import "EmailViewController.h"
#import "ShareViewController.h"
#import <Parse/Parse.h>
#import "List.h"

@interface InviteViewController ()




@end

@implementation InviteViewController

@synthesize list;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    _ListField.text = _labelListe;
    _ListListe.text = _labelUser;
    
      self.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
 
    self.title = list.listname;
   // [self allObjects];

   // NSLog(@" labelEmail 3 %@", _labelEmail3);
   // NSLog (@" labelListe %@", _labelListe);
   // NSLog (@" labelUser %@", _labelUser);
}

-(IBAction)share:(id)sender{
   // [self allObjects];
   [self likeImage];
[self uploadMessage];
//    [self countFriends];
}

-(void) likeImage {
    
    

    
   image = [UIImage imageNamed:@"friendsicon"];
    

    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    
     NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"friendsicon.png" data:imageData];
    
    [query whereKey:@"listname" equalTo:_labelUser];
  [query whereKey:@"item" equalTo:@" "];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            // Found UserStats
             [userStats addUniqueObject:_labelListe forKey:@"friend"];
    
            [userStats setObject:imageFile forKey:@"image"];
          
          //  NSLog(@" User Stat %@", userStats.objectId);
            
            // Save
            [userStats saveInBackground];
            [self shareSuccess];
        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
            [self shareFail];
        }
    }];
    [self allObjects];
    
}

- (void) allObjects {
    

    
    PFQuery *personQuery = [PFQuery queryWithClassName:@"List"];
    
[personQuery whereKey:@"listname" equalTo:_labelUser];
    
    [personQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
          if (!error) {
              
        for (PFObject *person in objects){
            [person addUniqueObject:_labelListe forKey:@"friend"];
         // [person setObject:@"1" forKey:@"friends"];
            // NSLog(@"was ist person %@",person);
            
             [person saveInBackground];
                   // [self shareSuccess];
        }
          }else{
              NSLog(@"Error: %@", error);
              //[self shareFail];
          }
        //Log out the set. It should only contain unique countries
       
    }];
        
        
}





-(void) shareSuccess {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have added your friend" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void) shareFail {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooooops" message:@"There was an error adding your friend" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)uploadMessage
{
    
    
    NSString *label = _labelListe;
    NSArray *array = [[label componentsSeparatedByString:@",,,"]mutableCopy];
  //  NSLog(@" Array %@", array);
    
    
    PFQuery *user = [PFUser query];

    [user whereKey:@"username" containedIn:array];
    
    
    [user getFirstObjectInBackgroundWithBlock:^(PFObject * friendsItem, NSError *error) {
        if (!error) {

            
            NSString *objectID = friendsItem.objectId;
            
            
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"owner2" equalTo:objectID];
            
            // Send push notification to query
            
            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery];
            [push setMessage:[NSString stringWithFormat: @"%@ shared the list %@ with you!", [[PFUser currentUser]email], _labelUser]];
            [push sendPushInBackground];
          
           // NSLog(@" uploadMessage to owner %@", [[PFUser currentUser]objectId]);

            
       
            
        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
            
        }
    }];
    


    

    
  
}


@end

