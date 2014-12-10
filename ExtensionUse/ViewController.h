//
//  ViewController.h
//  ExtensionUse
//
//  Created by ind556 on 12/9/14.
//  Copyright (c) 2014 RetachSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController : UIViewController
{
    __weak IBOutlet UIButton* btnAction;
    __weak IBOutlet UITextField* txtUserName;
    __weak IBOutlet UITextField* txtPassword;
}
-(IBAction)btnActionClick:(id)sender;
@end
