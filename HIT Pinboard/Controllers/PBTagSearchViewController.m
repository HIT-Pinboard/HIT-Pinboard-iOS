//
//  PBTagSearchViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/17/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBTagSearchViewController.h"
#import "PBSubscribeTag.h"
#import "PBManager.h"

@interface PBTagSearchViewController () <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) PBSubscribeTag *selectedTag;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end

@implementation PBTagSearchViewController

@synthesize searchResults = _searchResults, selectedTag = _selectedTag;

+ (NSString *)nibName
{
    return @"PBTagSearchViewController";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveTag)];
    self.title = @"添加订阅";
    _searchResults = [[[PBManager sharedManager] tagsList] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)preferredContentSize {
    return CGSizeMake(280, 300);
}

- (void)saveTag
{
    NSLog(@"content issued dismissal started");
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"content issued dismissal ended");
    }];
}

#pragma mark - UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TagSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    PBSubscribeTag *tag = [_searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = tag.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedTag = [_searchResults objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForTagName:(NSString *)tagName
{
    if (![tagName isEqualToString:@""]) {
        [_searchResults removeAllObjects];
        for (PBSubscribeTag *tag in [[PBManager sharedManager] tagsList]) {
            if ([tag.name hasPrefix:tagName]) {
                [_searchResults addObject:tag];
            }
        }
    } else {
        _searchResults = [[[PBManager sharedManager] tagsList] mutableCopy];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self updateFilteredContentForTagName:searchString];
    return YES;
}

@end
