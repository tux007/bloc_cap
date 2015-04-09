

#import <UIKit/UIKit.h>
#import "List.h"

@interface NewItemViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) List *list;
@property (strong, nonatomic) IBOutlet UILabel *ListField;
@property (strong, nonatomic) NSString *labelText;
@property (strong, nonatomic) NSArray *labelText2;
@property (strong, nonatomic) NSString *labelText3;
@property (strong, nonatomic) NSString *labelMulti;

@end
