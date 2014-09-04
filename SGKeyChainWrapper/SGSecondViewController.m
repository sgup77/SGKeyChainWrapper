//
//  SGSecondViewController.m
//  SGKeyChainWrapper
//
//  Created by Sourav on 02/09/14.
//  Copyright (c) 2014 com.sourav.gupta. All rights reserved.
//

#import "SGSecondViewController.h"
#import "SGKeyChain.h"

@interface SGSecondViewController (){
    IBOutlet UILabel *userName;
    IBOutlet UILabel *emailID;
}

@end

@implementation SGSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"KeyChain";
    
    NSDictionary *userDict = [[SGKeyChain defaultKeyChain] dictionaryForKey:@"sgUserAccount"];
    userName.text = [userDict objectForKey:@"sgUserName"];
    emailID.text = [userDict objectForKey:@"sgEmailId"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
