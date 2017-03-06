//
//  UILabel+alas.m
//  DynamicEmoji
//
//  Created by 陈琳元 on 16/12/12.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "UILabel+alas.h"
#import <objc/runtime.h>
#import "NSTextAttachment+alas.h"

@interface UILabelLink : NSObject

@property (strong, nonatomic) NSURL *link;
@property (assign, nonatomic) NSRange range;

+ (instancetype)linkWithURL:(NSURL *)URL range:(NSRange)range;

@end

@implementation UILabel (alas)

@dynamic textContainer,textStorage,layoutManager;

char textStorageKey;
char textContainerKey;
char layoutManagerKey;

char shouldInteractWithURLKey;

- (NSTextContainer *)textContainer {
    NSTextContainer *obj = objc_getAssociatedObject(self, &textContainerKey);
    if (!obj) {
        obj = [[[self class] textContainerClass] new];
        self.textContainer = obj;
    }
    return obj;
}

- (NSLayoutManager *)layoutManager {
    NSLayoutManager *obj = objc_getAssociatedObject(self, &layoutManagerKey);
    if (!obj) {
        obj = [[[self class] layoutManagerClass] new];
        [obj addTextContainer:self.textContainer];
        self.layoutManager = obj;
    }
    return obj;
}

- (NSTextStorage *)textStorage {
    NSTextStorage *obj = objc_getAssociatedObject(self, &textStorageKey);
    if (!obj) {
        obj = [[[[self class] textStorageClass] alloc] initWithAttributedString:self.attributedText];
        [obj addLayoutManager:self.layoutManager];
        self.textStorage = obj;
    }
    return obj;
}

- (BOOL (^)(NSURL *, NSRange))shouldInteractWithURL {
    return objc_getAssociatedObject(self, &shouldInteractWithURLKey);
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

- (void)setShouldInteractWithURL:(BOOL (^)(NSURL *, NSRange))shouldInteractWithURL {
    objc_setAssociatedObject(self, &shouldInteractWithURLKey, shouldInteractWithURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


+ (Class)textStorageClass {
    return [NSTextStorage class];
}

+ (Class)layoutManagerClass {
    return [NSLayoutManager class];
}

+ (Class)textContainerClass {
    return [NSTextContainer class];
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
    [self setupTextContainer];
    [self layoutManager];
    [self textStorage];
    NSRange characterRange = range;
    NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:characterRange actualCharacterRange:nil];
    return [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
}

#pragma mark - TextContainer

- (void)setupTextContainer {
    self.textContainer.size = self.bounds.size;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = self.numberOfLines;
    self.textContainer.lineBreakMode = self.lineBreakMode;
}

- (NSMutableArray *)links {
    NSMutableArray *array = [NSMutableArray array];
    [self.attributedText enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value) {
            [array addObject:[UILabelLink linkWithURL:value range:range]];
        }
    }];
    return array;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (UILabelLink *  _Nonnull obj in [self links]) {
        CGRect rect = [self contentRectofRange:obj.range];
        if (CGRectContainsPoint(rect, point)) {
            if (self.shouldInteractWithURL) {
                if (self.shouldInteractWithURL(obj.link,obj.range)) {
                    return self;
                }
                break;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

@end

@implementation UILabelLink

+ (instancetype)linkWithURL:(NSURL *)URL range:(NSRange)range {
    UILabelLink *link = [UILabelLink new];
    if (link) {
        link.link = URL;
        link.range = range;
    }
    return link;
}

@end
