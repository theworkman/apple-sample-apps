@import Foundation;         // Apple
#import <Relayr/Relayr.h>   // Relayr.framework

@protocol RelayrControllers <NSObject>

@property (strong,nonatomic) RelayrApp* app;
@property (strong,nonatomic) RelayrUser* user;

@end
