//
//  Parent+Load.m
//  001-runtime简单使用
//
//  Created by safiri on 2018/6/27.
//  Copyright © 2018年 com.egintra. All rights reserved.
//

#import "Parent+Load.h"

@implementation Parent (Load)

+ (void)load {
    NSLog(@"%@ , %s", [self class], __FUNCTION__);
}

@end
