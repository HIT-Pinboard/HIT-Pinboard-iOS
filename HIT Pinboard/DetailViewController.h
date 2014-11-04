//
//  DetailViewController.h
//  HIT Pinboard
//
//  Created by Yifei Zhou on 10/22/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSArray *imgs;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)setNewsTitle:(NSString *)title;
- (void)setNewsSubtitle:(NSString *)subtitle;
- (void)setContent:(NSString *)content;

@end
