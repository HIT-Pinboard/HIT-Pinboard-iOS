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

@synthesize title = _title, date = _date, urlString = _urlString, tags = _tags;

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

@end
