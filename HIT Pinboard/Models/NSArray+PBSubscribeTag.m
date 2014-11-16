//
//  NSArray+PBSubscribeTag.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/11/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "NSArray+PBSubscribeTag.h"
#import "PBSubscribeTag.h"

@implementation NSArray (PBSubscribeTag)

- (NSString *)tagNameForValue:(NSString *)value
{
    NSMutableArray *result = [@[] mutableCopy];
    [self tagNameForValue:value Rec:result];
    return result.count>0?result.firstObject:@"Unknown";
}

- (void)tagNameForValue:(NSString *)value Rec:(NSMutableArray *)array
{
    for (PBSubscribeTag *tag in self) {
        if ([tag.value isEqualToString:value])
            [array addObject:tag.name];
        if (tag.children != nil && tag.children.count > 0)
            [tag.children tagNameForValue:value Rec:array];
    }
}

- (UIImage *)tagImageForValue:(NSString *)value
{
    NSString *tagName = [self tagNameForValue:value];
    NSString *prefix = [tagName componentsSeparatedByString:@" "].firstObject;
    NSLog(@"%@", prefix);
    return [UIImage imageNamed:@"default_icon"];
}
@end
