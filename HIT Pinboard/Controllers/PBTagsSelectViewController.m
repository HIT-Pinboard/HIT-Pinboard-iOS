//
//  PBTagsSelectViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/16/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBTagsSelectViewController.h"
#import "PBTagCollectionViewCell.h"
#import "PBManager.h"
#import "PBSubscribeTag.h"
#import "NSArray+PBSubscribeTag.h"

static NSString * const cellIdentifier = @"PBTagCollectionCell";

@interface PBTagsSelectViewController () <UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *selectedTags;

@end

@implementation PBTagsSelectViewController

@synthesize collectionView = _collectionView, selectedTags = _selectedTags;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 44.0f)];
    [self.view addSubview:naviBar];
    _selectedTags = [@[@"1.1", @"3"] mutableCopy];
    [_collectionView registerNib:[PBTagCollectionViewCell nib] forCellWithReuseIdentifier:cellIdentifier];
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
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
        cell.tagSubtitleLabel.text = [name componentsSeparatedByString:@""].lastObject;
        cell.tagImageView.image = [[[PBManager sharedManager] tagsList] tagImageForValue:value];
        // invoked but not displaying
        cell.backgroundColor = [UIColor redColor];
        return cell;
    } else {
        UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.frame = CGRectMake(0.0f, 0.0f, 120.0f, 70.0f);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 70.0f)];
        imageView.image = [UIImage imageNamed:@"safari"];
        [cell addSubview:imageView];
        return cell;
    }
}

@end
