#import "OSXController.h"      // Header
#import <Relayr/Relayr.h>      // Relayr.framework

#define RelayrAppID             @"72b0e324-74bf-4e07-82a5-da53e0133a1e"
#define RelayrAppSecret         @"_ifE7jQHgZ9DKi5-TiLBXQOAT6ibp6Zf"
#define RelayrAppRedirectURI    @"https://relayr.io"

@interface OSXController ()
@property (weak,nonatomic) IBOutlet NSTextField* currentTempLabel;
@property (weak,nonatomic) IBOutlet NSTextField* currentHumidLabel;
@end

@implementation OSXController

#pragma mark - Public API

- (void)viewDidLoad
{
    static RelayrApp* storedApp;
    
    [super viewDidLoad];
    self.view.layer.backgroundColor = _backgroundColor.CGColor;
    
    // Retrieve the RelayrApp that you have created on the developer dashboard.
    [RelayrApp appWithID:RelayrAppID OAuthClientSecret:RelayrAppSecret redirectURI:RelayrAppRedirectURI completion:^(NSError* errorApp, RelayrApp* app) {
        if (errorApp) { return NSLog(@"There was an error retrieving the RelayrApp: %@", errorApp); }
        storedApp = app;
        
        // Sign in an user into your Relayr App.
        [storedApp signInUser:^(NSError* errorUser, RelayrUser* user) {
            
            if (errorUser) { return NSLog(@"There was an error signing the user: %@", errorUser); }
            [self showSuccessWithApp:storedApp user:user];
        }];
    }];
}

#pragma mark - Private functionality

- (void)showSuccessWithApp:(RelayrApp*)app user:(RelayrUser*)user
{
    // Retrieve the transmitters and devices owned by the user.
    [user queryCloudForIoTs:^(NSError* error) {
        if (error) { return NSLog(@"There was an error retrieving the users IoT: %@", error); }
        
        // To simplify, we suppose that the user has only one transmitter (wunderbar)
        RelayrTransmitter* transmitter = user.transmitters.anyObject;
        if (!transmitter) { return NSLog(@"The user has no wunderbars."); }
        
        // The Relayr cloud mantains a specific list of "meanings" specifying the capabilities of devices. In this case we are interested in "temperature"
        RelayrDevice* device = [transmitter devicesWithInputMeaning:@"temperature"].anyObject;
        if (!device) { return NSLog(@"The user hasn't onboard the temperature sensor."); }
        
        [device subscribeToAllInputsWithBlock:^(RelayrDevice* device, RelayrInput* input, BOOL* unsubscribe) {
            if ([input.meaning isEqualToString:@"temperature"])
            {
                _currentTempLabel.stringValue = [NSString stringWithFormat:@"%@ ºC", input.value];
            }
            else if ([input.meaning isEqualToString:@"humidity"])
            {
                _currentHumidLabel.stringValue = [NSString stringWithFormat:@"%@ %%", input.value];
            }
            
        } error:^(NSError* error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }];
}

@end
