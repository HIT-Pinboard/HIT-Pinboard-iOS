//
//  PBDetailViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/7/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBDetailViewController.h"
#import "PBObject.h"
#import "URLActivity.h"

@interface PBDetailViewController ()

@end

@implementation PBDetailViewController

@synthesize object = _object, webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = shareBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)shareAction
{
    if (![_object.urlString isEqualToString:@""]) {
        NSURL *sourceURL = [NSURL URLWithString:_object.urlString];
        UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:@[_object.title, sourceURL] applicationActivities:@[[[URLActivity alloc] init]]];
        [self.navigationController presentViewController:shareVC animated:YES completion:nil];
    }
}

@end
