#import "IOSMainNavController.h"    // Header

@interface IOSMainNavController ()
@end

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

@end
