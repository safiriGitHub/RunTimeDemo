# RunTimeDemo

###Demo内容

![runtime应用](http://upload-images.jianshu.io/upload_images/838624-9286f643b6d25393.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### NSObject+PropertyListing 分类介绍

```
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
```
