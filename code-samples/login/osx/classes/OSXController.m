#import "OSXController.h"      // Header
#import <Relayr/Relayr.h>      // Relayr.framework

#define RelayrAppID             @"a47ee4f4-65b1-48c5-8fb5-39e939cb95f9"
#define RelayrAppSecret         @"ZPi4rtJdMv2BIIfjd9gPWFc7duYxCvGO"
#define RelayrAppRedirectURI    @"https://relayr.io"

@interface OSXController ()
@property (weak) IBOutlet NSButton* logButton;
@property (weak) IBOutlet NSProgressIndicator* logIndicator;
@property (weak) IBOutlet NSTextField* userLabel;
@end

@implementation OSXController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.backgroundColor = _backgroundColor.CGColor;
    _logIndicator.hidden = YES;
    _userLabel.hidden = YES;
}

#pragma mark - Private functionality

- (IBAction)buttonPressed:(NSButton*)sender
{
    static RelayrApp* storedApp;
    
    if ([sender.title isEqualToString:_signInText])
    {
        _logButton.hidden = YES;
        _userLabel.hidden = YES;
        
        _logIndicator.hidden = NO;
        [_logIndicator startAnimation:self];
        
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
        
        _logButton.title = _signInText;
        _logButton.hidden = NO;
        
        _userLabel.stringValue = @"";
        _userLabel.hidden = YES;
    }
}

- (void)showError:(NSError*)error
{
    [_logIndicator stopAnimation:self];
    _logIndicator.hidden = YES;
    
    _userLabel.stringValue = error.localizedDescription;
    _userLabel.hidden = NO;
    
    _logButton.title = _signInText;
    _logButton.hidden = NO;
}

- (void)showSuccessWithApp:(RelayrApp*)app user:(RelayrUser*)user
{
    [_logIndicator stopAnimation:self];
    _logIndicator.hidden = YES;
    
    _userLabel.stringValue = [NSString stringWithFormat:@"%@ with email: %@ is logged!", user.name, user.email];
    _userLabel.hidden = NO;
    
    _logButton.title = _signOutText;
    _logButton.hidden = NO;
}

@end
