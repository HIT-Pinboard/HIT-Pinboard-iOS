//
//  PBManager.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBIndexObject, PBObject;

@interface PBManager : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *featureList;
@property (strong, nonatomic, readonly) NSMutableArray *subscribedList;
@property (strong, nonatomic, readonly) NSMutableArray *tagsList;
@property (strong, nonatomic, readonly) PBObject *requestedObject;
@property (strong, nonatomic, readonly) NSMutableSet *subscribedTags;

@property (strong, nonatomic) NSString *deviceToken;

@property (assign, nonatomic) BOOL shouldDisplayImages;
@property (assign, nonatomic) BOOL shouldEnableNotification;

+ (id)sharedManager;

- (void)requestFeatureList;
- (void)requestSubscribedListFromIndex:(NSUInteger)startIndex
                                 Count:(NSUInteger)count
                           shouldClear:(BOOL)boolean;
- (void)requestTagsList;
- (void)requestSpecificObject:(NSString *)urlString;

- (void)updatePushSetting;

- (void)addSubscribedTag:(NSString *)value;

- (void)cacheAllObjects;
- (void)clearCache;
- (void)saveSettings;

@end
