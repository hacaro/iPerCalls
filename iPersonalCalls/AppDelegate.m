//
//  AppDelegate.m
//  iPersonalCalls
//
//  Created by Massimo Scalia on 04/11/12.
//  Copyright (c) 2012 com.hacaro. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize prefisso_ok;
@synthesize destinatario_ok;
@synthesize fax_sms;
@synthesize sms_anonimo;
@synthesize salta_messaggio_ok;
@synthesize is5;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 1136){
            
            is5 = YES ;
            
            self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            self.window.rootViewController = self.viewController;
            [self.window makeKeyAndVisible];
            
        }
        
        else {
            
            is5 = NO;
        
            self.viewController = [[ViewController alloc] initWithNibName:@"ViewController4" bundle:nil];
            self.window.rootViewController = self.viewController;
            [self.window makeKeyAndVisible];

        }

    }
    
    
    return YES;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
    

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
