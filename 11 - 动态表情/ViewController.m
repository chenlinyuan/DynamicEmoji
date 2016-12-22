//
//  ViewController.m
//  11 - 动态表情
//
//  Created by 于传峰 on 15/12/28.
//  Copyright © 2015年 于传峰. All rights reserved.
//

#import "ViewController.h"
#import "UIEmotionLabel.h"
#import "UILabel+alas.h"
#import "ALTextView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ALTextView *textView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
//    _textView.inputAccessoryView = _toolBar;
}

- (void)keyboardWillAppear:(NSNotification*)noti {
    if (noti) {
        NSDictionary *userInfo = noti.userInfo;
        CGRect bounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat height = bounds.size.height;
        [UIView animateWithDuration:.25 animations:^{
            _textView.transform = CGAffineTransformMakeTranslation(0, -height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)keyboardWillDisappear:(NSNotification*)noti {
    [UIView animateWithDuration:.25 animations:^{
        _textView.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)addEmoji:(UIBarButtonItem*)sender {
    [_textView appendText:[NSString stringWithFormat:@"/%03zd",sender.tag]];
}

- (NSString*)randomString {
    //return @"";
    NSMutableString *string = [NSMutableString string];
    NSInteger count = arc4random_uniform(9);
    for (NSInteger i = 0; i < count; i++) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
        
        NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
        
        NSInteger number = (randomH<<8)+randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        
        NSString *s = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        [string appendString:s];
    }
    return [string mutableCopy];
}

@end
