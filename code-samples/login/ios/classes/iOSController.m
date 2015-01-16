#import "iOSController.h"       // Header
#import <Relayr/Relayr.h>       // Relayr.framework

#define RelayrAppID             @"a47ee4f4-65b1-48c5-8fb5-39e939cb95f9"
#define RelayrAppSecret         @"ZPi4rtJdMv2BIIfjd9gPWFc7duYxCvGO"
#define RelayrAppRedirectURI    @"https://relayr.io"

@interface iOSController ()
@property (weak,nonatomic) IBOutlet UIButton* logButton;
@property (weak,nonatomic) IBOutlet UILabel* userLabel;
@property (weak,nonatomic) IBOutlet UIActivityIndicatorView* logIndicator;
@end

@implementation iOSController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    _logIndicator.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private functionality

- (IBAction)buttonPressed:(UIButton*)sender
{
    static RelayrApp* storedApp;
    
    if ([sender.titleLabel.text isEqualToString:_signInText])
    {
        _logButton.hidden = YES;
        _userLabel.hidden = YES;
        
        _logIndicator.hidden = NO;
        [_logIndicator startAnimating];
        
        [RelayrApp appWithID:RelayrAppID OAuthClientSecret:RelayrAppSecret redirectURI:RelayrAppRedirectURI completion:^(NSError* errorApp, RelayrApp* app) {
            
            if (errorApp) { return [self showError:errorApp]; }
            storedApp = app;
            
            [storedApp signInUser:^(NSError* errorUser, RelayrUser* user) {
                
                if (errorUser) { return [self showError:errorUser]; }
                [self showSuccessWithApp:storedApp user:user];
            }];
        }];
    }
    else
    {
        RelayrUser* user = storedApp.loggedUsers.firstObject;
        [storedApp signOutUser:user];
        storedApp = nil;
        
        _logButton.backgroundColor = _signInBackgroundColor;
        [_logButton setTitle:_signInText forState:UIControlStateNormal];
        _logButton.hidden = NO;
        
        _userLabel.text = nil;
        _userLabel.hidden = YES;
    }
}

- (void)showError:(NSError*)error
{
    [_logIndicator stopAnimating];
    _logIndicator.hidden = YES;
    
    _userLabel.text = error.localizedDescription;
    _userLabel.hidden = NO;
    
    [_logButton setTitle:_signInText forState:UIControlStateNormal];
    _logButton.backgroundColor = _signInBackgroundColor;
    _logButton.hidden = NO;
}

- (void)showSuccessWithApp:(RelayrApp*)app user:(RelayrUser*)user
{
    [_logIndicator stopAnimating];
    _logIndicator.hidden = YES;
    
    _userLabel.text = [NSString stringWithFormat:@"%@ with email: %@ is logged!", user.name, user.email];
    _userLabel.hidden = NO;
    
    [_logButton setTitle:_signOutText forState:UIControlStateNormal];
    _logButton.backgroundColor = _signOutBackgroundColor;
    _logButton.hidden = NO;
}

@end
