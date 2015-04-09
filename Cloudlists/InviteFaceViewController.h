

#import <UIKit/UIKit.h>
#import "List.h"
#import <Parse/Parse.h>

@interface InviteFaceViewController : UIViewController {
    
    UIImage *image;
}

@property (nonatomic, strong) List *list;
@property (strong, nonatomic) IBOutlet UILabel *ListField;
@property (strong, nonatomic) IBOutlet UILabel *ListListe;
@property (strong, nonatomic) NSString *labelUser;
@property (strong, nonatomic) NSString *labelListe;
@property (strong, nonatomic) NSString *labelCurrent;
@property (strong, nonatomic) NSString *labelEmail3;
@property (strong, nonatomic) NSString *labelId;
@property (strong, nonatomic) NSString *stringEmail;
@property (strong, nonatomic) NSString *stringId;
@property (strong, nonatomic) NSString *stringFaceMail;

@property (strong, nonatomic) UIImageView *imageView;
-(IBAction)share:(id)sender;
@end
