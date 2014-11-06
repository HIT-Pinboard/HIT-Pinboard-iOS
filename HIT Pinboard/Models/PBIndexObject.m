//
//  PBIndexObject.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBIndexObject.h"

@implementation PBIndexObject

@synthesize title = _title, date = _date, urlString = _urlString, tags = _tags;

- (instancetype)initWithTitle:(NSString *)aTitle
                         Date:(NSString *)dateString
                    URLString:(NSString *)urlString
                         Tags:(NSArray *)aTags
{
    self = [super init];
    if (self) {
        _title = aTitle;
        _date = dateString;
        _urlString = urlString;
        _tags = aTags;
    }
    return self;
}

@end
