//
//  NSString+alas.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/23.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "NSString+alas.h"
#import "NSTextAttachment+alas.h"
#import "UIImage+GIF.h"

@implementation NSString (alas)
+ (NSAttributedString*)attributedStringWithString:(NSString*)contentString font:(UIFont*)font textColor:(UIColor *)textColor {
    NSString* pattern = @"/[0-9]{1,3}";
    NSRegularExpression* regx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSMutableDictionary* gifEomtionDict = [[NSMutableDictionary alloc] init];
    [regx enumerateMatchesInString:contentString options:NSMatchingReportProgress range:NSMakeRange(0, contentString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString* resultString = [contentString substringWithRange:result.range];
        NSString* gifName = nil;
        if ([resultString compare:@"/000"] == NSOrderedDescending && [resultString compare:@"/142"] == NSOrderedAscending) {
            gifName = resultString;
        }
        if (gifName) {
            gifEomtionDict[NSStringFromRange(NSMakeRange(result.range.location, resultString.length))] = gifName;
        }
    }];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
    NSMutableArray* ranges = [gifEomtionDict.allKeys mutableCopy];
    [ranges sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        NSRange range1 = NSRangeFromString(obj1);
        NSRange range2 = NSRangeFromString(obj2);
        
        if (range1.location < range2.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    for (NSString* rangeString in ranges) {
        NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
        NSString *gifName = [gifEomtionDict[rangeString] substringFromIndex:1];
        attachment.string = gifEomtionDict[rangeString];
        UIImage *image = [UIImage sd_animatedGIFNamed:gifName];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, font.descender, font.lineHeight, font.lineHeight);
        NSAttributedString* attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedString replaceCharactersInRange:NSRangeFromString(rangeString) withAttributedString:attachmentString];
    }
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

+ (NSString *)reverseAttributedStringToString:(NSAttributedString *)attributedString {
    NSMutableString *string = [NSMutableString string];
    [attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value) {
            NSTextAttachment *obj = value;
            [string appendString:obj.string];
        } else {
            [string appendString:[attributedString attributedSubstringFromRange:range].string];
        }
    }];
    return string;
}

@end
