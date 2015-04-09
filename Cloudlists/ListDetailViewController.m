

#import "ListDetailViewController.h"
#import "NewItemViewController.h"
#import "ShareViewController.h"
#import "FriendsHistoryViewController.h"
#import "List.h"

@interface ListDetailViewController ()

@property (strong, nonatomic) NSIndexPath *indexPathToBeDeleted;


@end

@implementation ListDetailViewController


@synthesize list;

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"List";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"item";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
    
}

-  (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    [self loadObjects];
    
  
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
    
  // NSLog(@" Was ist friends list.email %@", list.multi);
  
    
 
   PFQuery *query = [PFQuery queryWithClassName:@"List"];
    
    NSString *listname2 = [NSString stringWithFormat:@"%@",[self.list valueForKey:@"listname"]];
   
    
    [query whereKey:@"listname" equalTo:listname2];
    [query whereKey:@"item" equalTo:@" "];


    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            
         
            
           NSNumber *totalCount = [NSNumber numberWithInt:0];
            for (PFObject *obj in objects) {
                totalCount = [NSNumber numberWithInteger:[totalCount intValue] + [(NSArray *)[obj objectForKey:@"friend"] count]];
                
            
                
                NSString *totalCountInString = [totalCount stringValue];
        
                
               UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = list.listname;
    [titleLabel sizeToFit];
    
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 0, 0)];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = [UIColor whiteColor];
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    
    if (list.image == 0){
        subTitleLabel.text = @"private";
    
    }
    else {
       subTitleLabel.text = [NSString stringWithFormat:@"this list is shared with %@ friends", totalCountInString];
    }
    [subTitleLabel sizeToFit];
    
    UIView *twoLineTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(subTitleLabel.frame.size.width, titleLabel.frame.size.width), 30)];
    [twoLineTitleView addSubview:titleLabel];
    [twoLineTitleView addSubview:subTitleLabel];
    
    float widthDiff = subTitleLabel.frame.size.width - titleLabel.frame.size.width;
    
    if (widthDiff > 0) {
        CGRect frame = titleLabel.frame;
        frame.origin.x = widthDiff / 2;
        titleLabel.frame = CGRectIntegral(frame);
    }else{
        CGRect frame = subTitleLabel.frame;
        frame.origin.x = abs(widthDiff) / 2;
        subTitleLabel.frame = CGRectIntegral(frame);
    }

    
    self.navigationItem.titleView = twoLineTitleView;

                 if (list.image == 0){
                UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAction:)];
                     
                     
      
                
                NSArray *actionButtonItems = @[shareItem];
                     self.navigationItem.rightBarButtonItems = actionButtonItems;}
                 else{
                     
                        UIImage *image = [[UIImage imageNamed:@"info"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                     
                     UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAction:)];
                     
                     UIButton * information = [UIButton buttonWithType:UIButtonTypeCustom];
                     information.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
                     [information setImage:image forState:UIControlStateNormal];
                     [information addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                     
                     UIBarButtonItem *cameraTest = [[UIBarButtonItem alloc] initWithCustomView:information];
                   
                     
                  //   UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithImage: image style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction2:)];

                     
                     NSArray *actionButtonItems = @[shareItem, cameraTest];
                     self.navigationItem.rightBarButtonItems = actionButtonItems;
                 }

            }
        
           
        }
         }];
    

    
       
 
    
}

- (void)refreshTable:(NSNotification *) notification
{
 
    [self loadObjects];
}


- (void)viewDidUnload
{


    [super viewDidUnload];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    
    NSString *listname2 = [NSString stringWithFormat:@"%@",[self.list valueForKey:@"listname"]];
  
    
    if (list.friends == nil) {
       [query whereKey:@"user" equalTo:[[PFUser currentUser]email]];
    }else {
        
   [query whereKey:@"friend" equalTo:[[PFUser currentUser]email]];

 }

    [query whereKey:@"listname" equalTo:listname2];
    [query whereKey:@"item" notEqualTo:@" "];

    
  
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
       if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
    

   [query orderByAscending:@"item"];
    

   // }];
    return query;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"ItemCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
   
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [object objectForKey:@"item"];

    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    
    NSString *listname2 = [NSString stringWithFormat:@"%@",[self.list valueForKey:@"listname"]];

    
    
    
    [query whereKey:@"listname" equalTo:listname2];
   [query whereKey:@"item" equalTo:@" "];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
         PFObject *object = [self.objects objectAtIndex:indexPath.row];
                
           
              NSArray*done1 = [object objectForKey:@"done1"];
            NSString *multi = [object objectForKey:@"multi"];
            
 
            
            
            NSNumber *totalCount = [NSNumber numberWithInt:0];
          //  for (PFObject *obj in objects) {
                totalCount = [NSNumber numberWithInteger:[totalCount intValue] + [(NSArray *)[object objectForKey:@"done1"] count]];
            
                
                NSString *totalCountInString = [totalCount stringValue];
        
            
     
                
            if ((done1 == nil || [done1 isEqual:@"0"]) && ([multi isEqual:@"1"])) {
                
          
                     UIImage *btnImage = [UIImage imageNamed:@"markunchecked.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setImage:btnImage forState:UIControlStateNormal];
    button.frame = CGRectMake(cell.bounds.origin.x + 250, cell.bounds.origin.y + 10, 20, 20);
    [button addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
                
    
                UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(206, 13, 12, 12)];
                [label5 setTextColor:[UIColor blackColor]];
                [label5 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
                label5.text = totalCountInString;
                [cell.contentView addSubview:label5];
                
                
                UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button5 setImage:btnImage forState:UIControlStateNormal];
                button5.frame = CGRectMake(cell.bounds.origin.x + 200, cell.bounds.origin.y + 10, 20, 20);
            [button5 addTarget:self action:@selector(customMultiPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button5];
                
                }else  if ((done1 == nil) && (multi == nil || [multi isEqual:@"0"])) {
                    
                    
                    UIImage *btnImage2 = [UIImage imageNamed:@"markunchecked.png"];
                    
                    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [button2 setImage:btnImage2 forState:UIControlStateNormal];
                    button2.frame = CGRectMake(cell.bounds.origin.x + 250, cell.bounds.origin.y + 10, 20, 20);
                    [button2 addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button2];
                    
                }
            
             else if (([done1 containsObject:[[PFUser currentUser]email]]) && (multi == nil || [multi isEqual:@"0"])) {
                    
                 UIImage *btnImage2 = [UIImage imageNamed:@"markchecked.png"];
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button2 setImage:btnImage2 forState:UIControlStateNormal];
            button2.frame = CGRectMake(cell.bounds.origin.x + 250, cell.bounds.origin.y + 10, 20, 20);
            [button2 addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchUpInside];
                 [cell.contentView addSubview:button2];
             }
               else if ((![done1 containsObject:[[PFUser currentUser]email]]) && (multi == nil || [multi isEqual:@"0"])) {
                 
                 UIImage *btnImage2 = [UIImage imageNamed:@"markunchecked.png"];
                 
                 UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                 [button2 setImage:btnImage2 forState:UIControlStateNormal];
                 button2.frame = CGRectMake(cell.bounds.origin.x + 250, cell.bounds.origin.y + 10, 20, 20);
                 [button2 addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchUpInside];
                 [cell.contentView addSubview:button2];
             }
            else if (([done1 containsObject:[[PFUser currentUser]email]]) && ([multi isEqual:@"1"])) {
             
                UIImage *btnImage = [UIImage imageNamed:@"markchecked.png"];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button setImage:btnImage forState:UIControlStateNormal];
                button.frame = CGRectMake(cell.bounds.origin.x + 250, cell.bounds.origin.y + 10, 20, 20);
                [button addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                
                UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(206, 13, 12, 12)];
                [label5 setTextColor:[UIColor blackColor]];
                [label5 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
                label5.text = totalCountInString;
                [cell.contentView addSubview:label5];
                
                UIImage *btnImage2 = [UIImage imageNamed:@"markunchecked.png"];
                
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button2 setImage:btnImage2 forState:UIControlStateNormal];
                button2.frame = CGRectMake(cell.bounds.origin.x + 200, cell.bounds.origin.y + 10, 20, 20);
                [cell.contentView addSubview:button2];
            }
            else if ((![done1 containsObject:[[PFUser currentUser]email]]) && ([multi isEqual:@"1"])) {
                
            
                UIImage *btnImage = [UIImage imageNamed:@"markunchecked.png"];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button setImage:btnImage forState:UIControlStateNormal];
                button.frame = CGRectMake(cell.bounds.origin.x + 250, cell.bounds.origin.y + 10, 20, 20);
                [button addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                
                UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(206, 13, 12, 12)];
                [label5 setTextColor:[UIColor blackColor]];
                [label5 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
                label5.text = totalCountInString;
                [cell.contentView addSubview:label5];
                
                UIImage *btnImage2 = [UIImage imageNamed:@"markunchecked.png"];
                
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button2 setImage:btnImage2 forState:UIControlStateNormal];
                button2.frame = CGRectMake(cell.bounds.origin.x + 200, cell.bounds.origin.y + 10, 20, 20);
                [cell.contentView addSubview:button2];
            }

   
            }
  
    }];
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) refreshTableData{
    [self.tableView reloadData];

}

- (void) customMultiPressed :(id) sender {
    
    CGPoint button2Position = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath2 = [self.tableView indexPathForRowAtPoint:button2Position];
    if (indexPath2 !=nil){
    
    }
}

-(void)customActionPressed :(id)sender
{
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath !=nil)
    {
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"List"];
    
    NSString *listname2 = [NSString stringWithFormat:@"%@",[self.list valueForKey:@"listname"]];
  
    

    
    [query whereKey:@"listname" equalTo:listname2];
    [query whereKey:@"item" notEqualTo:@" "];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *object = [self.objects objectAtIndex:indexPath.row];
       
            NSArray *done1 = [object objectForKey:@"done1"];
           
   
            
            if ([done1 containsObject:[[PFUser currentUser]email]]) {
                
             
              
                [object removeObject:[[PFUser currentUser]email] forKey:@"done1"];
                
                [object saveInBackground];
                
                
                
            
            }else if ((![done1 containsObject:[[PFUser currentUser]email]]) || done1 == nil){
                
                     [object addUniqueObject:[[PFUser currentUser]email] forKey:@"done1"];
            
                
                
            [object saveInBackground];
                
                

            }
       
       
      
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
        
               }];

        
        
    }


    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Custom Button Pressed"
                                                        message:[NSString stringWithFormat: @"You pressed the custom button on cell"]
                                                       delegate:self cancelButtonTitle:@"Great"
                                              otherButtonTitles:nil];
    [alertView show];
    
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}



- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}
-(void)buttonAction:(id)sender
{
    [self performSegueWithIdentifier:@"NewItemDetail" sender:sender];
}

-(void)buttonAction2:(id)sender
{
    [self performSegueWithIdentifier:@"FriendsHistoryDetail" sender:sender];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewItemDetail"]) {
    NewItemViewController *niv = [segue destinationViewController];
    niv.labelText = list.listname;
        niv.labelText2 = list.friends;
        niv.labelText3 = list.username;
        niv.labelMulti = list.multi;
        

    
}
    else if ([segue.identifier isEqualToString:@"ShareDetail"]) {
        
        ShareViewController *niv2 = [segue destinationViewController];
        niv2.labelText2 = list.listname;
        niv2.labelText3 = list.username;
        niv2.labelEmail = [[PFUser currentUser]email];
       
    }
    else if ([segue.identifier isEqualToString:@"FriendsHistoryDetail"]){
        
        FriendsHistoryViewController *niv3 = [segue destinationViewController];
       // niv3.labelText2 = list.friends;
        
        niv3.labelList = list.listname;
        niv3.labelFriend = list.friends;
        niv3.labelMulti = list.multi;
        niv3.labelDone = list.done;
        niv3.labelItem = list.item;

        
    
    }
    
}

- (IBAction)unwindToNewItem:(UIStoryboardSegue *)unwindSegue
{
}



@end
