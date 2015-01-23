#import "IOSController.h"       // Header
#import <Relayr/Relayr.h>           // Relayr.framework

@interface IOSController ()
@property (weak,nonatomic) IBOutlet UILabel* reachabilityLabel;
@property (weak,nonatomic) IBOutlet UILabel* emailLabel;
@end

@implementation IOSController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkReachability];
    [self checkEmail];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private functionality

- (IBAction)screenTapped:(UITapGestureRecognizer*)sender
{
    [self checkReachability];
    [self checkEmail];
}

- (void)checkReachability
{
    _reachabilityLabel.text = @"--";

    [RelayrCloud isReachable:^(NSError* error, NSNumber* isReachable) {
        _reachabilityLabel.text = (isReachable.boolValue) ? @"YES" : @"NO";
    }];
}

- (void)checkEmail
{
    _emailLabel.text = @"--";

    [RelayrCloud isUserWithEmail:@"Miley@WreckingBall.com" registered:^(NSError* error, NSNumber* isUserRegistered) {
        _emailLabel.text = (isUserRegistered.boolValue) ? @"YES" : @"NO";
    }];
}

@end
