//
//  JWFriend.m
//  JWRuntimeMethodDemo
//
//  Created by JessieWu on 2018/8/13.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "JWFriend.h"

@implementation JWFriend

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSign = [super methodSignatureForSelector:aSelector];
    if (!methodSign) {
        methodSign = [NSMethodSignature methodSignatureForSelector:aSelector];
    }
    return methodSign;
}

- (void)sayHello {
    NSLog(@"%s", __func__);
}
@end
