#import "OSXController.h"       // Header
#import <Relayr/Relayr.h>       // Relayr.framework

@interface OSXController ()
@property (strong) IBOutlet NSTextField* reachabilityLabel;
@property (strong) IBOutlet NSTextField* emailLabel;
@end

@implementation OSXController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = _backgroundColor.CGColor;
    
    [self checkReachability];
    [self checkEmail];
}

- (void)mouseUp:(NSEvent*)theEvent
{
    [self checkReachability];
    [self checkEmail];
}

#pragma mark - Private functionality

- (void)checkReachability
{
    _reachabilityLabel.stringValue = @"--";

    [RelayrCloud isReachable:^(NSError* error, NSNumber* isReachable) {
        _reachabilityLabel.stringValue = (isReachable.boolValue) ? @"YES" : @"NO";
    }];
}

- (void)checkEmail
{
    _emailLabel.stringValue = @"--";
    
    [RelayrCloud isUserWithEmail:@"MileyCyrus@WreckingBall.com" registered:^(NSError* error, NSNumber* isUserRegistered) {
        _emailLabel.stringValue = (isUserRegistered.boolValue) ? @"YES" : @"NO";
    }];
}

@end
