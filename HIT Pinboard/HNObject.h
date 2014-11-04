//
//  HNObject.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 10/22/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNObject : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *imgs;

- (instancetype)initWithJSON:(NSString *)filePath;

@end
