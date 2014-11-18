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

@interface PBTagSearchViewController () <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) PBSubscribeTag *selectedTag;

@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

- (IBAction)segmentChanged:(UISegmentedControl *)sender;

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
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveTag)];
    self.saveButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    self.title = @"添加订阅";
    self.describeLabel.text = @"请选择订阅内容";
    UITapGestureRecognizer *gestureRecongizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:gestureRecongizer];
    _searchResults = [[[PBManager sharedManager] tagsList] mutableCopy];
    
    [self.segmentControl removeAllSegments];
    self.segmentControl.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)preferredContentSize {
    return CGSizeMake(280, 300);
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    /* hack this way
     *
     */
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIView *view = sender.view;
        CGPoint loc = [sender locationInView:view];
        UIView *subview = [view hitTest:loc withEvent:nil];
        if ([subview isDescendantOfView:self.searchDisplayController.searchResultsTableView]) {
            CGPoint indexLoc = [sender locationInView:self.searchDisplayController.searchResultsTableView];
            NSIndexPath *touchIndex = [self.searchDisplayController.searchResultsTableView indexPathForRowAtPoint:indexLoc];
            if (touchIndex != NULL) {
                [self tableView:self.searchDisplayController.searchResultsTableView didSelectRowAtIndexPath:touchIndex];
            }
        }
    }
}

- (void)saveTag
{
    NSInteger seg = self.segmentControl.selectedSegmentIndex;
    NSString *value = _selectedTag.value;
    if (seg > 0) {
        PBSubscribeTag *tag = [_selectedTag.children objectAtIndex:seg-1];
        value = tag.value;
    }
    [[PBManager sharedManager] addSubscribedTag:value];
    [[PBManager sharedManager] saveSettings];
#ifdef DEBUG
    NSLog(@"content issued dismissal started");
#endif
    [self dismissViewControllerAnimated:YES completion:^{
#ifdef DEBUG
        NSLog(@"content issued dismissal ended");
#endif
        [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionViewShouldReload" object:nil];
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
    [self.searchDisplayController setActive:NO animated:YES];

    [self.segmentControl insertSegmentWithTitle:[NSString stringWithFormat:@"%@ - 所有", _selectedTag.name] atIndex:0 animated:YES];
    [_selectedTag.children enumerateObjectsUsingBlock:^(PBSubscribeTag *child, NSUInteger idx, BOOL *stop){
        [self.segmentControl insertSegmentWithTitle:child.name atIndex:idx+1 animated:YES];
    }];
    self.segmentControl.selectedSegmentIndex = 0;
    self.segmentControl.enabled = YES;
    self.saveButton.enabled = YES;
    self.describeLabel.text = [NSString stringWithFormat:@"您选择订阅%@的所有新闻，我们将提供给您关于%@的所有信息。", _selectedTag.name, _selectedTag.name];
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
    self.describeLabel.text = @"请选择订阅内容";
    [self updateFilteredContentForTagName:searchString];
    return YES;
}

#pragma mark - Action

- (IBAction)segmentChanged:(UISegmentedControl *)sender
{
    NSInteger seg = sender.selectedSegmentIndex;
    NSString *tagName = _selectedTag.name;
    NSString *tagDetail = @"所有信息";
    if (seg > 0) {
        PBSubscribeTag *tag = [_selectedTag.children objectAtIndex:(seg-1)];
        tagDetail = [tag.name componentsSeparatedByString:@" "].lastObject;
    }
    self.describeLabel.text = [NSString stringWithFormat:@"您选择订阅%@的所有新闻，我们将提供给您关于%@的%@。", tagName, tagName, tagDetail];
}
@end
