//
//  ViewController.m
//  iPersonalCalls
//
//  Created by Massimo Scalia on 04/11/12.
//  Copyright (c) 2012 com.hacaro. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"//;
#import "AMTextFieldNumberPad.h"//;


@interface ViewController ()

@end


@implementation ViewController


@synthesize numberinput ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [numberinput setButtonIcon:ButtonIconKeyboard];

	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Settings.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];

    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorDesc];
    
    
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %u", errorDesc, format);
    }
    
    NSString *prefisso = [temp objectForKey:@"prefisso"];
    NSString *destinatario = [temp objectForKey:@"destinatario"];
    NSString *fax = [temp objectForKey:@"fax_sms"];
    NSString *sms_anonimo = [temp objectForKey:@"sms_anonimo"];
    
    
    AppDelegate *appdelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    appdelegate.prefisso_ok = prefisso ;
    appdelegate.destinatario_ok = destinatario ;
    appdelegate.fax_sms = fax;
    appdelegate.sms_anonimo = sms_anonimo;
    }


- (IBAction)done:(id)sender {
    [self showActionSheet];

}

-(IBAction)clear:(id)sender {

    self.firstname.text = nil ;
}

-(void)doneButton{

    [numberinput resignFirstResponder];
    [self showActionSheet];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFirstname:nil];
    [self setNumberinput:nil];
    [self setCallbutton:nil];
    [self setSettingsView:nil];
    [super viewDidUnload];
    
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    return YES;
}


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier


{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    
    NSString* surname = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonLastNameProperty);
    
    NSString *nomecompleto = [[NSString alloc]initWithFormat:@"%@ %@",name,surname];
    
    if (name == nil) {
        self.firstname.text = surname ;
    }
    else if (surname ==nil){
    
    self.firstname.text =  name;
    }
    
    else {
    
        self.firstname.text =  nomecompleto;

    
    }
    
    
    if (property == kABPersonPhoneProperty) {
        ABMultiValueRef phone = ABRecordCopyValue(person, property);
        CFStringRef selectedNumber = ABMultiValueCopyValueAtIndex(phone, identifier);
        // insert code to do something with the values above
        self.numberinput.text = (__bridge NSString *)(selectedNumber);
        
        NSString *phoneok = [self.numberinput.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"];

        
        NSString *st = [phoneok stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        self.numberinput.text = st;


           }

    else {
    
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"attenzione" message:@"non hai selezionato un numero telefonico" delegate:(nil)cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
        [alert show];
        
    
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showActionSheet];

}



- (IBAction)ShowPicker:(id)sender {
    
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];

}





#pragma mark -
#pragma mark Creazione Action Sheet


//Action Sheet

-(IBAction)showActionSheet {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"iPerCalls" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Chiamata personale" otherButtonTitles:@"Chiamata Aziendale", @"Chiamata a Carico",@"Che operatore è ?", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    popupQuery.title = @"iPerCalls";
    [popupQuery showInView:self.view];

    
}

-(IBAction)showActionSheetSMS {

    UIActionSheet *popupQuerySMS = [[UIActionSheet alloc] initWithTitle:@"iPerSMS" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"SMS personale" otherButtonTitles:@"SMS Aziendale", @"SMS FAX", nil];
	popupQuerySMS.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuerySMS showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    
    if ([actionSheet.title isEqualToString:@"iPerCalls"]){
    
    switch (buttonIndex) {
        case 0:
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            [self Call];
            break;
        case 1:
            [ actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            [self CallEnterprise];     break;
        case 2:
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            [self Callacarico];     break;
        case 3:
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            [self CheOperatore];     break;
    }
       
    }
    
    else {
        
            switch (buttonIndex) {
                    case 0:
                        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
                        [self SendSMS];
                        break;
                    case 1:
                        [ actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
                        [self SendSMSEnterprise];     break;
                    case 2:
                        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
                        [self SendSMSFax];     break;
    
                    /*case 3:
                        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
                        [self SendSMSAnonimous];     break;*/

            }

    }
}

#pragma mark -
#pragma mark Chiamate e SMS

    
- (IBAction)Call {
    
    AppDelegate *delegato = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    NSString *stringa = @"tel:" ;
    NSString *salta = delegato.salta_messaggio_ok ;
    
    if (salta != NULL){
    NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@%@%@",stringa,delegato.prefisso_ok, self.numberinput.text,delegato.salta_messaggio_ok];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];

    }
    
    else {
        
        NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@%@",stringa,delegato.prefisso_ok, self.numberinput.text];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];
    
    }
    

}

- (IBAction)CallEnterprise{

    NSString *stringa = @"tel:" ;
    NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@",stringa,self.numberinput.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];
}


- (void)Callacarico{
    
    AppDelegate *delegato = (AppDelegate*) [[UIApplication sharedApplication]delegate];

    NSString *stringa = @"tel:" ;
    NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@%@",stringa,delegato.destinatario_ok,self.numberinput.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];
    
}



-(void)CheOperatore{

    NSString *stringa = @"tel:";
    NSString *operatore =@"456";
    NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@%@",stringa,operatore,self.numberinput.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];

}



- (void)SendSMS {
    
    AppDelegate *delegato = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    NSString *stringa = @"sms:" ;
    NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@%@",stringa,delegato.prefisso_ok, self.numberinput.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];
    
    
    
}


- (void)SendSMSAnonimous {
    
    AppDelegate *delegato = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    NSString *stringa = @"sms:" ;
    NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@%@",stringa,delegato.sms_anonimo, self.numberinput.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];
    
    
    
}


- (void)SendSMSEnterprise{
    
    NSString *stringa = @"sms:" ;
    NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@",stringa,self.numberinput.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];
}


- (void)SendSMSFax{
    
    AppDelegate *delegato =(AppDelegate*) [[UIApplication sharedApplication]delegate];
    
    NSString *stringa = @"sms:" ;
    NSString *numerocompleto = [[NSString alloc]initWithFormat:@"%@%@%@",stringa,delegato.fax_sms,self.numberinput.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numerocompleto]];
}




- (IBAction)ShowNumberPad:(id)sender {
	[numberinput setKeyboardType:UIKeyboardTypeNumberPad];
	[numberinput setButtonIcon:ButtonIconKeyboard];
    [numberinput becomeFirstResponder];

    self.firstname.text = nil;
}

- (IBAction)SwitchView:(id)sender {
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 1136){
            
            SettingsViewController *view=[[SettingsViewController alloc] initWithNibName:nil bundle:nil];
            view.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:view animated:YES completion:nil];
            
            
        }
        
        else {
            
            SettingsViewController *view=[[SettingsViewController alloc] initWithNibName:@"SettingsViewController4" bundle:nil];
            view.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:view animated:YES completion:nil];
        }
        
    }
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [numberinput resignFirstResponder];
    //[self showActionSheet];

}


@end
