

#import <UIKit/UIKit.h>
#import "List.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface FriendsHistoryViewController : UIViewController



@property (nonatomic, strong) List *list;
@property (strong, nonatomic) NSString *labelList;
@property (strong, nonatomic) NSArray *labelFriend;
@property (strong, nonatomic) NSArray *labelDone;
@property (strong, nonatomic) NSString *labelMulti;
@property (strong, nonatomic) NSString *labelItem;
@property (nonatomic, strong)IBOutlet UILabel *test;
@property (nonatomic, strong)IBOutlet UILabel *user;
@property (nonatomic, strong)IBOutlet UILabel *created;

@property (strong, nonatomic) NSMutableArray *myFriends;


@end


