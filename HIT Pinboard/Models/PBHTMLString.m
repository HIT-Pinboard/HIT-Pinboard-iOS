//
//  PBHTMLString.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/8/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "PBHTMLString.h"
#import "NSString+HTML.h"

@interface PBHTMLString ()

@property (strong, nonatomic) NSString *css;

@end

@implementation PBHTMLString

@synthesize title = _title, subtitle = _subtitle, content = _content, css = _css, images = _images,
            shouldDisplayImages = _shouldDisplayImages;

- (void)setHTMLCSSWithContentsOfFile:(NSString *)path
                            encoding:(NSStringEncoding)enc
                               error:(NSError **)error
{
    _css = [NSString stringWithContentsOfFile:path encoding:enc error:error];
}

- (NSString *)contentByReplacingNewLinesWithBRs
{
    return [_content stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br />"];
}

- (NSString *)toHTMLString
{
    NSString *titleHTMLString = [[_title stringByEncodingHTMLEntities] stringByAddingHTMLMarkup:@"h1"];
    NSString *subtitleHTMLString = [[_subtitle stringByEncodingHTMLEntities] stringByAddingHTMLMarkup:@"h3"];
    [self replaceImageComments];
    NSString *contentHTMLString = [_content stringByAddingHTMLMarkup:@"p"];
    return [NSString stringWithFormat:@"<html><head></head><style>%@</style><body>%@<hr />%@%@</body></html>", _css, titleHTMLString, subtitleHTMLString, contentHTMLString];
}

- (void)replaceImageComments
{
    // still need modification. can't filter '<' in string
    NSMutableDictionary *dict = [@{} mutableCopy];
    NSMutableString *tmp = [[self contentByReplacingNewLinesWithBRs] mutableCopy];
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"<!-- Images\\[\\d+\\] -->" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [reg matchesInString:_content options:0 range:NSMakeRange(0, _content.length)];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *result, NSUInteger index, BOOL *stop) {
        NSString *imageURL = nil;
        if (_shouldDisplayImages) {
            imageURL = [NSString stringWithFormat:@"<img src=\"%@\">", [_images objectAtIndex:index]];
        } else {
            imageURL = @"";
        }
        [dict setObject:imageURL forKey:[NSString stringWithFormat:@"<!-- Images[%lu] -->", index]];
    }];
    for (NSString *key in dict) {
        tmp = [[tmp stringByReplacingOccurrencesOfString:key withString:[dict objectForKey:key]] mutableCopy];
    }
    _content = [NSString stringWithString:tmp];
}



@end
