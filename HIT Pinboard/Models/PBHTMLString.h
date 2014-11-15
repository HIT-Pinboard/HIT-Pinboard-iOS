//
//  PBHTMLString.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/8/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBHTMLString : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *images;
@property (assign, nonatomic) BOOL shouldDisplayImages;

- (void)setHTMLCSSWithContentsOfFile:(NSString *)path
                            encoding:(NSStringEncoding)enc
                               error:(NSError **)error;
- (NSString *)toHTMLString;

@end
