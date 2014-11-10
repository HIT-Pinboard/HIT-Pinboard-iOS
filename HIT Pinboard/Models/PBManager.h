//
//  PBManager.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PBIndexObject, PBObject;

@interface PBManager : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSArray *featureList;
@property (strong, nonatomic) NSArray *subscribedList;
@property (strong, nonatomic) NSArray *tagsList;

@property (assign, nonatomic) BOOL shouldDisplayImages;
@property (assign, nonatomic) BOOL shouldEnableNotification;

+ (id)sharedManager;

- (void)requestFeatureList;
- (void)requestSubscribedListFromIndex:(NSUInteger)startIndex
                                 Count:(NSUInteger)count
                                  Tags:(NSArray *)tags;
- (void)requestTagsList;

- (PBObject *)requestSpecificObject:(NSURL *)url;

- (void)cacheAllObjects;
- (void)saveSettings;

@end
