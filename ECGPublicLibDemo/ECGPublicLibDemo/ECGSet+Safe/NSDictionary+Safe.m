//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  NSDictionary+Safe.m
//
//  Created by tan on 2017/2/14.
//

#import "NSDictionary+Safe.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSDictionary (Safe)

// 该方法在类或者分类第一次加载内存的时候自动调用
+(void)load
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [objc_getClass("__NSDictionaryI") swizzleSelector:@selector(dictionaryWithObjects:forKeys:count:) withSwizzledSelector:@selector(avoidCrashDictionaryWithObjects:forKeys:count:)];
        });
        
    }
    
    /**
     保护字典初始化出现空值 崩溃
     
     @param objects <#objects description#>
     @param keys <#keys description#>
     @param cnt <#cnt description#>
     @return <#return value description#>
     */
- (instancetype)avoidCrashDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        instance = [self avoidCrashDictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        
        NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
        NSLog(@"%@", [exception callStackSymbols]);
        
        //处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self avoidCrashDictionaryWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}
    
    /**
     出现的场景
     */
- (void)test {
    NSString *nilStr = nil;
    NSDictionary *dict = @{
                           @"key" : nilStr
                           };
    NSLog(@"%@", dict);
}
    
@end
