//
//  NSObject+PropertyListing.m
//  Weschool
//
//  Created by safiri on 15/5/29.
//  Copyright (c) 2015年 soullon. All rights reserved.
//

#import "NSObject+PropertyListing.h"

@implementation NSObject (PropertyListing)

- (NSArray *)getAllProperties{
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    return propertiesArray;
}

- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

-(void)printMothList
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++)
    {
        Method temp_f = mothList_f[i];
        //IMP imp_f = method_getImplementation(temp_f);
        //SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,[NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}

- (void)dealWithNilValue{
    NSArray *propertys = [self getAllProperties];
    for (NSString *property in propertys) {
        id value = [self valueForKey:property];
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            [self setValue:@"" forKey:property];
        }
    }
}
- (void)dealNilWithValueStr:(NSString *)str{
    NSArray *propertys = [self getAllProperties];
    for (NSString *property in propertys) {
        id value = [self valueForKey:property];
        if ([AppHelpMethods isBlankString:value]) {
            [self setValue:str forKey:property];
        }
    }
}
@end
