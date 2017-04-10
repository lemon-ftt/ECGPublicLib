//
//  UIFont+SystemSize.m
//  ECGPublicLibDemo
//
//  Created by tan on 2017/4/10.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "UIFont+SystemSize.h"
#import <objc/runtime.h>
#import "ECGLayoutConstraint.h"

@implementation UIFont (SystemSize)

/**
 加载调用
 */
+ (void)load {
    Method imp = class_getClassMethod(self, @selector(systemFontOfSize:));
    Method myImp = class_getClassMethod(self, @selector(customSystemFontOfSize:));
    method_exchangeImplementations(imp, myImp);
    
}


+ (UIFont *)customSystemFontOfSize:(CGFloat)fontSize{
    
    if (ECGAdjuestFontSize(fontSize) == fontSize) {
        return [self customSystemFontOfSize:fontSize];
    }
    return [self customSystemFontOfSize:ECGAdjuestFontSize(fontSize)];
    
}

@end
