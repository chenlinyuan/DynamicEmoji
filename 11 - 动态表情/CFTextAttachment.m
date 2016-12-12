//
//  CFTextAttachment.m
//  11 - 动态表情
//
//  Created by 于传峰 on 15/12/29.
//  Copyright © 2015年 于传峰. All rights reserved.
//

#import "CFTextAttachment.h"
#import "UIImage+GIF.h"

@implementation CFTextAttachment

- (void)setGifName:(NSString *)gifName {
    _gifName = gifName;
    UIImage *image = [UIImage sd_animatedGIFNamed:gifName];
    CGRect bounds = self.bounds;
    bounds.size = image.size;
    self.bounds = bounds;
}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
    if (_mark) {
        static CGFloat y = 0;
        
        if (y != lineFrag.origin.y) {
            NSLog(@"position:%@,lineFrag:%@",NSStringFromCGPoint(position),NSStringFromCGRect(lineFrag));
        }
        y = lineFrag.origin.y;
        
        CGRect rect = CGRectMake(position.x, 0, self.bounds.size.width, self.bounds.size.height);
        self.bounds = CGRectMake(rect.origin.x, lineFrag.origin.y+10, rect.size.width, rect.size.height);
        return rect;
    } else {
        return CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }
}

//- (nullable UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(nullable NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex {
//    [super imageForBounds:imageBounds textContainer:textContainer characterIndex:charIndex];
//}

@end
