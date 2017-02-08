//
//  UIEmotionLabel.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/12.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "UIEmotionLabel.h"
#import "UIImage+GIF.h"
#import "UILabel+alas.h"
#import "NSTextAttachment+alas.h"

@implementation UIEmotionLabel

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView* subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    NSRange range1 = NSMakeRange(0, self.attributedText.length);
    CGRect frame = [self contentRectofRange:range1];
    CGFloat y = (self.bounds.size.height - frame.size.height)/2.;
    
    NSRange truncatedRange = NSMakeRange(0, 0);
    truncatedRange = [self truncatedRange];
    
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:range1 options:NSAttributedStringEnumerationReverse usingBlock:^(NSTextAttachment* value, NSRange range, BOOL * _Nonnull stop) {
        if (truncatedRange.location != 0 && range.location >= truncatedRange.location) {
            
        } else {
            if (value && value.imageName.length) {
                CGRect rect = [self contentRectofRange:range];
                CGFloat offset = rect.size.height - value.bounds.size.height;
                rect.size = value.bounds.size;
                rect.origin.y = rect.origin.y + y + offset;
                UIImageView* imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.image = [UIImage sd_animatedGIFNamed:value.imageName];
                imageView.frame = rect;
                [self addSubview:imageView];
            }
        }
    }];
}

@end

