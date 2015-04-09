

#import "FriendsHistoryViewController.h"
#import <Parse/Parse.h>

@implementation FriendsHistoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
self.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
    
                          
    
   self.title = _labelList;
    
    
    
    
    NSMutableString *ingredientText = [NSMutableString string];
    for (NSString *ingredient in _labelFriend)
    {
        [ingredientText appendFormat:@"%@\n", ingredient];
    }

    self.test.text = ingredientText;
    
    
 

    //NSLog(@" labellist %@", _labelList);
    //NSLog(@" labelfriend %@", _labelFriend);
    
    
   
    for (int i = 0; i < [_labelFriend count]; i++) {

    NSString * tempItem = [_labelFriend objectAtIndex:i]; //where i is each index, possibly in a loop
NSArray * splitObject = [tempItem componentsSeparatedByString:@","];

       // NSLog(@"int size %lu", (unsigned long)[_labelFriend count]);
        
        
    NSLog(@" split object %@", splitObject);
    }
    
    
  //  NSLog(@" labelMulti %@",_labelMulti);
    //NSLog(@" labelDone %@", _labelDone);
      //  NSLog(@" labelItem %@", _labelItem);
    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    [query whereKey:@"listname" equalTo:_labelList];
    [query whereKey:@"item" notEqualTo:@" "];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *person in objects){
                NSString *user = [person objectForKey:@"user"];
                NSDate * createdAt = person.createdAt;
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
                [dateFormat setDateFormat:@"MMMM d yyyy"];
                NSString *theDate = [dateFormat stringFromDate:createdAt];
                
                self.user.text = user;
                self.created.text = theDate;
             
              //  NSLog(@"was ist user %@",user);
              //  NSLog(@"was ist created at %@", createdAt);
            }
        }else{
            NSLog(@"Error: %@", error);
        }
        
    }];


    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}








@end

