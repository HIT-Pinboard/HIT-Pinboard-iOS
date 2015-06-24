//
//  PBNetworkRequest.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 3/15/15.
//  Copyright (c) 2015 Yifei Zhou. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "PBNetworkRequest.h"
#import "PBConstants.h"

@implementation PBNetworkRequest

static NSString *const baseURLString = kHost;

+ (void)postDictionary:(NSDictionary *)dict path:(NSString *)path
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlString = [baseURLString stringByAppendingPathComponent:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:urlString parameters:dict success:success failure:failure];
}

+ (void)getObjectsAtPath:(NSString *)path
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlString = [baseURLString stringByAppendingPathComponent:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:success failure:failure];
}

@end
