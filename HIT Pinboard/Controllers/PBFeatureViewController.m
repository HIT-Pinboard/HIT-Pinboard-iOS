//
//  PBFeatureViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <PRRefreshControl/PRRefreshControl.h>
#import "PBFeatureViewController.h"
#import "PBTableViewCell.h"
#import "PBIndexObject.h"
#import "PBManager.h"
#import "PBArrayDataSource.h"
#import "NSArray+PBSubscribeTag.h"
#import "PBDetailViewController.h"

static NSString * const cellIdentifier = @"PBIndexObjectCell";

@interface PBFeatureViewController () <UITableViewDelegate>

@property (strong, nonatomic) PBArrayDataSource *objectsArrayDataSource;

@property (weak, nonatomic) PRRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL shouldRefreshData;

@end

@implementation PBFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Featured", @"Displaying the latest 25 news from HIT");
    self.tabBarController.tabBar.translucent = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setupTableView];
    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSuccess) name:@"tableViewShouldReload" object:nil];
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
- (void)receivedSuccess
{
    [_tableView reloadData];
    [self dataDidRefresh];
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
    NSArray *objects = [[PBManager sharedManager] featureList];
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
}

- (void)dataDidRefresh
{
    [self.refreshControl endRefreshing];
}

- (void)refreshControlTriggered:(PRRefreshControl *)sender
{
    [[PBManager sharedManager] requestFeatureList];
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
