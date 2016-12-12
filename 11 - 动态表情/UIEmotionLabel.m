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

@interface UILabel (Truncation)
- (NSRange)truncatedRange;
- (NSString *)truncatedText;
@end

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
    
    NSRange truncatedRange = NSMakeRange(0, 0);
    if (self.numberOfLines != 0) {
        truncatedRange = [self truncatedRange];
        NSLog(@"%@\n,truncated%@\n,notTruncated%@",NSStringFromRange(truncatedRange),[self truncatedText],[self.attributedText attributedSubstringFromRange:NSMakeRange(0, truncatedRange.location)]);
    }
    
    
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(CFTextAttachment* value, NSRange range, BOOL * _Nonnull stop) {
        if (value && value.gifName.length) {
            CGRect rect = [locationSeeker characterRectofRange:range];

            if (self.numberOfLines != 0 && range.location >= truncatedRange.location) {
                *stop = YES;
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


@implementation UILabel (Truncation)

- (NSRange)truncatedRange
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self attributedText]];
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    textContainer.lineFragmentPadding = 0;
    textContainer.maximumNumberOfLines = self.numberOfLines;
    textContainer.lineBreakMode = self.lineBreakMode;
    textContainer.size = self.bounds.size;
    [layoutManager addTextContainer:textContainer];
    
    NSRange truncatedrange = [layoutManager truncatedGlyphRangeInLineFragmentForGlyphAtIndex:self.attributedText.length-1];
    return truncatedrange;
}

- (BOOL)isTruncated
{
    return [self truncatedRange].location != NSNotFound;
}

- (NSString *)truncatedText
{
    NSRange truncatedrange = [self truncatedRange];
    if (truncatedrange.location != NSNotFound)
    {
        return [self.text substringWithRange:truncatedrange];
    }
    
    return nil;
}

@end
