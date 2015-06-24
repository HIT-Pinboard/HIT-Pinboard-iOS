//
//  PBManager.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <CacheKit/CacheKit.h>
#import <UIKit/UIKit.h>
#import "PBNetworkRequest.h"
#import "PBManager.h"
#import "PBConstants.h"
#import "PBIndexObject.h"
#import "PBObject.h"
#import "PBSubscribeTag.h"

@interface PBManager ()

@property (strong, nonatomic) CKSQLiteCache *cache;

@end

@implementation PBManager

- (instancetype)init
{
    self = [super init];
    if (self) {
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
        _subscribedTags = [NSMutableSet set];
        if ([defaults objectForKey:kSettingsDisplayImages]) {
            _shouldDisplayImages = [(NSNumber *)[defaults objectForKey:kSettingsDisplayImages] boolValue];
        }
        if ([defaults objectForKey:kSettingsNotifications]) {
            _shouldEnableNotification = [(NSNumber *)[defaults objectForKey:kSettingsNotifications] boolValue];
        }
        if ([defaults objectForKey:kSettingsSubscribed]) {
            [_subscribedTags addObjectsFromArray:[defaults objectForKey:kSettingsSubscribed]];
        }
        // improve this
//        [self requestTagsList];
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
    [data setObject:@[@"0"] forKey:@"tags"];
    [PBNetworkRequest postDictionary:@{@"data": data} path:@"/newsList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        
        [_featureList removeAllObjects];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        __block BOOL findDate;
        for (NSDictionary *dict in (NSArray *)(responseObject[@"response"])) {
            PBIndexObject *obj = [PBIndexObject objectFromDict:dict];
            findDate = NO;
            [_featureList enumerateObjectsUsingBlock:^(NSMutableArray *eachDay, NSUInteger index, BOOL *stop){
                if ([[dateFormatter stringFromDate:obj.date] isEqualToString:[dateFormatter stringFromDate:((PBIndexObject *)eachDay.firstObject).date]]) {
                    [eachDay addObject:obj];
                    findDate = YES;
                    *stop = YES;
                }
            }];
            if (findDate == NO) {
                NSMutableArray *newDay = [@[] mutableCopy];
                [newDay addObject:obj];
                [_featureList addObject:newDay];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
                           shouldClear:(BOOL)boolean
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableDictionary *data = [@{} mutableCopy];
    [data setObject:[NSNumber numberWithUnsignedInteger:startIndex] forKey:@"start_index"];
    [data setObject:[NSNumber numberWithUnsignedInteger:count] forKey:@"count"];
    [data setObject:[_subscribedTags allObjects] forKey:@"tags"];
    [PBNetworkRequest postDictionary:@{@"data": data} path:@"/newsList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (boolean) {
            [_subscribedList removeAllObjects];
        }
        
        NSUInteger beginLoc = _subscribedList.count;
        
        NSMutableArray *indexPaths = [@[] mutableCopy];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        __block BOOL findDate;
        for (NSDictionary *dict in (NSArray *)(responseObject[@"response"])) {
            PBIndexObject *obj = [PBIndexObject objectFromDict:dict];
            findDate = NO;
            [_subscribedList enumerateObjectsUsingBlock:^(NSMutableArray *eachDay, NSUInteger index, BOOL *stop){
                if ([[dateFormatter stringFromDate:obj.date] isEqualToString:[dateFormatter stringFromDate:((PBIndexObject *)eachDay.firstObject).date]]) {
                    NSUInteger row = eachDay.count;
                    [eachDay addObject:obj];
                    // record index path
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:index];
                    [indexPaths addObject:indexPath];
                    findDate = YES;
                    *stop = YES;
                }
            }];
            if (findDate == NO) {
                NSUInteger section = _subscribedList.count;
                NSMutableArray *newDay = [@[] mutableCopy];
                [newDay addObject:obj];
                [_subscribedList addObject:newDay];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                [indexPaths addObject:indexPath];
            }
        }
        
        NSUInteger endLoc = _subscribedList.count;

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginLoc, endLoc - beginLoc)];
        
        if (boolean) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tableViewShouldReload" object:nil]];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tableViewShouldUpdate" object:nil userInfo:@{@"indexPaths": indexPaths, @"indexSet": indexSet}];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        [PBNetworkRequest getObjectsAtPath:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            _requestedObject = [PBObject objectFromDict:responseObject[@"response"]];
            [_cache setObject:_requestedObject forKey:urlString];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"requestedObjectLoaded" object:nil]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"requestObjectFailed" object:nil]];
            _requestedObject = nil;
            [self alertWithError:error];
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
    [PBNetworkRequest getObjectsAtPath:@"/tagsList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_tagsList removeAllObjects];
        
        for (NSDictionary *dict in responseObject[@"response"]) {
            PBSubscribeTag *tag = [PBSubscribeTag tagFromDict:dict];
            [_tagsList addObject:tag];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self alertWithError:error];
#ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
    }];
}

- (void)updatePushSetting
{
    BOOL shouldUpdate = NO;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        if (_deviceToken && [[[UIApplication sharedApplication] currentUserNotificationSettings] types] == (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge))
            shouldUpdate = YES;
    } else {
        if (_deviceToken && [[UIApplication sharedApplication] enabledRemoteNotificationTypes] == (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge))
            shouldUpdate = YES;
    }
    if (shouldUpdate) {
        NSMutableDictionary *data = [@{} mutableCopy];
        [data setObject:_deviceToken forKey:@"token"];
        if (_shouldEnableNotification) {
            data[@"action"] = @"register";
        } else {
            data[@"action"] = @"remove";
        }
        [data setObject:[_subscribedTags allObjects] forKey:@"tags"];
        
        [PBNetworkRequest postDictionary:@{@"data": data} path:@"/push" success:nil failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertWithError:error];
        }];
    }
}

#pragma mark -
- (void)addSubscribedTag:(NSString *)value
{
    [_subscribedTags addObject:value];
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
    [_featureList removeAllObjects];
    [_subscribedList removeAllObjects];
    [_tagsList removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userActionSuccess" object:nil userInfo:@{@"success": NSLocalizedString(@"Cache cleared", @"Cache cleared")}];
    // should improve this
    [self requestTagsList];
}

- (void)saveSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_shouldDisplayImages] forKey:kSettingsDisplayImages];
    [defaults setObject:[NSNumber numberWithBool:_shouldEnableNotification] forKey:kSettingsNotifications];
    [defaults setObject:[_subscribedTags allObjects] forKey:kSettingsSubscribed];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userActionSuccess" object:nil userInfo:@{@"success": NSLocalizedString(@"Settings saved", @"Settings saved")}];
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
//    [RKObjectMapping class];    // Message the RKObjectMapping class (+ subclasses) so +initialize is
//    [RKEntityMapping class];    //  called to work around RK bug, see GH issue #1631
//    NSDateFormatter *localOffsetDateFormatter = [[NSDateFormatter alloc] init];
//    [localOffsetDateFormatter setLocale:[NSLocale currentLocale]];
//    [localOffsetDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [localOffsetDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:localOffsetDateFormatter atIndex:0];
//    
//    RKObjectMapping *indexMapping = [RKObjectMapping mappingForClass:[PBIndexObject class]];
//    RKObjectMapping *tagMapping = [RKObjectMapping mappingForClass:[PBSubscribeTag class]];
//    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[PBObject class]];
//
//    [indexMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
//                                                        @"date": @"date",
//                                                        @"link": @"urlString",
//                                                        @"tags": @"tags"
//                                                        }];
//    [tagMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
//                                                     @"value": @"value"
//                                                     }];
//    
//    [tagMapping addRelationshipMappingWithSourceKeyPath:@"children" mapping:tagMapping];
//    
//    [objectMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
//                                                        @"link": @"urlString",
//                                                        @"date": @"date",
//                                                        @"tags": @"tags",
//                                                        @"content": @"content",
//                                                        @"imgs": @"imgs"
//                                                        }];
//    
//    RKResponseDescriptor *indexDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:indexMapping method:RKRequestMethodPOST pathPattern:@"/newsList" keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    RKResponseDescriptor *tagDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:tagMapping method:RKRequestMethodGET pathPattern:@"/tagsList" keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    RKResponseDescriptor *objectDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodGET pathPattern:@"/:catalogue/:objectID.json" keyPath:@"response" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kHost]];
//    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
//    
//    [objectManager addResponseDescriptorsFromArray:@[indexDescriptor, tagDescriptor, objectDescriptor]];
//    
//    [RKObjectManager setSharedManager:objectManager];
}

#pragma mark -
#pragma mark - Error Alert

- (void)alertWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestFailedWithError" object:nil userInfo:@{@"error": [error localizedDescription]}];
}

@end
