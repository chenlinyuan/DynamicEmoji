//
//  NSTextAttachment+alas.m
//  DynamicEmoji
//
//  Created by chen diyu on 16/12/13.
//  Copyright © 2016年 alas743k. All rights reserved.
//

#import "NSTextAttachment+alas.h"
#import <objc/runtime.h>

@implementation NSTextAttachment (alas)

@dynamic imageName;

char imageNameKey;

- (NSString *)imageName {
    return objc_getAssociatedObject(self, &imageNameKey);
}

- (void)setImageName:(NSString *)imageName {
    objc_setAssociatedObject(self, &imageNameKey, imageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
