//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  NSMutableDictionary+Safe.m
//
//  Created by tan on 2017/2/14.
//

#import "NSMutableDictionary+Safe.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Safe)

    
// 该方法在类或者分类第一次加载内存的时候自动调用
+(void)load
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [objc_getClass("__NSDictionaryM") swizzleSelector:@selector(setObject:forKey:) withSwizzledSelector:@selector(safeSetObject:forKey:)];
        });
        
    }
    
    /**
     保护给可变字典加入值为nil 并打印错误信息
     
     @param emObject obj
     @param key key
     */
-(void)safeSetObject:(id)emObject forKey:(NSString *)key {
    if (emObject == nil) {
        @try {
            [self safeSetObject:emObject forKey:key];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            emObject = [NSString stringWithFormat:@""];
            [self safeSetObject:emObject forKey:key];
        }
        @finally {}
    }else {
        [self safeSetObject:emObject forKey:key];
    }
}

@end
