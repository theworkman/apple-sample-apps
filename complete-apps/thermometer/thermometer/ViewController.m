#import "ViewController.h"      // Header
#import <Relayr/Relayr.h>       // Relayr.framework

#define RelayrAppID         @"72b0e324-74bf-4e07-82a5-da53e0133a1e"
#define RelayrAppSecret     @"_ifE7jQHgZ9DKi5-TiLBXQOAT6ibp6Zf"
#define RelayrRedirectURI   @"https://relayr.io"

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RelayrApp appWithID:RelayrAppID OAuthClientSecret:RelayrAppSecret redirectURI:RelayrRedirectURI completion:^(NSError* error, RelayrApp* app) {
        if (error) { return; }
        
        [app signInUser:^(NSError* error, RelayrUser* user) {
            if (error) { return; }
            
            NSLog(@"User correctly signed!");
        }];
    }];
}

@end
