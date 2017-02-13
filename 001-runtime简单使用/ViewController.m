//
//  ViewController.m
//  001-runtime简单使用
//
//  Created by safiri on 2017/1/23.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"
#import "NSObject+Property.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //要知道Person这个类的属性有几个？
    
    //拷贝出成员属性列表
    //第一个参数：就是一个类的类型 NSClassFromString(字符串) objc_getClass(C字符)
    //第二个参数 int * -> 指向int类型变量的指针
    
    //unsigned int age = 10;
    //unsigned int * count = &age;
    unsigned int count = 0;
    //拷贝出所有成语变量
    Ivar *ivars = class_copyIvarList(NSClassFromString(@"Person"), &count);
    NSLog(@"count = %d",count);
    //遍历ivars中的成员属性
    //for遍历 循环次数为count
    for (int i=0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * cName = ivar_getName(ivar);
        NSString *ocName = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSLog(@"ocName = %@",ocName);
    }
    
    [self getList];
    
    [self exchangeMethod];
    [self addAssociatedObject];
    [self addMethod];
}

- (IBAction)save:(id)sender {
    Person *p = [[Person alloc] init];
    p.name = @"张三";
    p.age = 22;
//    p.height = 78.0;
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"archive.data"];
    [NSKeyedArchiver archiveRootObject:p toFile:path];
    //这里要注意的是每次归档时归档的整个对象，如果不设置某个属性，那么以前存储的那个属性的值会被清除，变成默认值。
    
}
- (IBAction)read:(id)sender {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"archive.data"];
    Person *p = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"p.name = %@",p.name);
    NSLog(@"height = %f",p.height);
    NSLog(@"age = %zd",p.age);
}

//获取列表
- (void)getList{
    unsigned int count;
    
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([Person class], &count);
    for (unsigned int i=0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        NSLog(@"property ----> %@",[NSString stringWithUTF8String:propertyName]);
    }
    
    //获取方法列表
    Method *methodList = class_copyMethodList([Person class], &count);
    for (unsigned int i=0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"method----> %@",NSStringFromSelector(method_getName(method)));
    }
    //获取成员变量列表
    Ivar *ivars = class_copyIvarList([Person class], &count);
    for (unsigned int i=0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * ivarName = ivar_getName(ivar);
        NSLog(@"Ivar ----> %@",[NSString stringWithUTF8String:ivarName]);
    }
    
    //获取协议列表
    __unsafe_unretained Protocol ** protocolList = class_copyProtocolList([Person class], &count);
    for (unsigned int i; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
}

- (void)exchangeMethod{
    // 需求：给imageNamed方法提供功能，每次加载图片就判断下图片是否加载成功。
    // 步骤一：先搞个分类，定义一个能加载图片并且能打印的方法+ (instancetype)imageWithName:(NSString *)name;
    // 步骤二：交换imageNamed和imageWithName的实现，就能调用imageWithName，间接调用imageWithName的实现。
    UIImage *image = [UIImage imageNamed:@"123"];
}
- (void)addAssociatedObject{
    // 给系统NSObject类动态添加属性name
    NSObject *objc = [[NSObject alloc] init];
    objc.name = @"小马哥";
    NSLog(@"%@",objc.name);
}
- (IBAction)alert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认要删除这个宝贝" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    // 传递多参数
    objc_setAssociatedObject(alert, "suppliers_id", @"1", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(alert, "warehouse_id", @"2", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    alert.tag = 34;
    [alert show];
}
- (void)addMethod{
    Person *p = [[Person alloc] init];
    
    // 默认person，没有实现eat方法，可以通过performSelector调用，但是会报错。
    // 动态添加方法就不会报错
    [p performSelector:@selector(eat)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
@end
