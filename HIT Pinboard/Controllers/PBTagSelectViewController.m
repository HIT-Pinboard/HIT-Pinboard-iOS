//
//  PBTagsSelectViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/16/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <RWBlurPopover/RWBlurPopover.h>
#import "PBTagSelectViewController.h"
#import "PBTagCollectionViewCell.h"
#import "PBManager.h"
#import "PBSubscribeTag.h"
#import "NSArray+PBSubscribeTag.h"
#import "PBTagSearchViewController.h"

static NSString * const cellIdentifier = @"PBTagCollectionCell";

@interface PBTagSelectViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *selectedTags;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation PBTagSelectViewController

@synthesize collectionView = _collectionView, selectedTags = _selectedTags, selectedIndexPath = _selectedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedTags = [[[PBManager sharedManager] subscribedTags] allObjects];
    [_collectionView registerNib:[PBTagCollectionViewCell nib] forCellWithReuseIdentifier:cellIdentifier];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PBTagAddCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedReload) name:@"collectionViewShouldReload" object:nil];
#ifdef DEBUG
    NSLog(@"collectionViewShouldReload notification registered");
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"collectionViewShouldReload" object:nil];
#ifdef DEBUG
    NSLog(@"collectionViewShouldReload notification removed");
#endif
}

#pragma mark - 
#pragma mark - Notification

- (void)receivedReload
{
    _selectedTags = [[[PBManager sharedManager] subscribedTags] allObjects];
    [_collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _selectedTags.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _selectedTags.count) {
        PBTagCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        NSString *value = [_selectedTags objectAtIndex:indexPath.row];
        NSString *name = [[[PBManager sharedManager] tagsList] tagNameForValue:value];
        cell.tagTitleLabel.text = [name componentsSeparatedByString:@" "].firstObject;
        cell.tagSubtitleLabel.text = [name componentsSeparatedByString:@" "].lastObject;
        cell.tagImageView.image = [[[PBManager sharedManager] tagsList] tagImageForValue:value];
        cell.tagImageView.alpha = 0.1f;
        return cell;
    } else {
        UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"PBTagAddCell" forIndexPath:indexPath];
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 120.0f, 70.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 70.0f)];
        imageView.image = [UIImage imageNamed:@"add"];
        [cell addSubview:imageView];
        return cell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0f, 25.0f, 10.0f, 25.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _selectedTags.count) {
        _selectedIndexPath = indexPath;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确认删除此订阅" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
    } else {
        [self showTagSearchPopover];
    }
}

#pragma mark -
#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        PBSubscribeTag *tag = [_selectedTags objectAtIndex:_selectedIndexPath.row];
        [[[PBManager sharedManager] subscribedTags] removeObject:tag];
        _selectedTags = [[[PBManager sharedManager] subscribedTags] allObjects];
        [[PBManager sharedManager] saveSettings];
        [_collectionView deleteItemsAtIndexPaths:@[_selectedIndexPath]];
    }
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTagSearchPopover
{
    PBTagSearchViewController *vc = [[PBTagSearchViewController alloc] initWithNibName:[PBTagSearchViewController nibName] bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [RWBlurPopover showContentViewController:nav insideViewController:self];
}
@end
