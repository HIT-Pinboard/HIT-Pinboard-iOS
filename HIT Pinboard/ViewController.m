//
//  ViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 10/22/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "ViewController.h"
#import "HNObject.h"

@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *newsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.newsArray = [[NSMutableArray alloc] init];
    NSArray *filePathArray = @[[[NSBundle mainBundle] pathForResource:@"someName" ofType:@"json"]];
    for (NSString *filePath in filePathArray) {
        HNObject *obj = [[HNObject alloc] initWithJSON:filePath];
        [self.newsArray addObject:obj];
    }
    
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 75;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"HNObject";
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsArray count];
}

@end
