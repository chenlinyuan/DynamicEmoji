//
//  ALTextView.h
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/19.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTextView : UITextView

- (void)appendText:(NSString *)text;

@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
