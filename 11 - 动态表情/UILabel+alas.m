//
//  UILabel+alas.m
//  DynamicEmoji
//
//  Created by 陈琳元 on 16/12/12.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "UILabel+alas.h"
#import "UIImage+GIF.h"
#import <objc/runtime.h>
#import "NSTextAttachment+alas.h"

@implementation UILabel (alas)

@dynamic textContainer,textStorage,layoutManager;

char textStorageKey;
char textContainerKey;
char layoutManagerKey;

- (NSTextContainer *)textContainer {
    NSTextContainer *obj = objc_getAssociatedObject(self, &textContainerKey);
    if (!obj) {
        obj = [NSTextContainer new];
        self.textContainer = obj;
    }
    return obj;
}

- (NSLayoutManager *)layoutManager {
    NSLayoutManager *obj = objc_getAssociatedObject(self, &layoutManagerKey);
    if (!obj) {
        obj = [NSLayoutManager new];
        [obj addTextContainer:self.textContainer];
        self.layoutManager = obj;
    }
    return obj;
}

- (NSTextStorage *)textStorage {
    NSTextStorage *obj = objc_getAssociatedObject(self, &textStorageKey);
    if (!obj) {
        obj = [NSTextStorage new];
        [obj addLayoutManager:self.layoutManager];
        self.textStorage = obj;
    }
    return obj;
}

- (void)setTextContainer:(NSTextContainer *)textContainer {
    objc_setAssociatedObject(self, &textContainerKey, textContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLayoutManager:(NSLayoutManager *)layoutManager {
    objc_setAssociatedObject(self, &layoutManagerKey, layoutManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTextStorage:(NSTextStorage *)textStorage {
    objc_setAssociatedObject(self, &textStorageKey, textStorage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Truncation

- (NSRange)truncatedRange {
    [self.textStorage setAttributedString:self.attributedText];
    NSRange truncatedrange = [self.layoutManager truncatedGlyphRangeInLineFragmentForGlyphAtIndex:self.attributedText.length-1];
    return truncatedrange;
}

- (BOOL)isTruncated {
    return [self truncatedRange].location != NSNotFound;
}

- (NSString *)truncatedText {
    NSRange truncatedrange = [self truncatedRange];
    if (truncatedrange.location != NSNotFound)
    {
        return [self.text substringWithRange:truncatedrange];
    }
    return nil;
}

#pragma mark - LayoutManager

- (CGRect)contentRectofRange:(NSRange)range {
    NSRange characterRange = range;
    NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:characterRange actualCharacterRange:nil];
    [self setupTextContainer];
    return [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
}

#pragma mark - TextContainer

- (void)setupTextContainer {
    self.textContainer.size = self.bounds.size;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = self.numberOfLines;
    self.textContainer.lineBreakMode = self.lineBreakMode;
}

- (NSAttributedString*)attributedStringWithString:(NSString*)contentString {
    NSString* pattern = @"/[0-9]{1,3}";
    NSRegularExpression* regx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"EmotionGifList" ofType:@"plist"];
//    NSDictionary* emotionDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary* gifEomtionDict = [[NSMutableDictionary alloc] init];
    [regx enumerateMatchesInString:contentString options:NSMatchingReportProgress range:NSMakeRange(0, contentString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString* resultString = [contentString substringWithRange:result.range];
        NSString* gifName = nil;
        if ([resultString compare:@"/000"] == NSOrderedDescending && [resultString compare:@"/142"] == NSOrderedAscending) {
            gifName = resultString;
        }
        if (gifName) {
            gifEomtionDict[NSStringFromRange(NSMakeRange(result.range.location, resultString.length))] = gifName;
//            NSLog(@"%@----%@====%@", resultString, gifName, gifEomtionDict);
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
        UIImage *image = [UIImage sd_animatedGIFNamed:gifName];
        if (image) {
            attachment.imageName = gifName;
        } else {
            attachment.image = [UIImage imageNamed:gifName];
        }        
        attachment.bounds = CGRectMake(0, self.font.descender, image.size.width, image.size.height);
        NSAttributedString* attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedString replaceCharactersInRange:NSRangeFromString(rangeString) withAttributedString:attachmentString];
    }
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

@end
