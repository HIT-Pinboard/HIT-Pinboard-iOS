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

static NSString * const cellIdentifier = @"PBIndexObjectCell";

@interface PBSubscribedViewController () <UITableViewDelegate>

@property (strong, nonatomic) PBArrayDataSource *objectsArrayDataSource;

@property (weak, nonatomic) PRRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL shouldRefreshData;

@end

@implementation PBSubscribedViewController

@synthesize objectsArrayDataSource = _objectsArrayDataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Feature";
    [self setupTableView];
    [self setupRefreshControl];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"tableViewShouldReload" object:nil queue:nil usingBlock:^(NSNotification *note){
        [_tableView reloadData];
        [self dataDidRefresh];
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshControl scrollViewDidEndDragging];
    if (self.shouldRefreshData) {
        [self dataDidRefresh];
        self.shouldRefreshData = NO;
    }
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
        [[PBManager sharedManager] requestSubscribedListFromIndex:0 Count:3 Tags:@[]];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}




#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
