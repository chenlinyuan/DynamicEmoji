//
//  ALTextView.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/19.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "ALTextView.h"
#import "NSString+alas.h"
#import "NSTextAttachment+alas.h"

@interface ALTextView () <NSTextStorageDelegate,NSLayoutManagerDelegate,UITextViewDelegate>



@end

@implementation ALTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentMode = UIViewContentModeRedraw;
    self.textStorage.delegate = self;
    self.layoutManager.delegate = self;
    self.delegate = self;
    
    _maxHeight = 100;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.font.lineHeight+self.textContainerInset.top+self.textContainerInset.bottom);
}

- (UIColor *)placeholderColor {
    if (_placeholderColor) {
        return _placeholderColor;
    }
    return [UIColor lightGrayColor];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.text.length<1 && _placeholder.length) {
        
        CGFloat x = self.textContainer.lineFragmentPadding+self.textContainerInset.left;
        CGFloat y = self.textContainerInset.top;
        CGRect frame = CGRectMake(x, y, rect.size.width - x*2, rect.size.height-y*2);
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        
        NSDictionary *attributes = @{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.placeholderColor,NSParagraphStyleAttributeName:paragraphStyle};
//        [_placeholder drawAtPoint:CGPointMake(x, y) withAttributes:attributes];

        [_placeholder drawWithRect:frame options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    }
}

- (void)deleteBackward {
    [super deleteBackward];
}

- (void)insertText:(NSString *)text {
    [super insertText:text];
}

- (void)copy:(id)sender {
    [UIPasteboard generalPasteboard].string = [NSString reverseAttributedStringToString:[self.attributedText attributedSubstringFromRange:self.selectedRange]];
}

- (void)cut:(id)sender {
    [UIPasteboard generalPasteboard].string = [NSString reverseAttributedStringToString:[self.attributedText attributedSubstringFromRange:self.selectedRange]];
    NSMutableAttributedString *string = [self.attributedText mutableCopy];
    [string replaceCharactersInRange:self.selectedRange withString:@""];
    self.attributedText = string;
    
}

- (void)paste:(id)sender {
    [self appendText:[UIPasteboard generalPasteboard].string];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self setNeedsDisplay];
}

- (void)appendText:(NSString *)text {
    NSRange range = self.selectedRange;
    NSMutableAttributedString *s = [self.attributedText mutableCopy];
    NSAttributedString *t = [self attributedStringWithString:text];
    [s replaceCharactersInRange:[self selectedRange] withAttributedString:t];
    self.attributedText = s;
    self.selectedRange = NSMakeRange(range.location+t.length, 0);
    [self setNeedsDisplay];
}

- (NSAttributedString*)attributedStringWithString:(NSString*)contentString{
    return [NSString attributedStringWithString:contentString font:self.font textColor:self.textColor];
}

- (NSString *)text {
    return [NSString reverseAttributedStringToString:self.attributedText];
}

@end
