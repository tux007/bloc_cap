

#import "StartViewController.h"
#import "ListViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>



@implementation StartViewController



#pragma mark - push notificaiton
-(void)registerToReceivePushNotification {
    // Register for push notifications
    UIApplication* application =[UIApplication sharedApplication];
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}


- (void)viewDidLoad {
    

    

    
    [super viewDidLoad];
    

    self.activityIndicator.hidden = YES;


   
    
}


- (void)viewDidAppear:(BOOL)animated {

 
    
  


    PFUser *user = [PFUser currentUser];
    if (user.username != nil)
    {
        weiter.hidden = NO;
        _AlreadyLog.hidden = NO;
        _NotLog.hidden = YES;
        login.hidden = YES;
        logout.hidden = NO;
        signEmail.hidden  = YES;
        signFace.hidden = YES;
        _Or.hidden = YES;
        _User.hidden = NO;
        _User.text = user.email;
        forgot.hidden = YES;
      
         [self _loadData];
 
        if ([[PFUser currentUser]username] == [[PFUser currentUser]email]) {
            _lblFullname.hidden = YES;
          
            
        } else {
               _lblFullname.hidden = NO;
     
            
        }

          //  NSLog(@"currentUserView: %@", [PFUser currentUser]);
  PFACL *acl = [PFACL ACL];
        [acl setPublicReadAccess:true];
        [acl setWriteAccess:true forUser:[PFUser currentUser]];
        
        [self registerToReceivePushNotification];
    }
    else {
        


    }
        

    
   // NSLog (@"user %@", user);
    
    [super viewDidAppear:YES];
}



-(IBAction)logOut:(id)sender {
    

    weiter.hidden = YES;
    _AlreadyLog.hidden = YES;
    _NotLog.hidden = NO;
    signEmail.hidden  = NO;
    signFace.hidden = NO;
    _Or.hidden = NO;
    _User.hidden = YES;
    login.hidden = NO;
    logout.hidden = YES;
    forgot.hidden = NO;
    _lblFullname.hidden = YES;
    _imgProfilePicture.hidden = YES;

    if ([PFUser currentUser]) {
        [PFUser enableAutomaticUser];
    [PFUser logOut];
   // NSLog(@"UserLogout");
  
    } else {
       // NSLog(@"currentUser: %@", [PFUser currentUser]);
    
    }
}

-(IBAction)weiterList:(id)sender{
    
    [self performSegueWithIdentifier:@"AlreadyLog" sender:self];
    
    
    
}





- (IBAction)unwindToStart:(UIStoryboardSegue *)unwindSegue
{
}

- (IBAction)unwindToStart2:(UIStoryboardSegue *)unwindSegue
{
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
   // [self performSegueWithIdentifier:@"AlreadyLog" sender:self];
    }
}

- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"user_about_me", @"email", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
       [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
               // NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
               // NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
               // NSLog(@"User with facebook signed up and logged in!");
                [FBRequestConnection startWithGraphPath:@"me"
                                             parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                             HTTPMethod:@"GET"
                                      completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                          if (!error) {
                
                //[FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 // if (!error) {
                      
                     self.lblFullname.text = [NSString stringWithFormat:@"%@ %@",
                                               [result objectForKey:@"first_name"],
                                               [result objectForKey:@"last_name"]
                                               ];
                      
                      NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                      self.imgProfilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
                      
                      
                [[PFUser currentUser] setObject:[result objectForKey:@"email"] forKey:@"email"];
                      [[PFUser currentUser] setObject:[result objectForKey:@"id"] forKey:@"fbId"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"first_name"] forKey:@"firstname"];
                  [[PFUser currentUser] setObject:[result objectForKey:@"last_name"] forKey:@"lastname"];

                [[PFUser currentUser] saveInBackground];
                      
                                              [self viewDidAppear:YES];
                    
                }
                }];
                 
            } else {
               // NSLog(@"User with facebook logged in!");
            }
             [self viewDidAppear:YES];
            //[self _presentListViewControllerAnimated:YES];
            
           
    //[self performSegueWithIdentifier:@"SignFacebook" sender:self];
            
         //   NSLog(@"user %@", user);
          //  NSLog (@"result %@", _lblFullname.text);
         
        
            
            weiter.hidden = NO;
            _AlreadyLog.hidden = NO;
            _NotLog.hidden = YES;
            login.hidden = YES;
            logout.hidden = NO;
            signEmail.hidden  = YES;
            signFace.hidden = YES;
            _Or.hidden = YES;
            _User.hidden = NO;
            _User.text = user.email;
            forgot.hidden = YES;
            _lblFullname.hidden = NO;
            _imgProfilePicture.hidden = NO;
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (void)_loadData {
    // ...
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            self.lblFullname.text = [NSString stringWithFormat:@"%@ %@",
                                     [result objectForKey:@"first_name"],
                                     [result objectForKey:@"last_name"]
                                     ];
            
        

            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            // Run network request asynchronously
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:
             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (connectionError == nil && data != nil) {
                     // Set the image in the header imageView
                     self.imgProfilePicture.image = [UIImage imageWithData:data];
                 }
             }];
        }
    }];
}


@end
