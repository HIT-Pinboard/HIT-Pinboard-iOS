//
//  PBManager.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBManager.h"
#import "PBConstants.h"
#import "PBIndexObject.h"
#import "PBObject.h"

@implementation PBManager

+ (id)sharedManager
{
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

#pragma mark -
#pragma mark - Instance Method
- (BOOL)getFeatureList
{
    // to-do
    return NO;
}
- (BOOL)getSubscribedListFromIndex:(NSUInteger)startIndex
                             Count:(NSUInteger)count
{
    // to-do
    return NO;
}

#pragma mark - 
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // to-do
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // to-do
    return 0;
}

@end
