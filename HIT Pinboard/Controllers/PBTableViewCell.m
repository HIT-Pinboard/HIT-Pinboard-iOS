//
//  PBTableViewCell.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBTableViewCell.h"

@implementation PBTableViewCell


/*
 * freak issue here: http://stackoverflow.com/questions/11681273/uitableviewcell-imageview-changing-on-select
 */
@synthesize imageView;

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"PBTableViewCell" bundle:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
