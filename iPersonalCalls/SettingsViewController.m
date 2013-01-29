//
//  SettingsViewController.m
//  iPersonalCalls
//
//  Created by Massimo Scalia on 11/11/12.
//  Copyright (c) 2012 com.hacaro. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"//;

@interface SettingsViewController ()

@end


@implementation SettingsViewController


@synthesize prefix ;
@synthesize suffix;
@synthesize destinatario;
@synthesize fax_sms;
@synthesize salta_messaggio;




// init and read the Settings.plist
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
    }
    return self;
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib
    
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
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    prefix.text = [temp objectForKey:@"prefisso"];
    destinatario.text  = [temp objectForKey:@"destinatario"];
    fax_sms.text = [temp objectForKey:@"fax_sms"];
    salta_messaggio.text = [temp objectForKey:@"salta_messaggio"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) doneButton:(id) sender

{
    //objNumberPad is the Keyboard
    [prefix resignFirstResponder];
    [destinatario resignFirstResponder];
    [fax_sms resignFirstResponder];
    [salta_messaggio resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [prefix resignFirstResponder];
    [destinatario resignFirstResponder];
    [fax_sms resignFirstResponder];
    [salta_messaggio resignFirstResponder];
}

- (IBAction)SaltaAnnuncio:(id)sender {
}

- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (IBAction)BackAndSave:(id)sender {

    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Settings.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
    [NSArray arrayWithObjects: prefix.text, destinatario.text,fax_sms.text,salta_messaggio.text, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"prefisso",
                                                @"destinatario",
                                                                   @"fax_sms",@"salta_messaggio",nil]];
    
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    
    AppDelegate *appdelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    appdelegate.prefisso_ok = prefix.text ;
    appdelegate.destinatario_ok = destinatario.text;
    appdelegate.fax_sms = fax_sms.text;
    appdelegate.salta_messaggio_ok = salta_messaggio.text;
    
     
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
