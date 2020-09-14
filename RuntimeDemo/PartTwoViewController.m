//
//  PartTwoViewController.m
//  RuntimeDemo
//
//  Created by 承启通 on 2020/9/10.
//  Copyright © 2020 承启通. All rights reserved.
//

#import "PartTwoViewController.h"
#include "objc/runtime.h"

@interface Person : NSObject

- (void)fun;

@end

@implementation Person

- (void)fun {
    NSLog(@"fun");
}

@end


@interface PartTwoViewController ()

@end

@implementation PartTwoViewController
/*
 消息接受者重定向
 如果上一步中 +resolveInstanceMethod: 或者 +resolveClassMethod: 没有添加其他函数实现，运行时就会进行下一步：消息接受者重定向。

 如果当前对象实现了 -forwardingTargetForSelector: 或者 +forwardingTargetForSelector: 方法，Runtime 就会调用这个方法，允许我们将消息的接受者转发给其他对象。

 其中用到的方法：

 // 重定向类方法的消息接收者，返回一个类或实例对象
 + (id)forwardingTargetForSelector:(SEL)aSelector;
 // 重定向方法的消息接收者，返回一个类或实例对象
 - (id)forwardingTargetForSelector:(SEL)aSelector;
 注意：

 类方法和对象方法消息转发第二步调用的方法不一样，前者是+forwardingTargetForSelector: 方法，后者是 -forwardingTargetForSelector: 方法。
 这里+resolveInstanceMethod: 或者 +resolveClassMethod:无论是返回 YES，还是返回 NO，只要其中没有添加其他函数实现，运行时都会进行下一步。


 **/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 执行 fun 方法
       [self performSelector:@selector(fun)];
}
//动态方法决议
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolveInstanceMethod");
    return YES; // 返回yes则可以进行消息接受者重定向
}

// 消息接受者重定向
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector");
    if (aSelector == @selector(fun)) {
        return [[Person alloc] init];
        // 返回 Person 对象，让 Person 对象接收这个消息
    }
    
    return [super forwardingTargetForSelector:aSelector];
}
/**
 可以看到，虽然当前 ViewController 没有实现 fun 方法，+resolveInstanceMethod: 也没有添加其他函数实现。但是我们通过 forwardingTargetForSelector 把当前 ViewController 的方法转发给了 Person 对象去执行了。打印结果也证明我们成功实现了转发。

我们通过 forwardingTargetForSelector 可以修改消息的接收者，该方法返回参数是一个对象，如果这个对象是不是 nil，也不是 self，系统会将运行的消息转发给这个对象执行。否则，继续进行下一步：消息重定向流程。
*/

@end
