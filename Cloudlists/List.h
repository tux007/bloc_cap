

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface List : NSObject

@property (nonatomic, strong) NSString *item; // name of item
@property (nonatomic, strong) NSString *listname; // name of list
@property (nonatomic, strong) NSString *username; // name of list
@property (nonatomic, strong) NSArray *friends; // name of list
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSString *multi;
@property (nonatomic, strong)NSArray *done;

@end
