//
//  ViewController.m
//  内存管理
//
//  Created by YeYiFeng on 2018/3/30.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "ViewController.h"
#import "person.h"
typedef void (^block)(NSInteger age);
@interface ViewController ()
@property(nonatomic,copy)block myBlcok;

@end

@implementation ViewController

/*
 1.内存管理： 房间的开灯关灯
生成并持有对象 alloc/new/copy/mutablecopy
持有对象        retain
释放对象        release
废弃对象        delloc
 

 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    id object = [[NSObject alloc]init]; //自己生成对象，自己持有
//    id object1 = [NSObject new];
    //copy方法基于NSCopying的协议，各类实现copyWithZone生成持有对象的副本，mutablecopy同理
    // copy生成不可更改的对象，mutablecopy生成可变更的对象
    /*
     1.无法释放非自己持有的对象
     [object release];//释放对象
     [object release]; //释放之后再次释放非自己持有的对象 崩溃
     */
    /*
     autorelease
     autorelease会像c语言的自动变量那样对待对象实例，超出作用域时，对象实例的release实例方法被调用
     使用方法
     
     1.生成持有NSAutoreleasePool对象
     2.调用分配对象的autorelease实例方法
     3.废弃NSAutoreleasePool对象
     //    [self doSomething];
     //    [self doSomethingWithPool];
     */

//    __strong  强引用
//    __weak
//    __unsafe_unretained 和__weak差大致相同
    //    __autoreleasing 表示在autorelease pool中自动释放对象的引用，和MRC时代autorelease的用法相同。定义property时不能使用这个修饰符，任何一个对象的property都不应该是autorelease型的 NSError *__autoreleasing error;

//@property(nonatomic,copy)block myBlcok;  使用copy修饰，block是在栈区的，使用copy可以把它放到堆区
//    用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？
    
//    答：用@property声明 NSString、NSArray、NSDictionary 经常使用copy关键字，是因为他们有对应的可变类型：NSMutableString、NSMutableArray、NSMutableDictionary，他们之间可能进行赋值操作，为确保对象中的字符串值不会无意间变动，应该在设置新属性值时拷贝一份。
//    如果我们使用是strong,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性。
//    copy此特质所表达的所属关系与strong类似。然而设置方法并不保留新值，而是将其“拷贝” (copy)。 当属性类型为NSString时，经常用此特质来保护其封装性，因为传递给设置方法的新值有可能指向一个NSMutableString类的实例。这个类是NSString的子类，表示一种可修改其值的字符串，此时若是不拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。所以，这时就要拷贝一份“不可变” (immutable)的字符串，确保对象中的字符串值不会无意间变动。只要实现属性所用的对象是“可变的” (mutable)，就应该在设置新属性值时拷贝一份。
    
//    4.runloop、autorelease pool以及线程之间的关系。
//    每个线程(包含主线程)都有一个Runloop。对于每一个Runloop，系统会隐式创建一个Autorelease pool，这样所有的release pool会构成一个像callstack(调用堆栈)一样的一个栈式结构，在每一个Runloop结束时，当前栈顶的Autorelease pool会被销毁，这样这个pool里的每个Object会被release。
//    5.@property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的。
    
//    “属性”(property)有两大概念：ivar(实例变量)、存取方法(access method=getter)，即@property = ivar + getter + setter。

//    6.分别写一个setter方法用于完成@property (nonatomic,retain)NSString *name和@property (nonatomic,copy) NSString *name
//    retain属性的setter方法是保留新值并释放旧值，然后更新实例变量，令其指向新值。顺序很重要。假如还未保留新值就先把旧值释放了，而且两个值又指向同一个对象，先执行的release操作就可能导致系统将此对象永久回收。
    /*
     -(void)setName:(NSString *)name
     {
     [name retain];
     [_name release];
     _name = name;
     }
     -(void)setName:(NSString *)name
     {
     
     [_name release];
     _name = [name copy];
     }
     */
//    7.说说assign vs weak，__block vs __weak的区别
//
//    assign适用于基本数据类型，weak是适用于NSObject对象，并且是一个弱引用。
//
//    assign其实页可以用来修饰对象，那么为什么不用它呢？因为被assign修饰的对象在释放之后，指针的地址还是存在的，也就是说指针并没有被置为nil。如果在后续内存分配中，刚才分到了这块地址，程序就会崩溃掉。而weak修饰的对象在释放之后，指针地址会被置为nil。
//
//    __block是用来修饰一个变量，这个变量就可以在block中被修改。
//
//__block:使用__block修饰的变量在block代码块中会被retain(ARC下，MRC下不会retain)
//
//__weak:使用__weak修饰的变量不会在block代码块中被retain
    
    // 产生很多临时变量
    //9.请问下面代码是否有问题，如有问题请修改？
    //@autoreleasepool {
    //    NSString *str = [[NSString alloc] init];
    //    [str retain];
    //    [str retain];
    //    str = @"jxl";
    //    [str release];
    //    [str release];
    //    [str release];
    //}
    //这道题跟第8题一样存在内存泄露问题，1.内存泄露 2.指向常量区的对象不能release。
    //
    //指针变量str原本指向一块开辟的堆区空间，但是经过重新给str赋值，str的指向发生了变化，由原来指向堆区空间，到指向常量区。常量区的变量根本不需要释放，这就导致了原来开辟的堆区空间没有释放，照成内存泄露。
    
    
    
    //11.内存管理语义(assign、strong、weak等的区别)
    //
    //assign “设置方法” 只会执行针对“纯量”的简单赋值操作。
    //
    //strong  此特质表明该属性定义了一种“拥有关系”。为这种属性设置新值时，设置方法会先保留新值，并释放旧值，然后再将新值设置上去。
    //
    //weak 此特质表明该属性定义了一种“非拥有关系”。为这种属性设置新值时，设置方法既不保留新值，也不释放旧值。此特质同assign类似，然而在属性所指的对象遭到推毁时，属性值也会清空。
    //
    //unsafe_unretained  此特质的语义和assign相同，但是它适用于“对象类型”，该特质表达一种“非拥有关系”，当目标对象遭到推毁时，属性值不会自动清空，这一点与weak有区别。
    //
    //copy 此特质所表达的所属关系与strong类似。然而设置方法并不保留新值，而是设置方法并不保留新值，而是将其“拷贝”。当属性类型为NSString*时，经常用此特质来保护其封装性，因为传递给设置方法的新值有可能指向一个NSMutableString类的实例。这个类是NSString的子类，表示一种可以修改其值的字符串，此时若是不拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。所以，这时就要拷贝一份“不可变”的字符串，确保对象中的字符串值不会无意间变动。只要实现属性所用的对象是“可变的”，就应该在设置新属性值时拷贝一份。
    [self somethingWithBlock];
}

-(void)somethingWithBlock
{
    /*
     void (^block1)(void) = ^(void)
     {
     NSLog(@"-- 执行block1 --");
     };
     block1();
     
     void (^block2)(int a, int b )=^(int a,int b)
     {
     NSLog(@"%d%d",a,b);
     };
     block2(2,3);
     
     int (^block3)(int ,int )= ^(int a,int b)
     {
     return a+b;
     };
     int a = block3(4,5);
     NSLog(@"block3 - %d",a );
     */
#pragma mark - block 访问外部变量
    /*
     int b = 10;
     void (^block4)(void)=^(void){
     NSLog(@"block4%d",b);// 10
     //对于 block 外的变量引用，block 默认是将其复制到其数据结构中来实现访问的。也就是说block的自动变量截获只针对block内部使用的自动变量, 不使用则不截获, 因为截获的自动变量会存储于block的结构体内部, 会导致block体积变大。特别要注意的是默认情况下block只能访问不能修改局部变量的值。
     };
     b = 100;
     NSLog(@"block外部%d",b); // 100
     block4();
     */
#pragma mark - block __block修饰外部变量
   __block int b = 10;
    void (^block4)(void)=^(void){
        NSLog(@"block4%d",b);// 100
        //block 是复制其引用地址来实现访问的。block可以修改__block 修饰的外部变量的值。
    };
    b = 100;
    block4();
    
#pragma mark - block存储区域
    /*
     1.其实，block有三种类型：
     全局块(_NSConcreteGlobalBlock)   全局内部 相当于单例
     栈块(_NSConcreteStackBlock)      堆内存中，是一个带引用计数的对象，需要自行管理内存
     堆块(_NSConcreteMallocBlock)     栈 超出作用域立马销毁
     2.查看block的位置
     1）Block不访问外界变量（包括栈中和堆中的变量）
     Block 既不在栈又不在堆中，在代码段中，ARC和MRC下都是如此。此时为全局块。
     （2）Block访问外界变量
     MRC 环境下：访问外界变量的 Block 默认存储栈中。
     ARC 环境下：访问外界变量的 Block 默认存储在堆中（实际是放在栈区，然后ARC情况下自动又拷贝到堆区），自动释放。
     3.ARC下，访问外界变量的 Block为什么要自动从栈区拷贝到堆区呢？
     为了解决栈块在其变量作用域结束之后被废弃（释放）的问题，我们需要把Block复制到堆中，延长其生命周期。开启ARC时，大多数情况下编译器会恰当地进行判断是否有需要将Block从栈复制到堆，如果有，自动生成将Block从栈上复制到堆上的代码。Block的复制操作执行的是copy实例方法。Block只要调用了copy方法，栈块就会变成堆块。
     
     此时我们在block内部访问val变量则需要通过一个叫__forwarding的成员变量来间接访问val变量(下面会对__forwarding进行详解)
     
     执行copy实例方法手
     
     类型                             存储区域       复制结果
     全局块(_NSConcreteGlobalBlock)   全局内部       什么也不做
     栈块(_NSConcreteStackBlock)      堆内存中       引用技术增加
     堆块(_NSConcreteMallocBlock)     栈            从栈复制到堆
     
     __block变量与__forwarding
     通过__forwarding, 无论是在block中还是 block外访问__block变量, 也不管该变量在栈上或堆上, 都能顺利地访问同一个__block变量。
     
     */
    
    
}

-(void)doSomething
{
    NSMutableArray *collection = @[].mutableCopy;
    // 10e6 10*10的6次方
    for (int i = 0; i < 10e6; ++i) {
        NSString *str = [NSString stringWithFormat:@"hi + %d", i];
        [collection addObject:str];
    }
    // 内存最高飚到590M
    NSLog(@"finished!");
}
// 使用autoreleasepool
-(void)doSomethingWithPool
{
    NSMutableArray * collection = @[].mutableCopy;
    for (int i =0; i<10e6; i++) {
        @autoreleasepool
        {
            NSString *str = [NSString stringWithFormat:@"hi + %d", i];
            [collection addObject:str];
        }
    }
    // 内存最高飚到340
     NSLog(@"finished!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
