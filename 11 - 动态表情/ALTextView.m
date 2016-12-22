//
//  ALTextView.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/19.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "ALTextView.h"
#import "UIImage+GIF.h"
#import "NSTextAttachment+alas.h"

@interface ALTextView () <NSTextStorageDelegate,NSLayoutManagerDelegate,UITextViewDelegate>



@end

@implementation ALTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentMode = UIViewContentModeRedraw;
    self.textStorage.delegate = self;
    self.layoutManager.delegate = self;
    self.delegate = self;
    [self addObserver:self forKeyPath:@"self.contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    _maxHeight = 100;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.font.lineHeight+self.textContainerInset.top+self.textContainerInset.bottom);
}

- (UIColor *)placeholderColor {
    if (_placeholderColor) {
        return _placeholderColor;
    }
    return [UIColor lightGrayColor];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"self.contentSize"]) {
        NSValue *obj = [change objectForKey:NSKeyValueChangeNewKey];
        CGSize size = [obj CGSizeValue];
        NSLog(@"%@",NSStringFromCGSize(size));
        CGRect frame = self.frame;
        frame.size = CGSizeMake(self.frame.size.width, MIN(size.height, self.maxHeight));
        frame.origin.y = 667-frame.size.height-218-44;
        self.frame = frame;
    }
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.text.length<1 && _placeholder.length) {
        [_placeholder drawAtPoint:CGPointMake(self.textContainer.lineFragmentPadding+self.textContainerInset.left, self.textContainerInset.top) withAttributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.placeholderColor}];
    }
}

- (void)deleteBackward {
    [super deleteBackward];
    [self setNeedsDisplay];
}

- (void)insertText:(NSString *)text {
    [super insertText:text];
    [self setNeedsDisplay];
}

- (void)copy:(id)sender {
    [UIPasteboard generalPasteboard].string = [self reverseAttributedStringToString:[self.attributedText attributedSubstringFromRange:self.selectedRange]];
}

- (void)cut:(id)sender {
    [UIPasteboard generalPasteboard].string = [self reverseAttributedStringToString:[self.attributedText attributedSubstringFromRange:self.selectedRange]];
    NSMutableAttributedString *string = [self.attributedText mutableCopy];
    [string replaceCharactersInRange:self.selectedRange withString:@""];
    self.attributedText = string;
    
}

- (void)paste:(id)sender {
    [self appendText:[UIPasteboard generalPasteboard].string];
}



- (void)appendText:(NSString *)text {
    NSRange range = self.selectedRange;
//    [super insertText:text];
    NSMutableAttributedString *s = [self.attributedText mutableCopy];
    NSAttributedString *t = [self attributedStringWithString:text];
    [s replaceCharactersInRange:[self selectedRange] withAttributedString:t];
    self.attributedText = s;
    self.selectedRange = NSMakeRange(range.location+t.length, 0);
}

- (NSAttributedString*)attributedStringWithString:(NSString*)contentString {
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
        attachment.bounds = CGRectMake(0, self.font.descender, 30, 30);
        NSAttributedString* attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedString replaceCharactersInRange:NSRangeFromString(rangeString) withAttributedString:attachmentString];
    }
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (NSString *)text {
    return [self reverseAttributedStringToString:self.attributedText];
}

- (NSString *)reverseAttributedStringToString:(NSAttributedString *)attributedString {
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

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.contentSize"];
}

@end
