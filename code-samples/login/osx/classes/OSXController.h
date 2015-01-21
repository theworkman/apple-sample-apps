@import Cocoa;      // Apple

@interface OSXController : NSViewController

@property (strong,nonatomic) IBInspectable NSColor* backgroundColor;

@property (strong,nonatomic) IBInspectable NSString* signInText;
@property (strong,nonatomic) IBInspectable NSString* signOutText;

@end
