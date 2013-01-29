//
//  AppDelegate.h
//  iPersonalCalls
//
//  Created by Massimo Scalia on 04/11/12.
//  Copyright (c) 2012 com.hacaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController,SettingsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

 NSString *prefisso_ok ;
 NSString *saltamessaggio_ok;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic, retain) NSString *prefisso_ok ;
@property (nonatomic, retain) NSString *destinatario_ok ;
@property (nonatomic, retain) NSString *fax_sms ;
@property (nonatomic, retain) NSString *sms_anonimo ;
@property (nonatomic, retain) NSString *salta_messaggio_ok ;
@property (nonatomic) BOOL is5 ;

@end
