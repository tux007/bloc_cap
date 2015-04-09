

#import "ListViewController.h"
#import "ListDetailViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface ListViewController ()


@end

@implementation ListViewController



- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"List";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"listname";
        
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
    

    
    [self retrieveFriends];
    
 

    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0,0,3,44)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"navigation-logo"];
    self.navigationItem.titleView = imageView;

    [[UINavigationBar appearance] setBarTintColor: Rgb2UIColor(72, 84, 164)];
    
    
     self.parentViewController.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
   self.tableView.layer.cornerRadius = 40.0f;
 
    
    
      [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
 
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadObjects];
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (PFQuery *)queryForTable
{
    

PFQuery *currentUser = [PFQuery queryWithClassName:self.parseClassName];
   
[currentUser whereKey:@"item" equalTo:@" "];
   
[currentUser whereKey:@"friend" equalTo:[[PFUser currentUser]email]];
    
     PFQuery *userCurrent = [PFQuery queryWithClassName:self.parseClassName];
   [userCurrent whereKey:@"user" equalTo:[[PFUser currentUser]email]];
    [userCurrent whereKey:@"item" equalTo:@" "];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[currentUser,userCurrent]];
    
    
        
    
  
    

    
   // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
       if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }

        [query orderByAscending:@"listname"];
    
  
    
    return query;
    

}

- (void) retrieveFriends {
    PFQuery *getFriends = [PFQuery queryWithClassName:@"List"];
    [getFriends whereKeyExists:@"friend"];
    [getFriends whereKey:@"user" equalTo:[[PFUser currentUser]email]];
    
    [getFriends findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
      
        } else {
       
        }
        
    }];
  
    
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"ListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    

   
   
    
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"listname"];
    
    PFFile *imageFile = [object objectForKey:@"image"];
    PFImageView *imageView = [[PFImageView alloc] init];
    imageView.file = imageFile;
    [imageView loadInBackground:^(UIImage *img,NSError *error){
        
        if(!error)
        {
           
            cell.imageView.image = imageView.image;
            
        }
    }];
    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{*/
 


- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showListDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ListDetailViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        List *list2 = [[List alloc] init];
               list2.username = [object objectForKey:@"user"];
       list2.item = [object objectForKey:@"item"];
       list2.listname = [object objectForKey:@"listname"];
        list2.friends = [object objectForKey:@"friend"];
        list2.image = [object objectForKey:@"image"];
        list2.email = [object objectForKey:@"email"];
        list2.multi = [object objectForKey:@"multi"];
        list2.done = [object objectForKey:@"done1"];
        destViewController.list = list2;
        
   
      
    }
    
 
}


- (IBAction)unwindToNewList:(UIStoryboardSegue *)unwindSegue
{
}


- (IBAction)unwindToInvite:(UIStoryboardSegue *)unwindSegue
{
}

- (IBAction)unwindFromDelete:(UIStoryboardSegue *)unwindSegue
{
}

@end
