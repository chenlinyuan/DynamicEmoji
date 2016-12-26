//
//  ALView.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/26.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "ALView.h"

@implementation ALView

@synthesize attributedText = _attributedText;
@synthesize text = _text;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)awakeFromNib {
    [super awakeFromNib];
    _contentInsets = UIEdgeInsetsMake(5, 15, 5, 15);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    rect = CGRectMake(_contentInsets.left, _contentInsets.top, rect.size.width - _contentInsets.left - _contentInsets.right, rect.size.height - _contentInsets.top - _contentInsets.bottom);
    if (_attributedText.length) {
        [_attributedText drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    } else {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = self.lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor,NSParagraphStyleAttributeName:paragraphStyle};
        [_text drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = [attributedText copy];
    _text = nil;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    _attributedText = nil;
    [self setNeedsDisplay];
}

- (NSString *)text {
    if (_text.length) {
        return _text;
    } else {
        return _attributedText.string;
    }
}

- (NSAttributedString *)attributedText {
    if (_attributedText.length) {
        return _attributedText;
    } else {
        return [[NSAttributedString alloc] initWithString:_text];
    }
}

- (UIColor *)textColor {
    if (_textColor) {
        return _textColor;
    }
    return [UIColor blackColor];
}

- (UIFont *)font {
    if (_font) {
        return _font;
    }
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

@end
