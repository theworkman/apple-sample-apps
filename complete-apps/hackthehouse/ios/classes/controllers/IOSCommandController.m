#import "IOSCommandController.h"    // Header
#import <Relayr/Relayr.h>           // Relayr.framework

@interface IOSCommandController ()
@property (weak,nonatomic) IBOutlet UILabel* meaningLabel;
@property (weak,nonatomic) IBOutlet UITextField* valueTextField;
@end

@interface IOSCommandController () <UITextFieldDelegate>

@end

@implementation IOSCommandController

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    _meaningLabel.text = [NSString stringWithFormat:@"Send value to %@ command", _command.meaning];
}

#pragma mark - Private functionality

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField.text.length)
    {
        BOOL commandAccepted = [self sendCommandEncodedInString:textField.text];
        if (commandAccepted) { textField.text = @""; }
    }
    return NO;
}

- (BOOL)sendCommandEncodedInString:(NSString*)string
{
    id valueResult;
    NSString* unit = _command.unit;
    if (!unit.length || !string.length) { return NO; }
    
    if ([unit isEqualToString:@"boolean"])
    {
        return valueResult = [NSNumber numberWithBool:string.boolValue];
    }
    else if ([unit isEqualToString:@"integer"] || [unit isEqualToString:@"number"])
    {
        valueResult = [[self sharedNumberFormatter] numberFromString:string];
        if (!valueResult) { return NO; }
    }
    else { valueResult = string; }
    
    [_command sendValue:valueResult withCompletion:^(NSError* error) {
        if (!error) { printf("Command was send successfully!"); }
        else { printf("The following error happened when trying to send a command:\n\t%s", error.localizedDescription.UTF8String); }
    }];
    
    return YES;
}

- (NSNumberFormatter*)sharedNumberFormatter
{
    static NSNumberFormatter* fmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmt = [[NSNumberFormatter alloc] init];
        fmt.numberStyle = NSNumberFormatterDecimalStyle;
    });
    return fmt;
}

@end
