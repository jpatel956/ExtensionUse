//
//  LoginViewController.h
//  ExtensionUse
//
//  Created by Jatin Patel on 4/15/15.
//  Copyright (c) 2015 RetachSys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    __weak IBOutlet UIButton* btnAction;
    __weak IBOutlet UITextField* txtUserName;
    __weak IBOutlet UITextField* txtPassword;
}
-(IBAction)btnLoginClick:(id)sender;
@end
