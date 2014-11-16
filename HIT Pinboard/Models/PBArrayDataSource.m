//
//  PBFeatureListDataSource.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/9/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBArrayDataSource.h"
#import "PBIndexObject.h"

@interface PBArrayDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation PBArrayDataSource

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger) indexPath.row];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    NSMutableSet *daySet = [NSMutableSet new];
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    for (id item in self.items) {
//        if ([item isKindOfClass:[PBIndexObject class]]) {
//            [daySet addObject:[dateFormatter stringFromDate:((PBIndexObject *)item).date]];
//        }
//    }
//    return daySet.count;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSMutableSet *daySet = [NSMutableSet new];
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    for (id item in self.items) {
//        if ([item isKindOfClass:[PBIndexObject class]]) {
//            [daySet addObject:[dateFormatter stringFromDate:((PBIndexObject *)item).date]];
//        }
//    }
//    return [[daySet allObjects] objectAtIndex:section];
//}

@end
