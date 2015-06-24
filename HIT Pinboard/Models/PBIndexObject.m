//
//  PBIndexObject.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBIndexObject.h"
#import "PBConstants.h"

@implementation PBIndexObject

- (instancetype)initWithTitle:(NSString *)aTitle
                         Date:(NSDate *)date
                    URLString:(NSString *)urlString
                         Tags:(NSArray *)aTags
{
    self = [super init];
    if (self) {
        _title = aTitle;
        _date = date;
        _urlString = urlString;
        _tags = aTags;
    }
    return self;
}

#pragma mark -
#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:kCodingTitleKey];
    [aCoder encodeObject:_date forKey:kCodingDateKey];
    [aCoder encodeObject:_urlString forKey:kCodingURLStringKey];
    [aCoder encodeObject:_tags forKey:kCodingTagsKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:kCodingTitleKey];
        _date = [aDecoder decodeObjectForKey:kCodingDateKey];
        _urlString = [aDecoder decodeObjectForKey:kCodingURLStringKey];
        _tags = [aDecoder decodeObjectForKey:kCodingTagsKey];
    }
    return self;
}

- (instancetype)initFromDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        NSDateFormatter *ymdFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *ymdhmsFormatter = [[NSDateFormatter alloc] init];
        
        ymdFormatter.locale = [NSLocale currentLocale];
        ymdhmsFormatter.locale = [NSLocale currentLocale];
        
        ymdFormatter.dateFormat = @"yyyy-MM-dd";
        ymdhmsFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        _title = [dict objectForKey:@"title"];
        _date = [ymdFormatter dateFromString:[dict objectForKey:@"date"]] ? : [ymdhmsFormatter dateFromString:[dict objectForKey:@"date"]];
        _urlString = [dict objectForKey:@"link"];
        _tags = [dict objectForKey:@"tags"];
    }
    return self;
}

+ (instancetype)objectFromDict:(NSDictionary *)dict
{
    return [[PBIndexObject alloc] initFromDict:dict];
}

@end
