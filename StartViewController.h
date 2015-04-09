

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface StartViewController : UIViewController {
    
    
    IBOutlet UIButton *weiter;
     IBOutlet UIButton *login;
     IBOutlet UIButton *logout;
         IBOutlet UIButton *signFace;
    IBOutlet UIButton *signEmail;
         IBOutlet UIButton *forgot;
    
}

-(IBAction)logOut:(id)sender;
-(IBAction)weiterList:(id)sender;
- (IBAction)loginButtonTouchHandler:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *AlreadyLog;
@property (strong, nonatomic) IBOutlet UILabel *NotLog;
@property (strong, nonatomic) IBOutlet UILabel *Or;
@property (strong, nonatomic) IBOutlet UILabel *User;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblFullname;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePicture;




@end

