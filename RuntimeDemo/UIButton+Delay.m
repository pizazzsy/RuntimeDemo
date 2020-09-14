//
//  UIButton+Delay.m
//  RuntimeDemo
//
//  Created by 承启通 on 2020/9/11.
//  Copyright © 2020 承启通. All rights reserved.
//

#import "UIButton+Delay.h"
#import <objc/runtime.h>
@interface UIButton()

// 重复点击间隔
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;
// 上一次点击时间戳
@property (nonatomic, assign) NSTimeInterval acceptEventTime;

@end

@implementation UIButton (Delay)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(mySendAction:to:forEvent:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    // 如果想要设置统一的间隔时间，可以在此处加上以下几句
    if (self.acceptEventInterval <= 0) {
        // 如果没有自定义时间间隔，则默认为 0.4 秒
        self.acceptEventInterval = 4;
    }
    
    // 是否小于设定的时间间隔
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.acceptEventTime >= self.acceptEventInterval);
    
    // 更新上一次点击时间戳
    if (self.acceptEventInterval > 0) {
        self.acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
    if (needSendAction) {
        [self mySendAction:action to:target forEvent:event];
    }
}

- (NSTimeInterval )acceptEventInterval{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval{
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )acceptEventTime{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}

- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime{
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
