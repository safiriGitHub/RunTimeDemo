//
//  Person.h
//  001-runtime简单使用
//
//  Created by safiri on 2017/1/23.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (nonatomic ,assign)float height;
@property (nonatomic ,assign)int age;
@property (nonatomic ,copy)NSString *name;
@end
