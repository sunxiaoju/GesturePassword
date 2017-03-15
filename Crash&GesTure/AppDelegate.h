//
//  AppDelegate.h
//  Crash&GesTure
//
//  Created by chedao on 17/3/14.
//  Copyright © 2017年 chedao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

