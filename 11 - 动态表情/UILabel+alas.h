//
//  UILabel+alas.h
//  DynamicEmoji
//
//  Created by 陈琳元 on 16/12/12.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (alas)

@property (strong, nonatomic) NSTextStorage *textStorage;
@property (strong, nonatomic) NSLayoutManager *layoutManager;
@property (strong, nonatomic) NSTextContainer *textContainer;

@property (copy, nonatomic) BOOL (^shouldInteractWithURL)(NSURL *URL,NSRange range);

- (BOOL)isTruncated;
- (NSRange)truncatedRange;
- (NSString *)truncatedText;
- (CGRect)contentRectofRange:(NSRange)range;

@end
