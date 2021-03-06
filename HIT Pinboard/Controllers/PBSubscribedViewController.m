//
//  PBSubscribedViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <PRRefreshControl/PRRefreshControl.h>
#import "PBSubscribedViewController.h"
#import "PBTableViewCell.h"
#import "PBIndexObject.h"
#import "PBManager.h"
#import "PBArrayDataSource.h"
#import "NSArray+PBSubscribeTag.h"
#import "PBDetailViewController.h"

static NSString * const cellIdentifier = @"PBIndexObjectCell";

@interface PBSubscribedViewController () <UITableViewDelegate>

@property (strong, nonatomic) PBArrayDataSource *objectsArrayDataSource;

@property (weak, nonatomic) PRRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL shouldRefreshData;
@property (assign, nonatomic) BOOL firstScroll;
@property (assign, nonatomic) BOOL shouldRequest;

@end

@implementation PBSubscribedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"My News", @"Displaying the latest user subscribed news from HIT");
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setupTableView];
    [self setupRefreshControl];
    _firstScroll = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedReload) name:@"tableViewShouldReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedUpdate:) name:@"tableViewShouldUpdate" object:nil];
#ifdef DEBUG
    NSLog(@"tableViewShouldReload notification registered");
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tableViewShouldReload" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tableViewShouldUpdate" object:nil];
#ifdef DEBUG
    NSLog(@"tableViewShouldReload notification removed");
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Notifications
- (void)receivedReload
{
    [_tableView reloadData];
    [self dataDidRefresh];
}

- (void)receivedUpdate:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSMutableArray *indexPaths = userInfo[@"indexPaths"];
    NSIndexSet *indexSet = userInfo[@"indexSet"];
    [_tableView beginUpdates];
    [_tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

#pragma mark -
#pragma mark - ViewController Setup

- (void)setupRefreshControl
{
    PRRefreshControl *refreshControl = [[PRRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshControlTriggered:)
             forControlEvents:UIControlEventValueChanged];
    _refreshControl = refreshControl;
    [_tableView addSubview:refreshControl];
}

- (void)setupTableView
{
    TableViewCellConfigureBlock configureCell = ^(PBTableViewCell *cell, PBIndexObject *object) {
        cell.titleLabel.text = object.title;
        NSMutableArray *strArr = [@[] mutableCopy];
        NSArray *tagsList = [[PBManager sharedManager] tagsList];
        for (NSString *tagValue in object.tags) {
            [strArr addObject:[tagsList tagNameForValue:tagValue]];
        }
        cell.subtitleLabel.text = [[strArr valueForKey:@"description"] componentsJoinedByString:@" "];
        cell.imageView.image = [tagsList tagImageForValue:object.tags.firstObject];
    };
    NSArray *objects = [[PBManager sharedManager] subscribedList];
    _objectsArrayDataSource = [[PBArrayDataSource alloc] initWithItems:objects
                                                        cellIdentifier:cellIdentifier
                                                    configureCellBlock:configureCell];
    _tableView.dataSource = _objectsArrayDataSource;
    _tableView.delegate = self;
    _tableView.rowHeight = 80.0f;
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [_tableView registerNib:[PBTableViewCell nib] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark -
#pragma mark - PRRefreshController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_shouldRequest) {
        NSUInteger count = 0;
        for (NSArray *eachDay in [[PBManager sharedManager] subscribedList]) {
            count += eachDay.count;
        }
        [[PBManager sharedManager] requestSubscribedListFromIndex:count Count:10 shouldClear:NO];
        _shouldRequest = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshControl scrollViewDidEndDragging];

    if (!_firstScroll) {
        CGFloat actualPosition = scrollView.contentOffset.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat delta = 240.0f;
        if (actualPosition + deviceHeight + delta >= contentHeight) {
            _shouldRequest = YES;
        }
    }
}

- (void)dataDidRefresh
{
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    [tabBarItem2 setBadgeValue:nil];
    _firstScroll = NO;
}

- (void)refreshControlTriggered:(PRRefreshControl *)sender
{
    [[PBManager sharedManager] requestSubscribedListFromIndex:0 Count:10 shouldClear:YES];
    _firstScroll = YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        PBDetailViewController *destVC = [segue destinationViewController];
        PBIndexObject *indexObject = [_objectsArrayDataSource itemAtIndexPath:indexPath];
        destVC.requestURL = indexObject.urlString;
    }
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
