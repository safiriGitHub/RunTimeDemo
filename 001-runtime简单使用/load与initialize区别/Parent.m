//
//  Parent.m
//  001-runtime简单使用
//
//  Created by safiri on 2018/6/27.
//  Copyright © 2018年 com.egintra. All rights reserved.
//

#import "Parent.h"

/*
 +load方法是当类或者分类被加载和初始化的时候时调用
 下面通过一个demo验证一下+load方法的调用顺序。
 */
@implementation Parent

+ (void)load {
    NSLog(@"%@, %s",[self class], __FUNCTION__);
}

+ (void)initialize {
    if (self == [Parent class]) {
        NSLog(@"%@ , %s", [self class], __FUNCTION__);
    }
}
@end
