//
//  ALView.h
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/26.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@end
