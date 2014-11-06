//
//  PBObject.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBObject.h"

@interface PBObject ()

@property (strong, nonatomic, readwrite) NSString *subtitle;

@end

@implementation PBObject

@synthesize title = _title, date = _date, urlString = _urlString, tags = _tags,
            subtitle = _subtitle, content = _content, imgs = _imgs;


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
            
            _subtitle = [NSString stringWithFormat:@"日期:%@ 标签:%@", _date, [[_imgs valueForKey:@"description"] componentsJoinedByString:@" "]];
        }
    }
    return self;
}

- (instancetype)initFromRemoteJSON:(NSString *)urlString
{
    // to-do
    return nil;
}


@end
