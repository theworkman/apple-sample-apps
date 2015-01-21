#import "ViewController.h"      // Header
#import <Relayr/Relayr.h>       // Relayr.framework

#define RelayrAppID         @"72b0e324-74bf-4e07-82a5-da53e0133a1e"
#define RelayrAppSecret     @"_ifE7jQHgZ9DKi5-TiLBXQOAT6ibp6Zf"
#define RelayrRedirectURI   @"https://relayr.io"

@interface ViewController ()
@property (weak,nonatomic) IBOutlet UILabel* currentTempLabel;
@property (weak,nonatomic) IBOutlet UILabel* currentHumidLabel;
@end

@implementation ViewController

#pragma mark - Public API

- (void)viewDidLoad
{
    static RelayrApp* storedApp;
    [super viewDidLoad];
    
    // Retrieve the RelayrApp that you have created on the developer dashboard.
    [RelayrApp appWithID:RelayrAppID OAuthClientSecret:RelayrAppSecret redirectURI:RelayrRedirectURI completion:^(NSError* error, RelayrApp* app) {
        if (error) { return NSLog(@"There was an error retrieving the RelayrApp."); }
        storedApp = app;
        
        // Sign in an user into your Relayr App.
        [app signInUser:^(NSError* error, RelayrUser* user) {
            if (error) { return NSLog(@"There was an error signing the user."); }
            
            // Retrieve the transmitters and devices owned by the user.
            [user queryCloudForIoTs:^(NSError* error) {
                if (error) { return NSLog(@"There was an error retrieving the users IoT."); }
                
                // To simplify, we suppose that the user has only one transmitter (wunderbar)
                RelayrTransmitter* transmitter = user.transmitters.anyObject;
                if (!transmitter) { return NSLog(@"The user has no wunderbars."); }
                
                // The Relayr cloud mantains a specific list of "meanings" specifying the capabilities of devices. In this case we are interested in "temperature"
                RelayrDevice* device = [transmitter devicesWithInputMeaning:@"temperature"].anyObject;
                if (!device) { return NSLog(@"The user hasn't onboard the temperature sensor."); }
                
                [device subscribeToAllInputsWithBlock:^(RelayrDevice* device, RelayrInput* input, BOOL* unsubscribe) {
                    if ([input.meaning isEqualToString:@"temperature"])
                    {
                        _currentTempLabel.text = [NSString stringWithFormat:@"%@ ºC", input.value];
                    }
                    else if ([input.meaning isEqualToString:@"humidity"])
                    {
                        _currentHumidLabel.text = [NSString stringWithFormat:@"%@ %%", input.value];
                    }
                    
                } error:^(NSError* error) {
                    NSLog(@"%@", error.localizedDescription);
                }];
            }];
        }];
    }];
}

// Make the status bar white for the blue-ish background :)
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
