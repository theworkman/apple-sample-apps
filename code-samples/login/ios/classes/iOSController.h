@import UIKit;      // Apple

@interface iOSController : UIViewController

@property (strong,nonatomic) IBInspectable UIColor* signInBackgroundColor;
@property (strong,nonatomic) IBInspectable UIColor* signOutBackgroundColor;

@property (strong,nonatomic) IBInspectable NSString* signInText;
@property (strong,nonatomic) IBInspectable NSString* signOutText;

@end

