//
//  HNObject.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 10/22/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "HNObject.h"

@implementation HNObject

@synthesize title = _title, urlString = _urlString, content = _content, date = _date,
            department = _department, type = _type, imgs = _imgs;

- (instancetype)initWithJSON:(NSString *)filePath {
    self = [super init];
    if (self) {
        NSFileManager *mgr = [NSFileManager defaultManager];
        if ([mgr fileExistsAtPath:filePath]) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            _title = [json objectForKey:@"title"];
            _content = [json objectForKey:@"content"];
            _type = @"公告通知";
            _department = @"机电学院";
            _imgs = [json objectForKey:@"imgs"];
        }
    }
    return self;
}

@end
