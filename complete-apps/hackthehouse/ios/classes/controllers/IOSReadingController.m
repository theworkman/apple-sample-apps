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
        weakSelf.valueLabel.text = reading.value;
    } error:^(NSError *error) {
        weakSelf.meaningLabel.text = [NSString stringWithFormat:@"There was an error subscribing to %@ reading. Please, try again.", _reading.meaning];
        weakSelf.valueLabel.text = @"--";
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_reading unsubscribeToAll];
}

@end
