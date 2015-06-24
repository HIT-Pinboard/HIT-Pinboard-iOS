//
//  PBNetworkRequest.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 3/15/15.
//  Copyright (c) 2015 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface PBNetworkRequest : NSObject

+ (void)postDictionary:(NSDictionary *)dict path:(NSString *)path
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)getObjectsAtPath:(NSString *)path
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
