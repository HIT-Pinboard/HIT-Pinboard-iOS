//
//  PBTagsSelectViewController.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/16/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBTagSelectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)doneButtonClicked:(id)sender;

@end
