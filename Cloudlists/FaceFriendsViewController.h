

#import <UIKit/UIKit.h>
#import "List.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface FaceFriendsViewController : PFQueryTableViewController

@property (nonatomic, strong) List *list;
@property (strong, nonatomic) NSString *labelContact;
@property (strong, nonatomic) NSString *labelUser2;
@property (strong, nonatomic) NSString *labelFaceEmail;
@property (strong, nonatomic) NSMutableArray *myFriends;
@property (strong, nonatomic) NSArray *friends;


@end
