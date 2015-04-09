

#import "InviteFaceViewController.h"
#import "EmailViewController.h"
#import "ShareViewController.h"
#import <Parse/Parse.h>
#import "List.h"

@interface InviteFaceViewController ()




@end

@implementation InviteFaceViewController

@synthesize list;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
      self.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
    
  //_stringEmail = [_labelEmail3 objectAtIndex:0];
  // NSLog(@"string %@", _stringEmail);

   // _stringId = [_labelEmail3 objectAtIndex:1];
   //NSLog(@"stringId %@", _stringId);
    

    
    _ListField.text = _labelEmail3;
    _ListListe.text = _labelUser;
    
    self.title = list.listname;
  
     NSLog(@" labelID%@", _labelId);
    NSLog(@" labelEmail 3 %@", _labelEmail3);
    NSLog (@" labelListe %@", _labelListe);
    NSLog (@" labelUser %@", _labelUser);
        NSLog (@" labelCurrent %@", _labelCurrent);
  [self queryForEmail];
   
    
}

-(IBAction)share:(id)sender{
    
    [self likeImage];
    [self uploadMessage];

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
            [userStats addUniqueObject:_stringFaceMail forKey:@"friend"];
            
            [userStats setObject:imageFile forKey:@"image"];
            
           // NSLog(@" User Stat %@", userStats.objectId);
            
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
                [person addUniqueObject:_stringFaceMail forKey:@"friend"];
                //[person setObject:@"1" forKey:@"friends"];
              //  NSLog(@"was ist person %@",person);
                
                [person saveInBackground];
           
                
                
                
                
            }
        }else{
            NSLog(@"Error: %@", error);
        
        }
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
    
    
    NSString *label = _stringFaceMail;
    NSArray *array = [[label componentsSeparatedByString:@",,,"]mutableCopy];
   // NSLog(@" Array %@", array);
    
    
    PFQuery *user = [PFUser query];
    
    [user whereKey:@"email" containedIn:array];
    
    
    [user getFirstObjectInBackgroundWithBlock:^(PFObject * friendsItem, NSError *error) {
        if (!error) {
            
            
            NSString *objectID = friendsItem.objectId;
          //  NSLog (@"object %@", friendsItem.objectId);
            
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

- (void) queryForEmail {
PFQuery *query = [PFUser query];


[query whereKey:@"fbId" equalTo:_labelId];

[query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
    if (!error) {
        // Found UserStats
   
    
      _stringFaceMail  = userStats[@"email"];
        
       // NSLog(@" User Stat Mail%@",_stringFaceMail);
      
        // Save

        
    } else {
        // Did not find any UserStats for the current user
        NSLog(@"Error: %@", error);
        
    }
}];
    
}


@end
