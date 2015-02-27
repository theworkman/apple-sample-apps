#import "IOSMyDevicesController.h"      // Header
#import "RelayrControllers.h"           // HtH
#import "IOSCapabilitiesController.h"   // HtH
#import "IOSMainNavController.h"        // HtH

#define HtHSegueID_NoDevices        @"Segue_NoDevices"
#define HtHSegueID_SomeDevices      @"Segue_Devices"
#define HtHSegueID_ToCapabilities   @"Segue_Capabilities"

@interface IOSMyDevicesController ()
@property (readonly,nonatomic) UINavigationController <RelayrControllers>* navigationController;
@end

@implementation IOSMyDevicesController
{
    NSArray* _myDevices;      // They are actually RelayrTransmitters and RelayrDevices
}

#pragma mark - Public API

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the Refresh control
    UIRefreshControl* control = (self.refreshControl) ? self.refreshControl : [[UIRefreshControl alloc] init];
    control.tintColor = [UIColor whiteColor];
    [control addTarget:self action:@selector(refreshRequest:) forControlEvents:UIControlEventValueChanged];
    control.attributedTitle = [[NSAttributedString alloc] initWithString:@"Querying devices..." attributes:@{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0f]
    }];
    self.refreshControl = control;
    
    // Set tableview and request data
    self.tableView.rowHeight = 80.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self refreshRequest:nil];
}

- (UINavigationController <RelayrControllers>*)navigationController
{
    return (UINavigationController <RelayrControllers>*)super.navigationController;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:HtHSegueID_ToCapabilities])
    {
        IOSCapabilitiesController* destinationCntrll = segue.destinationViewController;
        destinationCntrll.selectedDevice = _myDevices[self.tableView.indexPathForSelectedRow.row];
    }
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    _myDevices = [self arrayTransmittersAndUniqueDevices];
    if (!_myDevices.count)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self performSegueWithIdentifier:HtHSegueID_NoDevices sender:self];
        return 0;
    }
    else
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self performSegueWithIdentifier:HtHSegueID_SomeDevices sender:self];
        return 1;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myDevices.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id myDevice = _myDevices[indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IOSMyDevicesCell"];
    if ([myDevice isKindOfClass:[RelayrTransmitter class]]) {
        RelayrTransmitter* transmitter = (RelayrTransmitter*)myDevice;
        cell.textLabel.text = transmitter.name;
        cell.detailTextLabel.text = transmitter.uid;
    } else if ([myDevice isKindOfClass:[RelayrDevice class]]) {
        RelayrDevice* device = (RelayrDevice*)myDevice;
        cell.textLabel.text = device.name;
        cell.detailTextLabel.text = device.uid;
    }
    return cell;
}

#pragma mark - Private functionality

- (void)refreshRequest:(UIRefreshControl*)sender
{
    __weak UITableView* weakTableView = self.tableView;
    return [self.navigationController.user queryCloudForIoTs:^(NSError* error) {
        [sender endRefreshing];
        if (error) { return; } // TODO: Show text to user...
        [weakTableView reloadData];
    }];
}

- (NSArray*)arrayTransmittersAndUniqueDevices
{
    RelayrUser* user = self.navigationController.user;
    NSMutableArray* result = [[NSMutableArray alloc] initWithArray:user.transmitters.allObjects];
    for (RelayrDevice* device in user.devices)
    {
        if (!device.transmitter) { [result addObject:device]; }
    }
    return (result.count) ? result : nil;
}

- (IBAction)signOutPressed:(UIBarButtonItem*)sender
{
    [((IOSMainNavController*)self.navigationController) signOut];
}

@end
