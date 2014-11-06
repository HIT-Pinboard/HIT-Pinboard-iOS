//
//  PBIndexObject.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBIndexObject : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSArray *tags;

- (instancetype)initWithTitle:(NSString *)aTitle
                         Date:(NSString *)dateString
                    URLString:(NSString *)urlString
                         Tags:(NSArray *)aTags;

@end
