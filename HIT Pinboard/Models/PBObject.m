//
//  PBObject.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBObject.h"
#import "PBConstants.h"
#import "PBManager.h"
#import "NSArray+PBSubscribeTag.h"

@interface PBObject ()

@property (strong, nonatomic, readwrite) NSString *subtitle;

@end

@implementation PBObject

/*
 urlString in PBIndexObject indicates URL to JSON file
 urlString in PBObject indicated URL to original webpage
 */

- (instancetype)initFromDict:(NSDictionary *)dict
{
    self = [super initFromDict:dict];
    if (self) {
        _content = [dict objectForKey:@"content"];
        _imgs = [dict objectForKey:@"imgs"];
    }
    return self;
}

+ (instancetype)objectFromDict:(NSDictionary *)dict
{
    return [[PBObject alloc] initFromDict:dict];
}

- (NSString *)subtitle
{
    NSMutableArray *strArr = [@[] mutableCopy];
    for (NSString *tagValue in self.tags) {
        [strArr addObject:[[[PBManager sharedManager] tagsList] tagNameForValue:tagValue]];
    }
    NSString *tagDescription = [[strArr valueForKey:@"description"] componentsJoinedByString:@" "];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [NSString stringWithFormat:NSLocalizedString(@"Date:%@ Tags:%@", @"Date:%@ Tags:%@"), [dateFormatter stringFromDate:self.date], tagDescription];
}

#pragma mark -
#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_subtitle forKey:kCodingSubtitleKey];
    [aCoder encodeObject:_content forKey:kCodingContentKey];
    [aCoder encodeObject:_imgs forKey:kCodingImagesKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _subtitle = [aDecoder decodeObjectForKey:kCodingSubtitleKey];
        _content = [aDecoder decodeObjectForKey:kCodingContentKey];
        _imgs = [aDecoder decodeObjectForKey:kCodingImagesKey];
    }
    return self;
}

#pragma mark -
#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    PBObject *newObject = [[PBObject alloc] init];
    newObject.title = [self.title copyWithZone:zone];
    newObject.date = [self.date copyWithZone:zone];
    newObject.urlString = [self.urlString copyWithZone:zone];
    newObject.tags = [self.tags copyWithZone:zone];
    newObject.content = [_content copyWithZone:zone];
    newObject.imgs = [_imgs copyWithZone:zone];
    return newObject;
}

@end
