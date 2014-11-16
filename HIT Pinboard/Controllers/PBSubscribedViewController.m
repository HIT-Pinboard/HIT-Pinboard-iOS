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

@synthesize objectsArrayDataSource = _objectsArrayDataSource, firstScroll = _firstScroll, shouldRequest = _shouldRequest;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Feature";
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
    NSIndexSet *indexSet = userInfo[@"updateLocation"];
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }];
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
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
        for (NSString *tagValue in object.tags) {
            [strArr addObject:[[[PBManager sharedManager] tagsList] tagNameForValue:tagValue]];
        }
        cell.subtitleLabel.text = [[strArr valueForKey:@"description"] componentsJoinedByString:@" "];
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
        [[PBManager sharedManager] requestSubscribedListFromIndex:[[PBManager sharedManager] subscribedList].count Count:10 Tags:@[] shouldClear:NO];
        _shouldRequest = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshControl scrollViewDidEndDragging];
    if (self.shouldRefreshData) {
        [self dataDidRefresh];
        self.shouldRefreshData = NO;
    }
    if (!_firstScroll) {
        CGFloat actualPosition = scrollView.contentOffset.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
        //        CGFloat barHeight = 88.0f;
        if (actualPosition + deviceHeight >= contentHeight) {
            _shouldRequest = YES;
        }
    }
    _firstScroll = NO;
}

- (void)dataDidRefresh
{
    [self.refreshControl endRefreshing];
}

- (void)refreshControlTriggered:(PRRefreshControl *)sender
{
    [sender beginRefreshing];
    if (_tableView.isDragging) {
        self.shouldRefreshData = YES;
    } else {
        [[PBManager sharedManager] requestSubscribedListFromIndex:0 Count:10 Tags:@[] shouldClear:YES];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        PBDetailViewController *destVC = [segue destinationViewController];
        PBIndexObject *indexObject = [[[PBManager sharedManager] subscribedList] objectAtIndex:indexPath.row];
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
