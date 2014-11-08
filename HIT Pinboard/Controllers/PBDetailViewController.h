//
//  PBDetailViewController.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/7/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBObject;

@interface PBDetailViewController : UIViewController

@property (strong, nonatomic) PBObject *object;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
