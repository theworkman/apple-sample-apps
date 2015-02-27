#import "IOSAppDelegate.h"      // Header
#import "RelayrControllers.h"   // HtH
#import <Relayr/Relayr.h>       // Relayr.framework

@interface IOSAppDelegate ()
@end

@implementation IOSAppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    RelayrApp* app = ((UIViewController <RelayrControllers>*)self.window.rootViewController).app;
    [RelayrApp persistAppInFileSystem:app];
}

@end
