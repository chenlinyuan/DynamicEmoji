//
//  NSString+alas.h
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/23.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (alas)
+ (NSAttributedString*)attributedStringWithString:(NSString*)contentString font:(UIFont*)font textColor:(UIColor *)textColor;
+ (NSString *)reverseAttributedStringToString:(NSAttributedString *)attributedString;
@end
