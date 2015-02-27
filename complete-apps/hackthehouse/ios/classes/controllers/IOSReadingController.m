#import "IOSReadingController.h"    // Header
#import <Relayr/Relayr.h>           // Relayr.framework

@interface IOSReadingController ()
@property (weak, nonatomic) IBOutlet UILabel* meaningLabel;
@property (weak, nonatomic) IBOutlet UILabel* valueLabel;
@end

@implementation IOSReadingController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    _meaningLabel.text = [NSString stringWithFormat:@"Subscribing to %@ reading...", _reading.meaning];
}

- (void)viewWillAppear:(BOOL)animated
{
    __weak IOSReadingController* weakSelf = self;
    [_reading subscribeWithBlock:^(RelayrDevice* device, RelayrReading* reading, BOOL* unsubscribe) {
        weakSelf.meaningLabel.text = [NSString stringWithFormat:@"Value received from %@ reading", _reading.meaning];
        weakSelf.valueLabel.text = [self transformValue:reading.value withUnit:reading.unit];
    } error:^(NSError* error) {
        weakSelf.meaningLabel.text = [NSString stringWithFormat:@"There was an error subscribing to %@ reading. Please, try again.", _reading.meaning];
        weakSelf.valueLabel.text = @"--";
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_reading unsubscribeToAll];
}

#pragma mark - Private functionality

- (NSString*)transformValue:(id)value withUnit:(NSString*)unit
{
    if (!value) { return @"--"; }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        NSNumber* numberValue = value;
        if ([unit isEqualToString:@"boolean"]) {
            return (numberValue.boolValue) ? @"ON" : @"OFF";
        } else {
            return numberValue.stringValue;
        }
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString* arrayValue = value;
        // Perform here any mke up you want.
        return arrayValue.description;
    } else {
        NSObject* obj = value;
        // Perform here any mke up you want.
        return obj.description;
    }
    
    return ((NSObject*)value).description;
}

@end
