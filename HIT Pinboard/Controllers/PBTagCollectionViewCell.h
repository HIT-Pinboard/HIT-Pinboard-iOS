//
//  PBTagCollectionViewCell.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/16/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBTagCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

+ (UINib *)nib;

@end
