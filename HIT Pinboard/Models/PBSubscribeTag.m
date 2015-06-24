//
//  PBSubscribeTag.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/7/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBSubscribeTag.h"
#import "PBConstants.h"

@implementation PBSubscribeTag

- (NSDictionary *)objectToDict
{
    NSMutableDictionary *dict = [@{} mutableCopy];
    [dict setObject:_name forKey:@"name"];
    [dict setObject:_value forKey:@"value"];
    NSMutableArray *arr = [@[] mutableCopy];
    for (PBSubscribeTag *childObj in _children) {
        [arr addObject:[childObj objectToDict]];
    }
    [dict setObject:[NSArray arrayWithArray:arr] forKey:@"children"];
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (instancetype)initFromDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _name = [dict objectForKey:@"name"];
        _value = [dict objectForKey:@"value"];
        NSArray *children = [dict objectForKey:@"children"];
        if (children != nil && children.count > 0) {
            NSMutableArray *arr= [@[] mutableCopy];
            for (NSDictionary *childDict in children) {
                [arr addObject:[[PBSubscribeTag alloc] initFromDict:childDict]];
            }
            _children = [NSArray arrayWithArray:arr];
        }
    }
    return self;
}

+ (instancetype)tagFromDict:(NSDictionary *)dict
{
    return [[PBSubscribeTag alloc] initFromDict:dict];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [[PBSubscribeTag alloc] initFromDict:[aDecoder decodeObjectForKey:kCodingTagsKey]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self objectToDict] forKey:kCodingTagsKey];
}

@end
