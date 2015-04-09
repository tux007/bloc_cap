

#import "MultiViewController.h"
#import <Parse/Parse.h>
#import "List.h"

@interface MultiViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentClick:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *listLabel;

@end


@implementation MultiViewController

@synthesize list;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textLabel.text = @" ";
    self.listLabel.text = _labelList;
    
    
    
           self.parentViewController.view.backgroundColor = [UIColor colorWithRed:(72/255.0) green:(84/255.0) blue:(164/255.0) alpha:1];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"On", @"Off", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(100, 130, 120, 30);
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents: UIControlEventValueChanged];
    

    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    [query whereKey:@"listname" equalTo:_labelList];
    [query whereKey:@"item" notEqualTo:@" "];
    [query whereKey:@"user" equalTo:_labelUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *person in objects){
                NSString *multi = [person objectForKey:@"multi"];
                
                if ([multi  isEqual: @"1"]) {
                    segmentedControl.selectedSegmentIndex = 0;
                         self.textLabel.text = @"Multi completion on";
                } else if ([multi isEqual:@"0"] || (multi == nil)){
                    segmentedControl.selectedSegmentIndex = 1;
                         self.textLabel.text = @"Multi completion off";
                }
             //   NSLog(@"was ist multi %@",multi);
            }
        }else{
            NSLog(@"Error: %@", error);
        }
        
    }];
    
  
    [self.view addSubview:segmentedControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)segmentClick:(UISegmentedControl *)segment {
 
    switch (segment.selectedSegmentIndex)
    {
       
        {case 0:
            
    
            
           self.textLabel.text = @"Multi completion on";
            
            
            PFQuery *query = [PFQuery queryWithClassName:@"List"];
            
            
            
            [query whereKey:@"listname" equalTo:_labelList];
           // [query whereKey:@"item" notEqualTo:@" "];
            [query whereKey:@"user" equalTo:_labelUser];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    for (PFObject *person in objects){
                        //[person addUniqueObject:_labelEmail forKey:@"friend"];
                  
                        
                        
                        [person setObject:@"1" forKey:@"multi"];
                  
                        
                        [person saveInBackground];
                     
                    }
                }else{
                    NSLog(@"Error: %@", error);
              
                }
     
                
            }];
            
            break;
        }case 1:{
 

            self.textLabel.text = @"Multi comletion off";
            
            PFQuery *query = [PFQuery queryWithClassName:@"List"];
            
            
            
            [query whereKey:@"listname" equalTo:_labelList];
           // [query whereKey:@"item" notEqualTo:@" "];
                       [query whereKey:@"user" equalTo:_labelUser];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *person in objects){
                        //[person addUniqueObject:_labelEmail forKey:@"friend"];
                        [person setObject:@"0" forKey:@"multi"];
                 
                        
                        [person saveInBackground];
                    
                    }
                }else{
                    NSLog(@"Error: %@", error);
              
                }
            
                
            }];

            break;
        }default:
            break; 
   
    }
    
}
    
@end
