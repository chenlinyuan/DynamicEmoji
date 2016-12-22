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

@dynamic imageName,string;

char imageNameKey;
char stringKey;

- (NSString *)string {
    return objc_getAssociatedObject(self, &stringKey);
}

- (void)setString:(NSString *)string {
    objc_setAssociatedObject(self, &stringKey, string, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)imageName {
    return objc_getAssociatedObject(self, &imageNameKey);
}

- (void)setImageName:(NSString *)imageName {
    objc_setAssociatedObject(self, &imageNameKey, imageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
