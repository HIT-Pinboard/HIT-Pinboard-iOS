//
//  AppDelegate.m
//  HIT Pinboard
//
//  Created by Yifei Zhou on 11/6/14.
//  Copyright (c) 2014 Yifei Zhou. All rights reserved.
//

#import "AppDelegate.h"
#import "PBManager.h"
#import <UIColor+FlatColors.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor flatBelizeHoleColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                           NSFontAttributeName: [UIFont fontWithName:@"" size:20.0f],
                                                           }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedError:) name:@"requestFailedWithError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSuccess:) name:@"userActionSuccess" object:nil];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge)];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[PBManager sharedManager] cacheAllObjects];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notifications

- (void)receivedError:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [JDStatusBarNotification showWithStatus:userInfo[@"error"] dismissAfter:3.0f styleName:JDStatusBarStyleError];
}

- (void)receivedSuccess:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [JDStatusBarNotification showWithStatus:userInfo[@"success"] dismissAfter:2.0f styleName:JDStatusBarStyleSuccess];
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[PBManager sharedManager] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"%@", error);
#endif
    [JDStatusBarNotification showWithStatus:[error localizedDescription] dismissAfter:2.0f styleName:JDStatusBarStyleError];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JDStatusBarNotification showWithStatus:@"您的订阅有更新啦" dismissAfter:2.0f styleName:JDStatusBarStyleSuccess];
}
@end
