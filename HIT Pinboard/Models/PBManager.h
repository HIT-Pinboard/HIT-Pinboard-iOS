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

+ (id)sharedManager;

- (NSArray *)getFeatureList;
- (NSArray *)getSubscribedListFromIndex:(NSUInteger)startIndex
                             Count:(NSUInteger)count;
- (NSArray *)getTagsList;

- (NSArray *)requestFeatureList;
- (NSArray *)requestSubscribedListFromIndex:(NSUInteger)startIndex
                                 Count:(NSUInteger)count;
- (PBObject *)requestSpecificObject:(NSURL *)url;

@end
