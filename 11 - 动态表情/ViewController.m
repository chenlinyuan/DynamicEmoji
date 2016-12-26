//
//  ViewController.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/23.
//  Copyright © 2016年 alas743k. All rights reserved.
//


#import "ViewController.h"
#import "UIEmotionLabel.h"
#import "UILabel+alas.h"
#import "ALTextView.h"
#import "NSString+alas.h"
#import "ViewController2.h"
#import "ALView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet ALTextView *textView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    _textView.inputAccessoryView = _toolBar;
    [self addObserver:self forKeyPath:@"self.textView.contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    _dataArray = [NSMutableArray array];
    _tableView.tableFooterView = [UIView new];
//    _tableView.allowsSelection = NO;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"self.textView.contentSize"]) {
        NSValue *obj = [change objectForKey:NSKeyValueChangeNewKey];
        CGSize size = [obj CGSizeValue];
        NSLog(@"%@",NSStringFromCGSize(size));
        CGRect frame = _textView.frame;
        frame.size = CGSizeMake(_textView.frame.size.width, MIN(size.height, _textView.maxHeight));
        frame.origin.y -= frame.size.height - _textView.bounds.size.height;
        
        [UIView animateWithDuration:.25 animations:^{
            _textView.frame = frame;
            _tableView.frame = CGRectMake(0, _tableView.frame.origin.y, _tableView.frame.size.width, frame.origin.y-_tableView.frame.origin.y);
            CGPoint offset = CGPointMake(0, MAX(0, self.tableView.contentSize.height - self.tableView.frame.size.height));
            [_tableView setContentOffset:offset animated:YES];
        }];
    }
}

- (void)keyboardWillAppear:(NSNotification*)noti {
    if (noti) {
        NSDictionary *userInfo = noti.userInfo;
        CGRect bounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat height = bounds.size.height;
        [UIView animateWithDuration:.25 animations:^{
            _textView.transform = CGAffineTransformMakeTranslation(0, -height);
            _tableView.frame = CGRectMake(0, _tableView.frame.origin.y, _tableView.frame.size.width, _textView.frame.origin.y-_tableView.frame.origin.y);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)keyboardWillDisappear:(NSNotification*)noti {
    [UIView animateWithDuration:.25 animations:^{
        _textView.transform = CGAffineTransformIdentity;
        _tableView.frame = CGRectMake(0, _tableView.frame.origin.y, _tableView.frame.size.width, _textView.frame.origin.y-_tableView.frame.origin.y);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.numberOfLines = 0;
    }
    
    cell.textLabel.attributedText = [NSString attributedStringWithString:_dataArray[indexPath.row] font:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] textColor:[UIColor darkTextColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = _dataArray[indexPath.row];
    NSAttributedString *aString = [NSString attributedStringWithString:string font:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] textColor:[UIColor darkTextColor]];
    return [aString boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-15*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height+5*2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController2 *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController2"];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSString *string = _dataArray[indexPath.row];
    vc.string = string;
   
}

- (IBAction)sendMsg:(id)sender {
    [_dataArray addObject:_textView.text];
    _textView.text = @"";
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.textView.contentSize"];
}

@end
