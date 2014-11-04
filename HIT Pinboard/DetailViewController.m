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
@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSString *subtitle;

@end

@implementation DetailViewController

@synthesize content = _content, newsTitle = _newsTitle, subtitle = _subtitle, imgs = _imgs;

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView loadHTMLString:self.content baseURL:nil];
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
    NSMutableDictionary *dict = [@{} mutableCopy];
    NSMutableString *tmp = [[content stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br />"] mutableCopy];
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"<!-- Images\\[\\d+\\] -->" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [reg matchesInString:tmp options:0 range:NSMakeRange(0, tmp.length)];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger index, BOOL *stop) {
        NSString *imageURL = [NSString stringWithFormat:@"<img src=\"%@\">", [_imgs objectAtIndex:index]];
        [dict setObject:imageURL forKey:[NSString stringWithFormat:@"<!-- Images[%lu] -->", index]];
    }];
    for (NSString *value in dict) {
        tmp = [[tmp stringByReplacingOccurrencesOfString:value withString:[dict objectForKey:value]] mutableCopy];
    }
    _content = [NSString stringWithString:tmp];
}

- (void)setNewsTitle:(NSString *)title {
    _newsTitle = [NSString stringWithFormat:@"<h1>%@</h1>", title];
}

- (void)setNewsSubtitle:(NSString *)subtitle {
    _subtitle = [NSString stringWithFormat:@"<h3>%@</h3>", subtitle];
}

@end
