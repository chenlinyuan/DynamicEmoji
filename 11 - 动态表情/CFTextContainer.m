//
//  CFTextContainer.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/12.
//  Copyright © 2016年 于传峰. All rights reserved.
//

#import "CFTextContainer.h"

@implementation CFTextContainer

- (CGRect)lineFragmentRectForProposedRect:(CGRect)proposedRect
                                  atIndex:(NSUInteger)characterIndex
                         writingDirection:(NSWritingDirection)baseWritingDirection
                            remainingRect:(CGRect *)remainingRect {
    
    CGRect rect = [super lineFragmentRectForProposedRect:proposedRect
                                                 atIndex:characterIndex
                                        writingDirection:baseWritingDirection
                                           remainingRect:remainingRect];
    
    CGSize size = [self size];
    CGFloat radius = fmin(size.width, size.height) / 2.0;
    CGFloat ypos = fabs((proposedRect.origin.y + proposedRect.size.height / 2.0) - radius);
    CGFloat width = (ypos < radius) ? 2.0 * sqrt(radius * radius - ypos * ypos) : 0.0;
    CGRect circleRect = CGRectMake(radius - width / 2.0, proposedRect.origin.y, width, proposedRect.size.height);
    
    return CGRectIntersection(rect, circleRect);
}

@end
