#import "OSXController.h"      // Header
#import <Relayr/Relayr.h>      // Relayr.framework

@implementation OSXController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.backgroundColor = _backgroundColor.CGColor;
}

#pragma mark - Private functionality

@end
