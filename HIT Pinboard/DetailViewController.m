//
//  DetailViewController.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 10/22/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) NSString *content;

@end

@implementation DetailViewController

@synthesize content = _content;

- (instancetype)init {
    self = [super init];
    if (self)
        NSLog(@"DetailVC has benn inited!");
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.text = self.content;
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

- (void)setContent:(NSString *)content {
    _content = [content stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}


@end
