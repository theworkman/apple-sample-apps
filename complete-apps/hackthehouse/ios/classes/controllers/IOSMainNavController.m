#import "IOSMainNavController.h"    // Header
#import <Relayr/Relayr.h>           // Relayr.framework

#define HtHSegueID_SignOut          @"Segue_Signout"

@implementation IOSMainNavController

@synthesize app = _app;
@synthesize user = _user;

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)signOut
{
    [RelayrApp removeAppFromFileSystem:_app];
    _app = nil;
    _user = nil;
    [self performSegueWithIdentifier:HtHSegueID_SignOut sender:self];
}

@end
