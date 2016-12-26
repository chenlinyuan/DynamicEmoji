//
//  ViewController2.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/26.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "ViewController2.h"
#import "ALView.h"

@interface ViewController2 ()



@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.alView.text = _string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
