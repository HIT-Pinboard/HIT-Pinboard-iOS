//
//  PBConstants.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#ifndef HIT_Pinboard_PBConstants_h
#define HIT_Pinboard_PBConstants_h

#ifdef DEBUG
#define kHost       @"http://localhost:8080"
#else
#define kHost       @"http;//219.217.227.65"
#endif

#define kCodingTitleKey         @"Title"
#define kCodingDateKey          @"Date"
#define kCodingURLStringKey     @"URLString"
#define kCodingTagsKey          @"Tags"
#define kCodingSubtitleKey      @"Subtitle"
#define kCodingContentKey       @"Content"
#define kCodingImagesKey        @"Images"
#define kCodingSubscribeKey     @"SubscribeTag"

#define kCachingFeatureList     @"FeatureList"
#define kCachingSubscribeList   @"SubscribeList"
#define kCachingTagsList        @"TagsList"

#define kSettingDisplayImages   @"shouldDisplayImages"
#define kSettingNotifications   @"shouldEnableNotifications"

#define kAppStoreURL            @"https://itunes.apple.com/us/app/apple-store/id375380948?mt=8"


typedef enum : NSUInteger {
    PBDataSourceSME,
    PBDataSourceJWC,
} PBDataSource;

#endif
