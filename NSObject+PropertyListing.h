//
//  NSObject+PropertyListing.h
//  Weschool
//  遍历未知对象的属性和方法
//  Created by safiri on 15/5/29.
//  Copyright (c) 2015年 soullon. All rights reserved.
//

#import <Foundation/Foundation.h>
/* 注意：要先导入ObjectC运行时头文件，以便调用runtime中的方法*/
#import <objc/runtime.h>

@interface NSObject (PropertyListing)

/**
 * 获取对象的所有属性，不包括属性值
 */
- (NSArray *)getAllProperties;

/**
 * 获取对象的所有属性 以及属性值
 */
- (NSDictionary *)properties_aps;

/**
 * 获取对象的所有方法
 */
-(void)printMothList;

/** 处理含有的nil值
 */
- (void)dealWithNilValue;

/**
 处理nil值并替换为指定字符串
 
 @param str 指定字符串
 */
- (void)dealNilWithValueStr:(NSString *)str;

@end
