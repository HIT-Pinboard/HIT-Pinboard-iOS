//
//  PBIndexObject.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBIndexObject : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSArray *tags;

- (instancetype)initFromDict:(NSDictionary *)dict;

+ (instancetype)objectFromDict:(NSDictionary *)dict;

@end
