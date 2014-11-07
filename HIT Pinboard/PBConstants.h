//
//  PBConstants.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#ifndef HIT_Pinboard_PBConstants_h
#define HIT_Pinboard_PBConstants_h

#define kHost       @"http://202.118.250.19"
#define kWebRoot    @"/"


#define kCodingTitleKey       @"Title"
#define kCodingDateKey        @"Date"
#define kCodingURLStringKey   @"URLString"
#define kCodingTagsKey        @"Tags"
#define kCodingSubtitleKey    @"Subtitle"
#define kCodingContentKey     @"Content"
#define kCodingImagesKey      @"Images"



typedef enum : NSUInteger {
    PBDataSourceSME = 0,
    PBDataSourceCA
} PBDataSourcesType;

#endif
