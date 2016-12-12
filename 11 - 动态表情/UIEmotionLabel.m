//
//  UIEmotionLabel.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/12.
//  Copyright © 2016年 于传峰. All rights reserved.
//

#import "UIEmotionLabel.h"
#import "CFTextAttachment.h"
#import "UIImage+GIF.h"
#import "UILabel+alas.h"

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
    CGRect frame = [self contentRectofRange:NSMakeRange(0, self.attributedText.length)];
    CGFloat y = (self.bounds.size.height - frame.size.height)/2.;
    
    NSRange truncatedRange = NSMakeRange(0, 0);
//    if (self.numberOfLines != 0) {
        truncatedRange = [self truncatedRange];
//        NSLog(@"%@\n,truncated%@\n,notTruncated%@",NSStringFromRange(truncatedRange),[self truncatedText],[self.attributedText attributedSubstringFromRange:NSMakeRange(0, truncatedRange.location)]);
//    }
    
    
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(CFTextAttachment* value, NSRange range, BOOL * _Nonnull stop) {
        if (value && value.gifName.length) {
            CGRect rect = [self contentRectofRange:range];

            if (truncatedRange.location != 0 && range.location >= truncatedRange.location) {
//                *stop = YES;
            } else {
                CGFloat offset = rect.size.height - value.bounds.size.height;
                rect.size = value.bounds.size;
                rect.origin.y = rect.origin.y + y + offset - 5;
                
                UIImageView* imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self addSubview:imageView];
                UIImage *image = [UIImage sd_animatedGIFNamed:value.gifName];
                imageView.image = image;
                imageView.frame = rect;
            }            
        }
    }];
}

@end

