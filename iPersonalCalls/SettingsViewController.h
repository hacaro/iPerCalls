//
//  SettingsViewController.h
//  iPersonalCalls
//
//  Created by Massimo Scalia on 11/11/12.
//  Copyright (c) 2012 com.hacaro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTextFieldNumberPad.h"


@interface SettingsViewController : UIViewController


@property (nonatomic) IBOutlet AMTextFieldNumberPad *prefix;
@property (strong, nonatomic) IBOutlet UITextField *suffix;
@property (strong, nonatomic) IBOutlet UITextField *fax_sms;
@property (strong, nonatomic) IBOutlet AMTextFieldNumberPad *destinatario;
@property (strong, nonatomic) IBOutlet UITextField *salta_messaggio;

- (IBAction)BackAndSave:(id)sender;


@end

