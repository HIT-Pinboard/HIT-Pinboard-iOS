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

@synthesize featureList = _featureList, subscribedList = _subscribedList, tagsList = _tagsList, cache = _cache, requestedObject = _requestedObject;

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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableDictionary *data = [@{} mutableCopy];
    [data setObject:@0 forKey:@"start_index"];
    [data setObject:@25 forKey:@"count"];
    [data setObject:@[] forKey:@"tags"];
    [[RKObjectManager sharedManager] postObject:nil path:@"/newsList" parameters:@{@"data": data} success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_featureList removeAllObjects];
        [_featureList addObjectsFromArray:result.array];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
                           shouldClear:(BOOL)boolean
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableDictionary *data = [@{} mutableCopy];
    [data setObject:[NSNumber numberWithUnsignedInteger:startIndex] forKey:@"start_index"];
    [data setObject:[NSNumber numberWithUnsignedInteger:count] forKey:@"count"];
    [data setObject:tags forKey:@"tags"];
    [[RKObjectManager sharedManager] postObject:nil path:@"/newsList" parameters:@{@"data": data} success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (boolean) {
            [_subscribedList removeAllObjects];
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, result.array.count)];
        [_subscribedList insertObjects:result.array atIndexes:indexSet];
        if (boolean) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];
        } else {
//            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldUpdate" object:nil]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tableViewShouldUpdate" object:nil userInfo:@{@"updateLocation": indexSet}];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self alertWithError:error];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];
#ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
    }];
}

- (void)requestSpecificObject:(NSString *)urlString
{
    if ([_cache objectExistsForKey:urlString]) {
        _requestedObject = [_cache objectForKey:urlString];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"requestedObjectLoaded" object:nil]];
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[RKObjectManager sharedManager] getObjectsAtPath:urlString parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            _requestedObject = result.array.firstObject;
            [_cache setObject:_requestedObject forKey:urlString];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"requestedObjectLoaded" object:nil]];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"requestObjectFailed" object:nil]];
            _requestedObject = nil;
//            [self alertWithError:error];
#ifdef DEBUG
            NSLog(@"%@", [error localizedDescription]);
#endif
        }];
    }
#ifdef DEBUG
    NSLog(@"requestSpecificObject method invoked!");
#endif
}

- (void)requestTagsList
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/tagsList" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_tagsList removeAllObjects];
        [_tagsList addObjectsFromArray:result.array];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

- (void)clearCache
{
    [_cache removeAllObjects];
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
    /*
     * Time parse issue https://github.com/RestKit/RestKit/issues/1715
     * Before we set up mappings, add a String <--> Date transformer that interprets string dates
     *  lacking timezone info to be in the user's local time zone
     */
    [RKObjectMapping class];    // Message the RKObjectMapping class (+ subclasses) so +initialize is
    [RKEntityMapping class];    //  called to work around RK bug, see GH issue #1631
    NSDateFormatter *localOffsetDateFormatter = [[NSDateFormatter alloc] init];
    [localOffsetDateFormatter setLocale:[NSLocale currentLocale]];
    [localOffsetDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [localOffsetDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:localOffsetDateFormatter atIndex:0];
    
    RKObjectMapping *indexMapping = [RKObjectMapping mappingForClass:[PBIndexObject class]];
    RKObjectMapping *tagMapping = [RKObjectMapping mappingForClass:[PBSubscribeTag class]];
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[PBObject class]];

    [indexMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                        @"date": @"date",
                                                        @"link": @"urlString",
                                                        @"tags": @"tags"
                                                        }];
    [tagMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                     @"value": @"value"
                                                     }];
    
    [tagMapping addRelationshipMappingWithSourceKeyPath:@"children" mapping:tagMapping];
    
    [objectMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
                                                        @"url": @"urlString",
                                                        @"date": @"date",
                                                        @"tags": @"tags",
                                                        @"content": @"content",
                                                        @"imgs": @"imgs"
                                                        }];
    
    RKResponseDescriptor *indexDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:indexMapping method:RKRequestMethodPOST pathPattern:@"/newsList" keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *tagDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tagMapping method:RKRequestMethodGET pathPattern:@"/tagsList" keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor *objectDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodGET pathPattern:@"/:catalogue/:objectID.json" keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kHost]];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    [objectManager addResponseDescriptorsFromArray:@[indexDescriptor, tagDescriptor, objectDescriptor]];
    
    [RKObjectManager setSharedManager:objectManager];
}

#pragma mark -
#pragma mark - Error Alert

- (void)alertWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"遇到了一些问题" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

@end
