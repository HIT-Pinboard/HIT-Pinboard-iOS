//
//  PBSubscribeTag.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/7/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBSubscribeTag : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSArray *children;

- (NSDictionary *)objectToDict;
- (instancetype)initFromDict:(NSDictionary *)dict;

@end
