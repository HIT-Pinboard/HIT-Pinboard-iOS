//
//  PBManager.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <CacheKit/CacheKit.h>
#import <RestKit/RestKit.h>

#import "PBManager.h"
#import "PBConstants.h"
#import "PBIndexObject.h"
#import "PBObject.h"

@interface PBManager ()

@property (strong, nonatomic) CKSQLiteCache *cache;
@property (strong, nonatomic) RKObjectMapping *indexObjectMapping;
@property (strong, nonatomic) RKObjectMapping *objectMapping;

@end

@implementation PBManager

@synthesize featureList = _featureList, subscribedList = _subscribedList, tagsList = _tagsList, cache = _cache, indexObjectMapping = _indexMapping, objectMapping = _objectMapping;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureRESTKit];
        if (!_cache) {
            _cache = [[CKSQLiteCache alloc] initWithName:@"PBCache"];
            if ([_cache objectExistsForKey:kCachingFeatureList])
                _featureList = [_cache objectForKey:kCachingFeatureList];
            if ([_cache objectExistsForKey:kCachingSubscribeList])
                _subscribedList = [_cache objectForKey:kCachingSubscribeList];
            if ([_cache objectExistsForKey:kCachingTagsList]) {
                _tagsList = [_cache objectForKey:kCachingTagsList];
            }
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _shouldEnableNotification = YES;
        _shouldDisplayImages = YES;
        if ([defaults objectForKey:kSettingDisplayImages]) {
            _shouldDisplayImages = [(NSNumber *)[defaults objectForKey:kSettingDisplayImages] boolValue];
        }
        if ([defaults objectForKey:kSettingNotifications]) {
            _shouldEnableNotification = [(NSNumber *)[defaults objectForKey:kSettingNotifications] boolValue];
        }
    }
    return self;
}

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
#pragma mark - Request Remote Objects

- (NSArray *)requestFeatureList
{
    return nil;
}

- (NSArray *)requestSubscribedListFromIndex:(NSUInteger)startIndex
                                      Count:(NSUInteger)count
{
    return nil;
}

- (PBObject *)requestSpecificObject:(NSURL *)url
{
    return nil;
}

- (NSArray *)requestTagsList
{
    return nil;
}

#pragma mark -
#pragma mark - Cache

- (void)cacheAllObjects
{
    [_cache setObject:_featureList forKey:kCachingFeatureList];
    [_cache setObject:_subscribedList forKey:kCachingSubscribeList];
    [_cache setObject:_tagsList forKey:kCachingTagsList];
}

- (void)saveSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_shouldDisplayImages] forKey:kSettingDisplayImages];
    [defaults setObject:[NSNumber numberWithBool:_shouldEnableNotification] forKey:kSettingNotifications];
}

#pragma mark -
#pragma mark - Configure Method

- (void)configureRESTKit
{
    _indexMapping = [RKObjectMapping mappingForClass:[PBIndexObject class]];
    _objectMapping = [RKObjectMapping mappingForClass:[PBObject class]];
    [_indexMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                        @"date": @"date",
                                                        @"link": @"urlString",
                                                        @"tags": @"tags"
                                                        }];
    [_objectMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                        @"date": @"date",
                                                        @"link": @"urlString",
                                                        @"tags": @"tags",
                                                        @"content": @"content",
                                                        @"imgs": @"imgs"
                                                        }];
    
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
