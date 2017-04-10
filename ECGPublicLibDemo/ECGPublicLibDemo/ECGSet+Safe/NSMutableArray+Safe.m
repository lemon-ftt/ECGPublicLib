//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  NSMutableArray+Safe.m
//
//  Created by tan on 2017/2/14.
//

#import "NSMutableArray+Safe.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Safe)
    
// 该方法在类或者分类第一次加载内存的时候自动调用
+(void)load
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self swizzleSelector:@selector(removeObject:)withSwizzledSelector:@selector(safeRemoveObject:)];
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(addObject:) withSwizzledSelector:@selector(safeAddObject:)];
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(removeObjectAtIndex:) withSwizzledSelector:@selector(safeRemoveObjectAtIndex:)];
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(insertObject:atIndex:) withSwizzledSelector:@selector(safeInsertObject:atIndex:)];
            [objc_getClass("__NSPlaceholderArray") swizzleSelector:@selector(initWithObjects:count:) withSwizzledSelector:@selector(safeInitWithObjects:count:)];
            [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndex:) withSwizzledSelector:@selector(safeObjectAtIndex:)];
        });
    }
    
    /**
     保护数组中有nil对象  并把nil 过滤掉
     
     @param objects <#objects description#>
     @param cnt <#cnt description#>
     @return <#return value description#>
     */
- (instancetype)safeInitWithObjects:(const id  _Nonnull   __unsafe_unretained *)objects count:(NSUInteger)cnt
    {
        BOOL hasNilObject = NO;
        for (NSUInteger i = 0; i < cnt; i++) {
            if ([objects[i] isKindOfClass:[NSArray class]]) {
            }
            if (objects[i] == nil) {
                hasNilObject = YES;
                NSLog(@"%s object at index %lu is nil, it will be     filtered", __FUNCTION__, (unsigned long)i);
                
#if DEBUG
                // 对数组中为nil的元素信息打印出来
                NSString *errorMsg = [NSString     stringWithFormat:@"数组元素不能为nil，其index为: %lu", (unsigned long)i];
                NSAssert(objects[i] != nil, errorMsg);
#endif
            }
        }
        
        // 因为有值为nil的元素，那么我们可以过滤掉值为nil的元素
        if (hasNilObject) {
            id __unsafe_unretained newObjects[cnt];
            NSUInteger index = 0;
            for (NSUInteger i = 0; i < cnt; ++i) {
                if (objects[i] != nil) {
                    newObjects[index++] = objects[i];
                }
            }
            return [self safeInitWithObjects:newObjects count:index];
        }
        return [self safeInitWithObjects:objects count:cnt];
    }
    
    /**
     保护添加obj
     
     @param obj <#obj description#>
     */
- (void)safeAddObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s can add nil object into NSMutableArray", __FUNCTION__);
    } else {
        [self safeAddObject:obj];
    }
}
    /**
     保护移除obj
     
     @param obj <#obj description#>
     */
- (void)safeRemoveObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s call -removeObject:, but argument obj is nil", __FUNCTION__);
        return;
    }
    [self safeRemoveObject:obj];
}
    
    /**
     保护插入obj 根据index
     
     @param anObject <#anObject description#>
     @param index <#index description#>
     */
- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        NSLog(@"%s can't insert nil into NSMutableArray", __FUNCTION__);
    } else if (index > self.count) {
        NSLog(@"%s index is invalid", __FUNCTION__);
    } else {
        [self safeInsertObject:anObject atIndex:index];
    }
}
    
    /**
     保护取obj 根据index
     
     @param index <#index description#>
     @return <#return value description#>
     */
- (id)safeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return nil;
    }
    if (index > self.count) {
        NSLog(@"%s index out of bounds in array", __FUNCTION__);
        return nil;
    }
    return [self safeObjectAtIndex:index];
}
    
    /**
     保护移除obj 根据index
     
     @param index <#index description#>
     */
- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
    if (self.count <= 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return;
    }
    if (index >= self.count) {
        NSLog(@"%s index out of bound", __FUNCTION__);
        return;
    }
    [self safeRemoveObjectAtIndex:index];
}

    

@end
