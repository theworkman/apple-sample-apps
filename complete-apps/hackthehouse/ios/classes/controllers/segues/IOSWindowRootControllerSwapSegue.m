#import "IOSWindowRootControllerSwapSegue.h"    // Header
#import "IOSAppDelegate.h"                      // HtH

@implementation IOSWindowRootControllerSwapSegue

- (void)perform
{
    [UIApplication sharedApplication].keyWindow.rootViewController = self.destinationViewController;
}

@end
