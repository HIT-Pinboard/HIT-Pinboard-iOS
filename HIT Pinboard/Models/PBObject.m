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

@synthesize title = _title, date = _date, urlString = _urlString, tags = _tags,
            subtitle = _subtitle, content = _content, imgs = _imgs;

/*
 urlString in PBIndexObject indicates URL to JSON file
 urlString in PBObject indicated URL to original webpage
 */

- (instancetype)initFromLocalJSON:(NSString *)filePath
{
    self = [super init];
    if (self) {
        NSFileManager *mgr = [NSFileManager defaultManager];
        if ([mgr fileExistsAtPath:filePath]) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions error:nil];
            _title = [json objectForKey:@"title"];
            _date = [json objectForKey:@"date"];
            _urlString = [json objectForKey:@"link"];
            _tags = [json objectForKey:@"tags"];
            _content = [json objectForKey:@"content"];
            _imgs = [json objectForKey:@"imgs"];
        }
    }
    return self;
}

- (instancetype)initFromDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _title = [dict objectForKey:@"title"];
        _date = [dict objectForKey:@"date"];
        _urlString = [dict objectForKey:@"link"];
        _tags = [dict objectForKey:@"tags"];
        _content = [dict objectForKey:@"content"];
        _imgs = [dict objectForKey:@"imgs"];
    }
    return self;
}

- (NSString *)subtitle
{
    NSMutableArray *strArr = [@[] mutableCopy];
    for (NSString *tagValue in _tags) {
        [strArr addObject:[[[PBManager sharedManager] tagsList] tagNameForValue:tagValue]];
    }
    NSString *tagDescription = [[strArr valueForKey:@"description"] componentsJoinedByString:@" "];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [NSString stringWithFormat:@"日期:%@ 标签:%@", [dateFormatter stringFromDate:_date], tagDescription];
}

#pragma mark -
#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:kCodingTitleKey];
    [aCoder encodeObject:_date forKey:kCodingDateKey];
    [aCoder encodeObject:_urlString forKey:kCodingURLStringKey];
    [aCoder encodeObject:_tags forKey:kCodingTagsKey];
    [aCoder encodeObject:_subtitle forKey:kCodingSubtitleKey];
    [aCoder encodeObject:_content forKey:kCodingContentKey];
    [aCoder encodeObject:_imgs forKey:kCodingImagesKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:kCodingTitleKey];
        _date = [aDecoder decodeObjectForKey:kCodingDateKey];
        _urlString = [aDecoder decodeObjectForKey:kCodingURLStringKey];
        _tags = [aDecoder decodeObjectForKey:kCodingTagsKey];
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
    newObject.title = [_title copyWithZone:zone];
    newObject.date = [_date copyWithZone:zone];
    newObject.urlString = [_urlString copyWithZone:zone];
    newObject.tags = [_tags copyWithZone:zone];
    newObject.content = [_content copyWithZone:zone];
    newObject.imgs = [_imgs copyWithZone:zone];
    return newObject;
}

@end
