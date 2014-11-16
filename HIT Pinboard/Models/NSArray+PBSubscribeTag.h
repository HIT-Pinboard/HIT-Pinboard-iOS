//
//  NSArray+PBSubscribeTag.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/11/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (PBSubscribeTag)

- (NSString *)tagNameForValue:(NSString *)value;
- (UIImage *)tagImageForValue:(NSString *)value;

@end
