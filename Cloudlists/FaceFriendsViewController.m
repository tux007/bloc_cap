

#import "FaceFriendsViewController.h"
#import "InviteFaceViewController.h"
#import "List.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface FaceFriendsViewController ()

@end

@implementation FaceFriendsViewController {
    NSArray *faceFriends;
    NSArray *faceId;
    NSArray *splitObjects;
}

@synthesize list;
@synthesize labelContact;
@synthesize labelUser2;

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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];
    
    
    self.parentViewController.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.layer.cornerRadius = 40.0f;

    
    self.title = @"Facebook Friends using Cloudlists";

    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
       // NSLog(@"Friends dictionary =%@", result);
        
        NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friends.count];
        // Create a list of friends' Facebook IDs
        for (NSDictionary *friendObject in friends) {
            [friendIds addObject:[friendObject objectForKey:@"name"]];
            
            NSMutableArray *friendIdss = [NSMutableArray arrayWithCapacity:friends.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friends) {
                [friendIdss addObject:[friendObject objectForKey:@"id"]];
            
          // NSLog(@" fdskdf%@", friendIds);
          //  NSLog (@" data %@", result);
          //  NSLog (@" friends count %lu", (unsigned long)friends.count);
          //  NSLog(@" friendobject %@", friendObject);
            faceFriends = friendIds;
                faceId = friendIdss;
            
            for (int i = 0; i < [faceFriends count]; i++) {
                
                NSString * tempItem = [faceFriends objectAtIndex:i]; //where i is each index, possibly in a loop
                splitObjects = [tempItem componentsSeparatedByString:@","];
                
                // NSLog(@"int size %lu", (unsigned long)[_labelFriend count]);
                
                
                NSLog(@" split object %@", splitObjects);
            }
            }
            
            NSLog(@"was ist facefriends %@", faceFriends);
        }
         //[self setArrayWithArray:friends];
    }];
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



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

/*-(PFQuery *)queryForTable
{
    
    PFQuery *query = [PFUser query];
    
    
   // [query whereKey:@"fbId" equalTo:faceFriends];
 
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    
   // [query orderByAscending:@"item"];
    
    
    // }];
    return query;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [faceFriends count];
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
    
    
    
  /*  if (faceFriends == nil) {
     UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, 320, 30)];
        // nameLabel = (UILabel*) [cell viewWithTag:101];
       // [nameLabel setText:@"You are not"];
        nameLabel.hidden = NO;
        [cell addSubview:nameLabel];
        
        NSLog(@" name label o ");
    }else {*/
          UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, 320, 30)];
   // nameLabel = (UILabel*) [cell viewWithTag:101];
        [nameLabel setText:[NSString stringWithFormat:@"%@", [faceFriends objectAtIndex:indexPath.row] ]];
        [cell addSubview:nameLabel];
    //}
     
    
    
    
    
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
    if ([segue.identifier isEqualToString:@"AddFaceFriend"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        InviteFaceViewController *destViewController = segue.destinationViewController;
        
   
    
        
        destViewController.labelUser = labelContact;
      //  destViewController.labelListe = [object objectForKey:@"username"];
        destViewController.labelCurrent = labelUser2;
        destViewController.labelEmail3 = [faceFriends objectAtIndex:indexPath.row];
         destViewController.labelId = [faceId objectAtIndex:indexPath.row];
        

        
        NSLog(@"list2.listname %@",[faceFriends objectAtIndex:indexPath.row]);
       // NSLog(@"object %@", _myFriends);
        NSLog(@" index %ld", (long)indexPath.row);
    }
    
    
}



@end
