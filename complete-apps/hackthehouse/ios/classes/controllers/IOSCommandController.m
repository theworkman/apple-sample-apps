#import "IOSCommandController.h"    // Header
#import <Relayr/Relayr.h>           // Relayr.framework

@interface IOSCommandController ()
@property (weak,nonatomic) IBOutlet UILabel* meaningLabel;
@property (weak,nonatomic) IBOutlet UITextField* valueTextField;
@end

@implementation IOSCommandController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    _meaningLabel.text = [NSString stringWithFormat:@"Send value to %@ command", _command.meaning];
}

#pragma mark - Private functionality

- (IBAction)editingDidEndOnTextField:(UITextField*)sender
{
    // TODO: There will be problems here, since it has to be a specific value.
    [_command sendValue:_valueTextField.text withCompletion:^(NSError* error) {
        if (!error) { printf("Command was send successfully!"); }
        else { printf("The following error happened when trying to send a command:\n\t%s", error.localizedDescription.UTF8String); }
    }];
}

@end
