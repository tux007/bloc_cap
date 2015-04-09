

#import <UIKit/UIKit.h>
#import "List.h"

@interface ShareViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>{
    
       IBOutlet UIButton *weiterEmail;
}

- (IBAction)deleteButton:(id)sender;

@property (nonatomic, strong) List *list;
@property (strong, nonatomic) IBOutlet UILabel *ListField;
@property (strong, nonatomic) NSString *labelText2;
@property (strong, nonatomic) NSString *labelText3;
@property (strong, nonatomic) NSString *labelEmail;

@end
