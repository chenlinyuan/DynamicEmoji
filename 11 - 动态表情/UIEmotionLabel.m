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
#import "CharacterLocationSeeker.h"

@implementation UIEmotionLabel
{
    CharacterLocationSeeker *locationSeeker;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    locationSeeker = [CharacterLocationSeeker new];
}

- (NSInteger)numberOfLines {
    return [super numberOfLines];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    [super setNumberOfLines:numberOfLines];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [locationSeeker configWithLabel:self];
    for (UIView* subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    CGRect frame = [locationSeeker characterRectofRange:NSMakeRange(0, self.attributedText.length)];
    CGFloat y = (self.bounds.size.height - frame.size.height)/2.;
    
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(CFTextAttachment* value, NSRange range, BOOL * _Nonnull stop) {
        if (value && value.gifName.length) {
            CGRect rect = [locationSeeker characterRectofRange:range];
//            NSLog(@"%@",NSStringFromCGRect(rect));
            if ([locationSeeker isTruncatedAtIndex:range.location]) {
//                NSLog(@"w:%f,h:%f",rect.size.width + rect.origin.x,rect.origin.y + rect.size.height);
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
