//
//  PartOneViewController.m
//  RuntimeDemo
//
//  Created by 承启通 on 2020/9/10.
//  Copyright © 2020 承启通. All rights reserved.
//

#import "PartOneViewController.h"
#include "objc/runtime.h"

@interface PartOneViewController ()

@end

@implementation PartOneViewController
/*
消息动态解析
Objective-C 运行时会调用 +resolveInstanceMethod: 或者 +resolveClassMethod:，让你有机会提供一个函数实现。前者在 对象方法未找到时 调用，后者在 类方法未找到时 调用。我们可以通过重写这两个方法，添加其他函数实现，并返回 YES， 那运行时系统就会重新启动一次消息发送的过程。

**/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 执行 fun 函数
    [self performSelector:@selector(fun)];
}

// 重写 resolveInstanceMethod: 添加对象方法实现
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolveInstanceMethod");
    if (sel == @selector(fun)) { // 如果是执行 fun 函数，就动态解析，指定新的 IMP
        class_addMethod([self class], sel, (IMP)funMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void funMethod(id obj, SEL _cmd) {
    NSLog(@"funMethod"); //新的 fun 函数
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
