//
//  ViewController.m
//  ExtensionUse
//
//  Created by ind556 on 12/9/14.
//  Copyright (c) 2014 RetachSys. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark +++++++++++++++++++ Custom methods +++++++++++++++++++++++
-(IBAction)btnActionClick:(id)sender{
    UIButton* btnTemp = (UIButton*)sender;
    if (btnTemp.tag==1) {
        [self performSegueWithIdentifier:@"registation" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}
@end

