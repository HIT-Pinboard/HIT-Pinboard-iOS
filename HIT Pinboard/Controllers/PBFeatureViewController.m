//
//  PBFeatureViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBFeatureViewController.h"
#import "PBTableViewCell.h"
#import "PBIndexObject.h"
#import "PBManager.h"
#import "PBArrayDataSource.h"
#import "NSArray+PBSubscribeTag.h"

static NSString * const cellIdentifier = @"PBIndexObjectCell";

@interface PBFeatureViewController () <UITableViewDelegate>

@property (strong, nonatomic) PBArrayDataSource *objectsArrayDataSource;

@end

@implementation PBFeatureViewController

@synthesize objectsArrayDataSource = _objectsArrayDataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Feature";
    [self setupTableView];
    _tableView.rowHeight = 80.0f;
    
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:[PBManager sharedManager] action:@selector(requestFeatureList)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"tableViewShouldReload" object:nil queue:nil usingBlock:^(NSNotification *note){
        [_tableView reloadData];
    }];
#ifdef DEBUG
    NSLog(@"tableViewShouldReload notification registered");
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:nil name:@"tableViewShouldReload" object:nil];
#ifdef DEBUG
    NSLog(@"tableViewShouldReload notification removed");
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupTableView
{
    TableViewCellConfigureBlock configureCell = ^(PBTableViewCell *cell, PBIndexObject *object) {
        cell.titleLabel.text = object.title;
        NSMutableArray *strArr = [@[] mutableCopy];
        for (NSString *tagValue in object.tags) {
            [strArr addObject:[[[PBManager sharedManager] tagsList] tagNameForValue:tagValue]];
        }
        cell.subtitleLabel.text = [[strArr valueForKey:@"description"] componentsJoinedByString:@" "];
    };
    NSArray *objects = [[PBManager sharedManager] featureList];
    _objectsArrayDataSource = [[PBArrayDataSource alloc] initWithItems:objects
                                                         cellIdentifier:cellIdentifier
                                                     configureCellBlock:configureCell];
    _tableView.dataSource = _objectsArrayDataSource;
    _tableView.delegate = self;
    [_tableView registerNib:[PBTableViewCell nib] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
