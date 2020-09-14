//
//  PartThreeViewController.m
//  RuntimeDemo
//
//  Created by 承启通 on 2020/9/10.
//  Copyright © 2020 承启通. All rights reserved.
//

#import "PartThreeViewController.h"
#include "objc/runtime.h"
@interface PersonOne : NSObject

- (void)fun;

@end

@implementation PersonOne

- (void)fun {
    NSLog(@"fun");
}

@end

@interface PartThreeViewController ()

@end

@implementation PartThreeViewController
/**
  消息重定向
 如果经过消息动态解析、消息接受者重定向，Runtime 系统还是找不到相应的方法实现而无法响应消息，Runtime 系统会利用 -methodSignatureForSelector: 或者 +methodSignatureForSelector: 方法获取函数的参数和返回值类型。

 如果 methodSignatureForSelector: 返回了一个 NSMethodSignature 对象（函数签名），Runtime 系统就会创建一个 NSInvocation 对象，并通过 forwardInvocation: 消息通知当前对象，给予此次消息发送最后一次寻找 IMP 的机会。
 如果 methodSignatureForSelector: 返回 nil。则 Runtime 系统会发出 doesNotRecognizeSelector: 消息，程序也就崩溃了。
 所以我们可以在 forwardInvocation: 方法中对消息进行转发。

 注意：类方法和对象方法消息转发第三步调用的方法同样不一样。
 类方法调用的是：

 + methodSignatureForSelector:
 + forwardInvocation:
 + doesNotRecognizeSelector:
 对象方法调用的是：

 - methodSignatureForSelector:
 - forwardInvocation:
 - doesNotRecognizeSelector:
 用到的方法：
 // 获取类方法函数的参数和返回值类型，返回签名
 + (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;

 // 类方法消息重定向
 + (void)forwardInvocation:(NSInvocation *)anInvocation；

 // 获取对象方法函数的参数和返回值类型，返回签名
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;

 // 对象方法消息重定向
 - (void)forwardInvocation:(NSInvocation *)anInvocation；
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 执行 fun 函数
    [self performSelector:@selector(fun)];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"防止重复点击按钮" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(50, 50, 50, 50)];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [Btn sendAction:@selector(btnClick:) to:self forEvent:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}
-(void)btnClick:(id)sender{
    NSLog(@"点击按钮");
}
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolveInstanceMethod");
    return YES; // 返回yes则可以进行消息接受者重定向
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector");
    return nil; // 返回nil则进行消息重定向
}

// 获取函数的参数和返回值类型，返回签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"methodSignatureForSelector");
    if ([NSStringFromSelector(aSelector) isEqualToString:@"fun"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

// 消息重定向
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation");
    SEL sel = anInvocation.selector;   // 从 anInvocation 中获取消息
    PersonOne *p = [[PersonOne alloc] init];
    if([p respondsToSelector:sel]) {   // 判断 Person 对象方法是否可以响应 sel
        [anInvocation invokeWithTarget:p];  // 若可以响应，则将消息转发给其他对象处理
    } else {
        [self doesNotRecognizeSelector:sel];  // 若仍然无法响应，则报错：找不到响应方法
    }
}
/**
 可以看到，我们在 -forwardInvocation: 方法里面让 Person 对象去执行了 fun 函数。

 既然 -forwardingTargetForSelector: 和 -forwardInvocation: 都可以将消息转发给其他对象处理，那么两者的区别在哪？

 区别就在于 -forwardingTargetForSelector: 只能将消息转发给一个对象。而 -forwardInvocation: 可以将消息转发给多个对象。

 */

@end
