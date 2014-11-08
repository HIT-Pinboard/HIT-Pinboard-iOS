//
//  URLActivity.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/8/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "URLActivity.h"

@implementation URLActivity

- (NSString *)activityTitle
{
    return @"Open in Safari";
}

- (NSString *)activityType
{
    return @"Open in Safari";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@""];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    [[UIApplication sharedApplication] openURL:activityItems.firstObject];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

@end
