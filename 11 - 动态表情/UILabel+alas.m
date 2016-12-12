//
//  UILabel+alas.m
//  DynamicEmoji
//
//  Created by 陈琳元 on 16/12/12.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "UILabel+alas.h"

#import <objc/runtime.h>

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

@end
