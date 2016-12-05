//
//  CFTextView.m
//  11 - 动态表情
//
//  Created by 于传峰 on 15/12/29.
//  Copyright © 2015年 于传峰. All rights reserved.
//

#import "CFTextView.h"
#import "UIImage+GIF.h"
#import "CFTextAttachment.h"

@implementation CFTextView

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];

}


- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView* subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(CFTextAttachment* value, NSRange range, BOOL * _Nonnull stop) {
        if (value && value.gifName.length) {
            self.selectedRange = range;
            CGRect rect = [self firstRectForRange:self.selectedTextRange];
            self.selectedRange = NSMakeRange(0, 0);
            
            UIImageView* imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:imageView];
            UIImage *image = [UIImage sd_animatedGIFNamed:value.gifName];
            imageView.image = image;
            
            //            rect.origin.y += rect.size.height-image.size.height;
            //            rect.size = image.size;
            imageView.frame = rect;
        }
    }];
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
}

@end
