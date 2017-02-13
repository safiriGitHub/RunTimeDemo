//
//  NSObject+Property.h
//  001-runtime简单使用
//
//  Created by safiri on 2017/2/4.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)
//@property (nonatomic ,copy)NSString *name;
- (NSString *)name;
- (void)setName:(NSString *)name;
@end
