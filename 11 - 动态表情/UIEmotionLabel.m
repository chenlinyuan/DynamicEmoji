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

@implementation UIEmotionLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSInteger)numberOfLines {
    return [super numberOfLines];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    [super setNumberOfLines:numberOfLines];
}

- (void)setText:(NSString *)text {
//    _contentString = contentString;
    NSString* pattern = @"/[\u4e00-\u9fa5]{2,4}";
    NSRegularExpression* regx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"EmotionGifList" ofType:@"plist"];
    NSDictionary* emotionDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary* gifEomtionDict = [[NSMutableDictionary alloc] init];
    [regx enumerateMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString* resultString = [text substringWithRange:result.range];
        NSString* gifName = emotionDic[resultString];
        
        for (int i = 0; resultString.length > 2 && !gifName; i++) {
            resultString = [resultString substringWithRange:NSMakeRange(0, resultString.length - 1)];
            gifName = emotionDic[resultString];
        }
        
        if (gifName) {
            gifEomtionDict[NSStringFromRange(NSMakeRange(result.range.location, resultString.length))] = gifName;
            NSLog(@"%@----%@====%@", resultString, gifName, gifEomtionDict);
        }
    }];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text];
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
        CFTextAttachment* attachment = [[CFTextAttachment alloc] init];
        attachment.gifName = gifEomtionDict[rangeString];
        NSAttributedString* attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedString replaceCharactersInRange:NSRangeFromString(rangeString) withAttributedString:attachmentString];
    }
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, attributedString.length)];
    self.attributedText = attributedString;
}

- (void)layoutSubviews {
    for (UIView* subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    [super layoutSubviews];
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(CFTextAttachment* value, NSRange range, BOOL * _Nonnull stop) {
        if (value && value.gifName.length) {
//            self.selectedRange = range;
//            CGRect rect = [self firstRectForRange:self.selectedTextRange];
//            self.selectedRange = NSMakeRange(0, 0);
            
            CGRect rect = value.bounds;
//            NSLog(@"%@",NSStringFromCGRect(rect));
            UIImageView* imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:imageView];
            UIImage *image = [UIImage sd_animatedGIFNamed:value.gifName];
            imageView.image = image;
            imageView.frame = rect;
        }
    }];
}
@end
