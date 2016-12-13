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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIEmotionLabel *emotionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 3000);
    NSMutableString *string = [NSMutableString new];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 150)];
    [indexSet enumerateIndexesWithOptions:NSEnumerationConcurrent usingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:[NSString stringWithFormat:@"%@/%03zd",[self randomString],idx]];
    }];
    self.emotionLabel.attributedText = [self.emotionLabel attributedStringWithString:string];
    [self.emotionLabel sizeToFit];
}

- (NSString*)randomString {
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
    return [string copy];
}

@end
