//
//  PBDetailViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/7/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "PBDetailViewController.h"
#import "PBManager.h"
#import "PBObject.h"
#import "PBHTMLString.h"
#import "URLActivity.h"
#import "PBConstants.h"

@interface PBDetailViewController ()

@end

@implementation PBDetailViewController

@synthesize object = _object, webView = _webView, requestURL = _requestURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Detail", @"Displaying the detail news");
    
    [SVProgressHUD show];
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = shareBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
#ifdef DEBUG
    NSLog(@"viewWillAppear");
#endif
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSuccess) name:@"requestedObjectLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedFailed) name:@"requestObjectFailed" object:nil];
    
    [[PBManager sharedManager] requestSpecificObject:_requestURL];
}

- (void)viewWillDisappear:(BOOL)animated
{
#ifdef DEBUG
    NSLog(@"viewWillDisappear");
#endif
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requestedObjectLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requestObjectFailed" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Notifications
- (void)receivedSuccess
{
    _object = [[PBManager sharedManager] requestedObject];
    PBHTMLString *htmlString = [[PBHTMLString alloc] init];
    htmlString.title = _object.title;
    htmlString.subtitle = _object.subtitle;
    htmlString.content = _object.content;
    htmlString.images = _object.imgs;
    htmlString.shouldDisplayImages = [[PBManager sharedManager] shouldDisplayImages];
    [htmlString setHTMLCSSWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style.min" ofType:@"css"] encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:[htmlString toHTMLString] baseURL:nil];
    [SVProgressHUD dismiss];
}

- (void)receivedFailed
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Load failed", @"Fail loading the detail page")];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction
{
    if (![_object.urlString isEqualToString:@""]) {
        NSURL *sourceURL = [NSURL URLWithString:_object.urlString];
        UIActivityViewController *shareVC = [[UIActivityViewController alloc] initWithActivityItems:@[_object.title, sourceURL] applicationActivities:@[[[URLActivity alloc] init]]];
        [self.navigationController presentViewController:shareVC animated:YES completion:nil];
    }
}

@end
