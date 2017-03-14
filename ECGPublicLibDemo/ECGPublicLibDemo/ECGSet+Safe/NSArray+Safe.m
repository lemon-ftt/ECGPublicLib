//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  NSArray+Safe.m
//  防止数组越界错误
//  Created by baotiao ni on 2016/12/7.
//

#import "NSArray+Safe.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@implementation NSArray (Safe)

/**
 加载调用
 */
+ (void)load {
    //单例模式
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL safeSel=@selector(safeObjectAtIndex:);//自定义函数
        SEL unsafeSel=@selector(objectAtIndex:);//系统类函数
        
        Class myClass = NSClassFromString(@"__NSArrayI");
        Method safeMethod=class_getInstanceMethod (myClass, safeSel);
        Method unsafeMethod=class_getInstanceMethod (myClass, unsafeSel);
        
        method_exchangeImplementations(unsafeMethod, safeMethod);//交换
        
    });
}

/**
 防止数组越界错误函数（与objectAtIndex做了动态交换）

 @param index 索引值
 @return 返回值
 */
- (id)safeObjectAtIndex:(NSUInteger)index {
    
    if (index > (self.count - 1)) {//调试模式下越界会执行断言,程序崩溃；线上环境返回nil，但是不会崩溃
#ifdef DEBUG
        NSArray *stackArray = [NSThread callStackSymbols];
        [stackArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@", obj);
        }];
#endif
        NSAssert(NO, @"数组越界错误,请查看日志或者堆栈信息");
        return nil;
    }
    else{
        /*id value = [self safeObjectAtIndex:index];//多一步对返回值的校验(实际上调用的是objectAtIndex)
        if (value == [NSNull null]) {
            return nil;
        }*/
        
        return [self safeObjectAtIndex:index];
    }
}
@end
