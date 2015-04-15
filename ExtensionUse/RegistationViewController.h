//
//  RegistationViewController.h
//  ExtensionUse
//
//  Created by Jatin Patel on 4/15/15.
//  Copyright (c) 2015 RetachSys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistationViewController : UIViewController
{
    __weak IBOutlet UIButton* btnAction;
     IBOutlet UITextField* txtUserName;
     IBOutlet UITextField* txtPassword;
     IBOutlet UITextField* txtDescription;
}
-(IBAction)btnRegistationClick:(id)sender;
@end
