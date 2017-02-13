//
//  Person.m
//  001-runtime简单使用
//
//  Created by safiri on 2017/1/23.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface Person ()
@property (nonatomic ,assign)int age1;
@end

@implementation Person

//如果属性太多，使用传统的归档解档写的代码会很多。
//使用 runTime 和 KVC 能够简单地实现。用到的时候直接复制即可：

- (void)encodeWithCoder:(NSCoder *)aCoder{
    /* 替换前
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeFloat:_height forKey:@"height"];
    [aCoder encodeInt:_age forKey:@"age"];
     ...
     */
    //取得对象的所有属性列表
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    //循环每个属性，并进行归档处理
    for (int i=0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //kvc取值
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    
    //在C语言里面 只要看到了 copy Creat New 就需要释放指针
    free(ivars);
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
         /* 替换前
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntForKey:@"age"];
        self.height = [aDecoder decodeFloatForKey:@"height"];
        ...
        */
        unsigned int count = 0;
        Ivar * ivars = class_copyIvarList([self class], &count);
        //循环每个属性，并进行解档处理
        for (int i=0; i < count; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            //kvc赋值
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
        free(ivars);
    }
    return self;
}

//void (*)()
//默认方法都有两个隐式参数
void eat(id self, SEL sel){
    NSLog(@"%@ %@",self,NSStringFromSelector(sel));
}
//- (void)eat{
//    NSLog(@"ewew");
//}
// 当一个对象调用未实现的方法，会调用这个方法处理,并且会把对应的方法列表传过来.
// 刚好可以用来判断，未实现的方法是不是我们想要动态添加的方法

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if ([NSStringFromSelector(sel) isEqualToString:@"eat"]) {
        // 动态添加eat方法
        
        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        //OC:
        //class_addMethod(self, sel, [self instanceMethodForSelector:@selector(eat)], "v@:");
        //C:
        class_addMethod(self, sel, (IMP)eat, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}

//runtime 实现字典转模型
+ (instancetype)modelWithDict:(NSDictionary *)dict{
    id objc = [[self alloc] init];
    // runtime:根据模型中属性,去字典中取出对应的value给模型属性赋值
    // 1.获取模型中所有成员变量 key
    // 获取哪个类的成员变量
    // count:成员变量个数
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
    //遍历所有成员变量
    for (int i=0 ; i < count; i++) {
        Ivar ivar = ivars[i];
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 获取成员变量名字
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // @"User" -> User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        //获取key 去除下划线
        NSString *key = [ivarName substringFromIndex:1];
        
        // 去字典中查找对应value
        // key:user  value:NSDictionary
        id value = dict[key];
        // 二级转换:判断下value是否是字典,如果是,字典转换层对应的模型
        // 并且是自定义对象才需要转换
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            // 字典转换成模型 userDict => User模型
            // 获取类
            Class modelClass = NSClassFromString(ivarType);
            value = [modelClass modelWithDict:value];
        }
        //给模型中属性赋值
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}
@end
