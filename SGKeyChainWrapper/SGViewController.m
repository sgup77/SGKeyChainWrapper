//
//  SGViewController.m
//  SGKeyChainWrapper
//
//  Created by Sourav on 02/09/14.
//  Copyright (c) 2014 com.sourav.gupta. All rights reserved.
//


#define MINCHARMESSAGE @"Minimum length Should be at least 6 characters for Username and Password"
#define EMAILERRORMESSAGE @"Please correct your email"
#define FILLALLFIELDS @"Please fill all the fields"


#import "SGViewController.h"
#import "SGSecondViewController.h"
#import "SGHelper.h"
#import "SGKeyChain.h"

@interface SGViewController ()<UITextFieldDelegate>{
    IBOutlet UITextField *userName;
    IBOutlet UITextField *emailId;
    IBOutlet UITextField *password;
}

-(IBAction)nextBtnClicked:(id)sender;


@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Details";
    
    // Setting the delegate
    userName.delegate = self;
    emailId.delegate = self;
    password.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

-(void)showAlertView:(NSString* )errorMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma
#pragma IBAction Methods

-(IBAction)nextBtnClicked:(id)sender{
    
    NSString *parsedEmail = [SGHelper removeSpaceCharactersFromStart:[emailId text]];
    NSString *parsedUserName = [SGHelper removeSpaceCharactersFromStart:[userName text]];
    NSString *parsedPassword = [SGHelper removeSpaceCharactersFromStart:[password text]];
    
    if ([parsedEmail isEqualToString:@""] || (parsedEmail == nil) || [parsedUserName isEqualToString:@""] || !parsedUserName || [parsedPassword isEqualToString:@""] || !parsedPassword) {
        [self showAlertView:FILLALLFIELDS];
        return;
    }
    if ([parsedPassword length] < 6 || [parsedUserName length] < 6) {
        [self showAlertView:MINCHARMESSAGE];
        return;
    }
    
    if (![self validEmail:parsedEmail]) {
        [self showAlertView:EMAILERRORMESSAGE];
        return;
    };
    
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:[userName text] forKey:@"sgUserName"];
    [dataDict setObject:[emailId text] forKey:@"sgEmailId"];
    [dataDict setObject:[password text] forKey:@"sgPassword"];
    [[SGKeyChain defaultKeyChain] setDictionary:dataDict forKey:@"sgUserAccount"];
    
    
    
    ;
    
    
    SGSecondViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SGSecondViewController"];
    //[self presentViewController:controller animated:NO completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma
#pragma UITextFieldDelegate methods

/*- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
 BOOL shouldEnd = YES;
 
 if (textField == userName || textField == password) {
 NSString *parsedText = [SGHelper removeSpaceCharactersFromStart:[textField text]];
 
 if ([parsedText length] < 6) {
 shouldEnd = NO;
 [self showAlertView:MINCHARMESSAGE];
 }
 }
 
 return shouldEnd;
 }*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
