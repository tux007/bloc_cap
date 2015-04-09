

#import <UIKit/UIKit.h>
#import "List.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface ListDetailViewController :PFQueryTableViewController{
    NSMutableArray *dataArray;
}



@property (nonatomic, strong) List *list;


@end
