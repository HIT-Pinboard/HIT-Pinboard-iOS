//
//  PBObject.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBIndexObject.h"

@interface PBObject : PBIndexObject <NSCoding>

@property (strong, nonatomic, readonly) NSString *subtitle;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *imgs;

- (instancetype)initFromLocalJSON:(NSString *)filePath;
- (instancetype)initFromDict:(NSDictionary *)dict;

@end
