

#import <UIKit/UIKit.h>
#import "List.h"
#import <Parse/Parse.h>

@interface MultiViewController : UIViewController

@property (strong, nonatomic) NSString *labelList;
@property (strong, nonatomic) NSString *labelUser;
@property (strong, nonatomic) NSString *labelEmail;
@property (nonatomic, strong) List *list;

@end
