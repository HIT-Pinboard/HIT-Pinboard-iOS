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
#import "PBSubscribeTag.h"

@interface PBManager ()

@property (strong, nonatomic) CKSQLiteCache *cache;

@end

@implementation PBManager

@synthesize featureList = _featureList, subscribedList = _subscribedList, tagsList = _tagsList, cache = _cache;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureRESTKit];
        if (!_cache) {
            _cache = [[CKSQLiteCache alloc] initWithName:@"PBCache"];
            if ([_cache objectExistsForKey:kCachingFeatureList])
                _featureList = [[_cache objectForKey:kCachingFeatureList] mutableCopy];
            else
                _featureList = [@[] mutableCopy];
            
            if ([_cache objectExistsForKey:kCachingSubscribeList])
                _subscribedList = [[_cache objectForKey:kCachingSubscribeList] mutableCopy];
            else
                _subscribedList = [@[] mutableCopy];
            
            if ([_cache objectExistsForKey:kCachingTagsList])
                _tagsList = [[_cache objectForKey:kCachingTagsList] mutableCopy];
            else
                _tagsList = [@[] mutableCopy];
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
        // improve this
        [self requestTagsList];
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

- (void)requestFeatureList
{
    [[RKObjectManager sharedManager] postObject:nil path:@"/newsList" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [_featureList removeAllObjects];
        [_featureList addObjectsFromArray:result.array];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self alertWithError:error];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];
#ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
    }];
}

- (void)requestSubscribedListFromIndex:(NSUInteger)startIndex
                                 Count:(NSUInteger)count
                                  Tags:(NSArray *)tags
{
    NSMutableDictionary *data = [@{} mutableCopy];
    [data setObject:[NSNumber numberWithUnsignedInteger:startIndex] forKey:@"start_index"];
    [data setObject:[NSNumber numberWithUnsignedInteger:count] forKey:@"count"];
    [data setObject:tags forKey:@"tags"];
    [[RKObjectManager sharedManager] postObject:nil path:@"/newsList" parameters:data success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [_subscribedList insertObjects:result.array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, count)]];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self alertWithError:error];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];
#ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
    }];
}

- (PBObject *)requestSpecificObject:(NSURL *)url
{
    return nil;
}

- (void)requestTagsList
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/tagsList" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [_tagsList removeAllObjects];
        [_tagsList addObjectsFromArray:result.array];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self alertWithError:error];
#ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
    }];
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
    RKObjectMapping *indexMapping = [RKObjectMapping mappingForClass:[PBIndexObject class]];
    RKObjectMapping *tagMapping = [RKObjectMapping mappingForClass:[PBSubscribeTag class]];
    [indexMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                        @"date": @"date",
                                                        @"link": @"urlString",
                                                        @"tags": @"tags"
                                                        }];
    [tagMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                     @"value": @"value",
                                                     }];
    
    [tagMapping addRelationshipMappingWithSourceKeyPath:@"children" mapping:tagMapping];
    
    RKResponseDescriptor *indexDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:indexMapping method:RKRequestMethodPOST pathPattern:@"/newsList" keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *tagDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tagMapping method:RKRequestMethodGET pathPattern:@"/tagsList" keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kHost]];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    [objectManager addResponseDescriptorsFromArray:@[indexDescriptor, tagDescriptor]];
    
    [RKObjectManager setSharedManager:objectManager];
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

#pragma mark -
#pragma mark - Error Alert

- (void)alertWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"遇到了一些问题" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

@end
