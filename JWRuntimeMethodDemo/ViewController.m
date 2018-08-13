//
//  ViewController.m
//  JWRuntimeMethodDemo
//
//  Created by JessieWu on 2018/8/13.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "ViewController.h"

#import "JWFriend.h"

#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //get all methods
    [self getAllMethods:[self class]];
    
    [self performSelector:@selector(sayHello) withObject:nil afterDelay:10.0f];
}

#pragma mark - UI
- (void)setupUI {
    NSLog(@"%s", __func__);
}

#pragma mark - override methods
//3.消息转发 可以挽回查无此函数异常的最后一步：在实际应用中要实现该函数的调起 必须要重写methodSignatureForSelector:
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = anInvocation.selector;
    JWFriend *friend = [JWFriend new];
    if ([friend respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:friend];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

//1.objc_msgSend 在searchMethod找不到SEL后，首先尝试在这里解决
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel_isEqual(sel, @selector(sayHello))) {
//        ViewController *vc = [ViewController new];
//        [vc insteadSayHello];
//        return YES;
//    }
//
//    return NO;
//}

//2.在上一步resloveInstanceMethod: or resloveClassMethod: return NO，会进入该函数查询SEL；在该函数未有结果后，正式进入objc_sendForword消息转发
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSLog(@"%s", __func__);
//    NSMethodSignature *methodSign = [NSMethodSignature methodSignatureForSelector:aSelector];
//    return [NSInvocation invocationWithMethodSignature:methodSign];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(sayHello))) {
        NSMethodSignature *methodSignature = [[JWFriend new] methodSignatureForSelector:aSelector];
        return methodSignature;
    }
    return [super methodSignatureForSelector:aSelector];
}

#pragma mark - private methods
- (void)getAllMethods:(Class)class {
    Class currentClass = class;
    while ([currentClass isEqual:[self class]]) {
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        unsigned int i = 0;
        for (; i < methodCount; i++) {
            NSLog(@"%@ - %@", [NSString stringWithCString:class_getName(currentClass) encoding:NSUTF8StringEncoding], [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding]);
        }
        currentClass = self.superclass;
    }
}

- (void)insteadSayHello {
    NSLog(@"%s", __func__);
}

#pragma mark - selector methods
//- (void)sayHello {
//    NSLog(@"%s", __func__);
//}

@end
