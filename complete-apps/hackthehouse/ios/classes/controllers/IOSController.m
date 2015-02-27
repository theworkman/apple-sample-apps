#import "IOSController.h"   // Header
#import <Relayr/Relayr.h>   // Relayr.framework

#define RelayrAppID             @"52b69a48-cd9e-4285-b1ab-8390a1d9f79b"
#define RelayrAppSecret         @"uGw..qP.8JiXxKV_jWRcnJFviALqaPr6"
#define RelayrAppRedirectURI    @"https://relayr.io"
#define HtHSegueID_Kickstart    @"Segue_Kickstart"

@interface IOSController ()
@property (weak,nonatomic) IBOutlet UIButton* logButton;
@property (weak,nonatomic) IBOutlet UILabel* userLabel;
@property (weak,nonatomic) IBOutlet UIActivityIndicatorView* logIndicator;
@end

@implementation IOSController

@synthesize app = _app;
@synthesize user = _user;

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    _logIndicator.hidden = YES;
    
    // Check if there was already an app stored (with some users logged in).
    RelayrApp* app = [RelayrApp retrieveAppWithIDFromFileSystem:RelayrAppID];
    RelayrUser* user = app.loggedUsers.firstObject;
    if (app && user)
    {
        // TODO: Fix this dumb dispatch_after for the UI to finish loading. Put the code in AppDelegate, and then load the appropriate viewController.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showSuccessWithApp:app user:user];
        });
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:HtHSegueID_Kickstart])
    {
        UIViewController <RelayrControllers>* destinationController = (UIViewController <RelayrControllers>*)segue.destinationViewController;
        destinationController.app = _app;
        destinationController.user = _user;
    }
}

#pragma mark - Private functionality

- (IBAction)buttonPressed:(UIButton*)sender
{
    _logButton.hidden = YES;
    _userLabel.hidden = YES;
    
    _logIndicator.hidden = NO;
    [_logIndicator startAnimating];
    
    __weak IOSController* weakSelf = self;
    [RelayrApp appWithID:RelayrAppID OAuthClientSecret:RelayrAppSecret redirectURI:RelayrAppRedirectURI completion:^(NSError* errorApp, RelayrApp* app) {
        if (errorApp) { return [self showError:errorApp]; }
        
        [app signInUser:^(NSError* errorUser, RelayrUser* user) {
            if (errorUser) { return [weakSelf showError:errorUser]; }
            [weakSelf showSuccessWithApp:app user:user];
        }];
    }];
}

- (void)showError:(NSError*)error
{
    [_logIndicator stopAnimating];
    _logIndicator.hidden = YES;
    
    _userLabel.text = error.localizedDescription;
    _userLabel.hidden = NO;
    _logButton.hidden = NO;
}

- (void)showSuccessWithApp:(RelayrApp*)app user:(RelayrUser*)user
{
    if (!app || !user) { return [self showError:[NSError errorWithDomain:@"Hack the House" code:1 userInfo:nil]]; }
    
    [_logIndicator stopAnimating];
    _logIndicator.hidden = YES;
    
    _userLabel.text = [NSString stringWithFormat:@"%@ with email: %@ is logged!", user.name, user.email];
    _userLabel.hidden = NO;
    _logButton.hidden = NO;
    
    _app = app;
    _user = user;
    [self performSegueWithIdentifier:HtHSegueID_Kickstart sender:self];
}

@end
