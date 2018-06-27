### +load方法调用顺序：

1、子类 +load 方法会在它所有父类的 +load 方法之后执行
2、分类 +load 方法会在它的主类的 +load 方法之后执行
3、不同的类之间的+load方法的调用顺序：由 Compile Sources 中，文件的引入的先后顺序决定
4、子类、父类和分类中的 +load 方法的实现是被区别对待的：如果子类没有实现 +load 方法，那么当它被加载和初始化的时候是不会去调用父类的 +load 方法的。同理，当一个类和它的分类都实现了+load方法时，两个方法都会被调用。

### +load黑魔法：

Method Swizzle:

```
@interface Child (Load)
@end

@implementation Child (Load)

+ (void)load {

Method originalFunc = class_getInstanceMethod([self class], @selector(originalFunc));
Method swizzledFunc = class_getInstanceMethod([self class], @selector(swizzledFunc));

method_exchangeImplementations(originalFunc, swizzledFunc);

}

@end

```

+load 
调用时机                                被添加到 runtime 时
调用顺序                                父类->子类->分类
调用次数                                1次    
是否需要显式调用父类实现    否
是否沿用父类的实现               否
分类中的实现                          类和分类都执行


### +initialize方法调用顺序

### +initialize黑魔法 

一般用于初始化全局变量或静态变量。

+initialize
调用时机                                    收到第一条消息前，可能永远不调用
调用顺序                                    父类->子类
调用次数                                    多次
是否需要显式调用父类实现        否
是否沿用父类的实现                   是
分类中的实现                              覆盖类中的方法，只执行分类的实现


+load和+initialize方法内部使用了锁，因此它们是线程安全的。
























