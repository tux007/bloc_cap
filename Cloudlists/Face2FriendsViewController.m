

#import "Face2FriendsViewController.h"
#import "InviteFaceViewController.h"
#import "List.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface Face2FriendsViewController ()




@end

@implementation Face2FriendsViewController{
    NSArray *faceFriend;
    NSArray *fbFriend;
    NSArray *splitObject;
    NSString *tempItem;
}

@synthesize list;
@synthesize labelContact;
@synthesize labelUser2;
@synthesize labelEmail2;

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"List";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"username";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];
    
    
    self.parentViewController.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.layer.cornerRadius = 40.0f;

    
    self.title = @"Facebookfriends using Cloudlists";
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            
            
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    for (PFObject *object in objects) {
                        
                        fbFriend = object[@"fbId"];
                        
                        NSLog(@"face friend query %@", fbFriend);
                        
                        
                    }
                    
                }
                
            }];
        }
    }];
    
    

  //  [self facefriend];
    [self loadObjects];

    
    
}

- (void) facefriend {
    
       PFQuery *friendQuery = [PFUser query];
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            
            
         
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    for (PFObject *object in objects) {
                        
                        fbFriend = object[@"fbId"];
                        
                         NSLog(@"face friend query %@", fbFriend);
                        
                 
                    }
                    
                    
                }
                

            }];
            
            
        }
    }];

    
}

/*- (void) getfbId {
 PFQuery *query = [PFUser query];
  
    
   // [query whereKeyExists:@"fbId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
             for (PFObject *object in objects) {
            
           fbFriend = object[@"fbId"];
                 
                // NSString * result = [fbFriend objectAtIndex:0];
                 
                NSLog(@"irgendwas mit fb %@", fbFriend);
      
             }
             }
    }];
    
}*/




- (void)refreshTable:(NSNotification *) notification
{
    
    [self loadObjects];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




- (PFQuery *)queryForTable
{
    

    PFQuery *query = [PFUser query];
    

 [query whereKeyExists:@"fbId"];
    NSLog(@"wasist fbfirendf %@", fbFriend);
    
  [query whereKey:@"username" notEqualTo:[[PFUser currentUser]username]];
  
   
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    //[query orderByAscending:@"username"];
    

    
    return query;
    
}





// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"FaceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"firstname"];
    

    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}*/

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddFriend"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        InviteFaceViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        List *list2 = [[List alloc] init];
         list2.listname = [object objectForKey:@"username"];
           
        
         destViewController.labelUser = labelContact;
        destViewController.labelListe = list2.listname;
        destViewController.labelCurrent = labelUser2;
        destViewController.labelEmail3 = labelEmail2;
        ;
    }
    
    
}



@end