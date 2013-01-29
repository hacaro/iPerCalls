//
//  ViewController.h
//  iPersonalCalls
//
//  Created by Massimo Scalia on 04/11/12.
//  Copyright (c) 2012 com.hacaro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AMTextFieldNumberPad.h"



@interface ViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate , UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *firstname;
@property (weak,nonatomic) NSString *numerook ;
@property( strong, nonatomic) IBOutlet UIButton *callbutton;
@property (strong, nonatomic) IBOutlet AMTextFieldNumberPad *numberinput;
@property (strong, nonatomic) IBOutlet UIView *SettingsView;


- (IBAction)ShowPicker:(id)sender;
- (IBAction)Call;
- (IBAction)CallEnterprise;
- (void)Callacarico;
- (IBAction)clear:(id)sender;

- (IBAction)ShowNumberPad:(id)sender;
- (IBAction)SwitchView:(id)sender;
-(IBAction)showActionSheet;
-(IBAction)showActionSheetSMS;
-(void)SendSMS ;
-(void)SendSMSEnterprise ;
-(void)SendSMSFax ;
-(void)SendSMSAnonimous ;

-(void)CheOperatore;

@end