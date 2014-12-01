//
//  PBSettingsTableViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/9/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "PBSettingsTableViewController.h"
#import "PBConstants.h"
#import "PBManager.h"

@interface PBSettingsTableViewController () <MFMailComposeViewControllerDelegate>

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
    self.title = @"设置";
    PBManager *mgr = [PBManager sharedManager];
    _iconsArray = [_icons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        if ([obj1 frame].origin.y < [obj2 frame].origin.y) return NSOrderedAscending;
        else if ([obj1 frame].origin.y > [obj2 frame].origin.y) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
#ifdef DEBUG
        NSLog(@"%lu", [[[UIApplication sharedApplication] currentUserNotificationSettings] types]);
#endif
        if ([[[UIApplication sharedApplication] currentUserNotificationSettings] types] == (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge)) {
            _pushNotificationSwitch.enabled = YES;
        } else {
            _pushNotificationSwitch.enabled = NO;
        }
    } else {
        UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
#ifdef DEBUG
        NSLog(@"%lu", enabledTypes);
#endif
        if (enabledTypes == (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge)) {
            _pushNotificationSwitch.enabled = YES;
        } else {
            _pushNotificationSwitch.enabled = NO;
        }
    }
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self rateThisApp];
                    break;
                case 1:
                    [self composeEmail];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                [[PBManager sharedManager] clearCache];
            }
        case 2:
            if (indexPath.row == 0) {
//                [self performSegueWithIdentifier:@"" sender:self];
            }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 
#pragma mark - Actions

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
    [mgr updatePushSetting];
}

#pragma mark -
#pragma mark - Select method

- (void)rateThisApp
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreURL]];
}

- (void)composeEmail
{
    NSString *title = @"意见反馈";
    NSString *body = @"请在下面写下您对本App的意见和反馈。";
    NSArray *recipient = @[@"admin@cs.hit.edu.cn"];
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    [composer setSubject:title];
    [composer setMessageBody:body isHTML:NO];
    [composer setToRecipients:recipient];
    
    [self presentViewController:composer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"%u", result);
#endif
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"感谢您的反馈" message:@"我们可能无法一一回复所有的邮件，但是我们一定会听到您的声音。" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}
@end
