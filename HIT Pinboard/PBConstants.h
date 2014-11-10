//
//  PBConstants.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#ifndef HIT_Pinboard_PBConstants_h
#define HIT_Pinboard_PBConstants_h

#define kHost       @"http://localhost:8080"


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

enum {
    PBDataSourceSME = 0,
    PBDataSourceCA = 1
};

#endif
