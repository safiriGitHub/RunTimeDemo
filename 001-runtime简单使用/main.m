//
//  main.m
//  001-runtime简单使用
//
//  Created by safiri on 2017/1/23.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Child.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        Child *child = [[Child alloc] init];
        NSLog(@"%@",child);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
    }
}
