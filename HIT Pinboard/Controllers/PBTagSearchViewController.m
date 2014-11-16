//
//  PBTagSearchViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/16/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBTagSearchViewController.h"
#import "PBManager.h"
#import "PBSubscribeTag.h"

@interface PBTagSearchViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *describeTextLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong, nonatomic) NSMutableArray *searchResults;

- (IBAction)saveButtonClicked:(id)sender;

@end

@implementation PBTagSearchViewController

@synthesize searchResults = _searchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchResults = [[PBManager sharedManager] tagsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - SearchDisplay Delegate



@end
