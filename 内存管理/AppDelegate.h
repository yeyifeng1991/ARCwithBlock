//
//  AppDelegate.h
//  内存管理
//
//  Created by YeYiFeng on 2018/3/30.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

