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

@end
