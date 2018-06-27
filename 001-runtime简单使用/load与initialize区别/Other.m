//
//  Other.m
//  001-runtime简单使用
//
//  Created by safiri on 2018/6/27.
//  Copyright © 2018年 com.egintra. All rights reserved.
//

#import "Other.h"

@implementation Other

+ (void)load {
    NSLog(@"%@ , %s", [self class], __FUNCTION__);
}

@end
