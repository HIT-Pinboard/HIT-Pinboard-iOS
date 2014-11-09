//
//  PBSettingsTableViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/9/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBSettingsTableViewController.h"
#import "PBManager.h"

@interface PBSettingsTableViewController ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *icons;
@property (weak, nonatomic) IBOutlet UISwitch *noPicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pushNotificationSwitch;
@property (strong, nonatomic) NSArray *iconsArray;
- (IBAction)noPicSwitchChanged:(UISwitch *)sender;
- (IBAction)pushNotificationSwitchChanged:(UISwitch *)sender;

@end

@implementation PBSettingsTableViewController

@synthesize icons = _icons, noPicSwitch = _noPicSwitch, pushNotificationSwitch = _pushNotificationSwitch,
            iconsArray = _iconsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    PBManager *mgr = [PBManager sharedManager];
    _iconsArray = [_icons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        if ([obj1 frame].origin.y < [obj2 frame].origin.y) return NSOrderedAscending;
        else if ([obj1 frame].origin.y > [obj2 frame].origin.y) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    _noPicSwitch.on = !mgr.shouldDisplayImages;
    _pushNotificationSwitch.on = mgr.shouldEnableNotification;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 2;
            break;
        case 1:
            count = 3;
            break;
        case 2:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

- (IBAction)noPicSwitchChanged:(UISwitch *)sender
{
    PBManager *mgr = [PBManager sharedManager];
    mgr.shouldDisplayImages = !mgr.shouldDisplayImages;
    [mgr saveSettings];
}

- (IBAction)pushNotificationSwitchChanged:(UISwitch *)sender
{
    PBManager *mgr = [PBManager sharedManager];
    mgr.shouldEnableNotification = !mgr.shouldEnableNotification;
    [mgr saveSettings];
    // to-do
}
@end
