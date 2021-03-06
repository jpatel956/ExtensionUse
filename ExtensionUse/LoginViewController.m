//
//  LoginViewController.m
//  ExtensionUse
//
//  Created by Jatin Patel on 4/15/15.
//  Copyright (c) 2015 RetachSys. All rights reserved.
//

#import "LoginViewController.h"
static NSString *const AppExtensionVersionNumberKey = @"version_number";
static NSString *const kUTTypeAppExtensionFindLoginAction = @"org.appextension.find-login-action";

#define AppExtensionURLStringKey                  @"url_string"

// Errors
#define AppExtensionErrorDomain                   @"ExtensionUse"

#define AppExtensionErrorCodeCancelledByUser                    0
#define AppExtensionErrorCodeAPINotAvailable                    1
#define AppExtensionErrorCodeFailedToContactExtension           2
#define AppExtensionErrorCodeFailedToLoadItemProviderData       3
#define AppExtensionErrorCodeCollectFieldsScriptFailed          4
#define AppExtensionErrorCodeFillFieldsScriptFailed             5
#define AppExtensionErrorCodeUnexpectedData                     6
#define AppExtensionErrorCodeFailedToObtainURLStringFromWebView 7
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark +++++++++++++++++++++++++++++++++ Custom Method +++++++++++++++++++
-(IBAction)btnLoginClick:(id)sender{
    
    if (![btnAction.titleLabel.text isEqualToString:@"Login"]) {
        
        
        [btnAction setTitle:@"Login" forState:UIControlStateNormal];
        [self findLoginForURLString:@"https://www.value.com" forViewController:self sender:sender completion:^(NSDictionary *loginDictionary, NSError *error) {
            
            if (!loginDictionary) {
                if (error.code != AppExtensionErrorCodeCancelledByUser) {
                    NSLog(@"Error invoking 1Password App Extension for find login: %@", error);
                }
                return;
            }
            NSLog(@"Details : %@",loginDictionary);
            
            if ([[loginDictionary allKeys] containsObject:@"username"]) {
                
                txtUserName.text = [loginDictionary valueForKey:@"username"];
                txtPassword.text = [loginDictionary valueForKey:@"password"];
                
                
                
                
                UIAlertView* alert = [[UIAlertView alloc]init];
                alert.title = @"Success" ;
                alert.message = @"User credential is successfully fatched using action extention";
                alert.delegate = self;
                [alert addButtonWithTitle:@"Ok"];
                alert.cancelButtonIndex=0;
                [alert show];
                
            }
            
        }];

        
    }
    else{
        NSLog(@"Done");
        
        [self performSegueWithIdentifier:@"message" sender:nil];
    }
}

- (void)findLoginForURLString:(NSString *)URLString forViewController:(UIViewController *)viewController sender:(id)sender completion:(void (^)(NSDictionary *loginDictionary, NSError *error))completion {
    NSAssert(URLString != nil, @"URLString must not be nil");
    NSAssert(viewController != nil, @"viewController must not be nil");
    
    if (![self isSystemAppExtensionAPIAvailable]) {
        NSLog(@"Failed to findLoginForURLString, system API is not available");
        if (completion) {
            
            NSLog(@"systemAppExtensionAPINotAvailableError") ;
            
        }
        return;
    }
    
#ifdef __IPHONE_8_0
    NSDictionary *item = @{ AppExtensionVersionNumberKey:  @"1", AppExtensionURLStringKey: URLString};
    
    __weak __typeof__ (self) miniMe = self;
    
    UIActivityViewController *activityViewController = [self activityViewControllerForItem:item viewController:viewController sender:sender typeIdentifier:kUTTypeAppExtensionFindLoginAction];
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (returnedItems.count == 0) {
            NSError *error = nil;
            if (activityError) {
                NSLog(@"Failed to findLoginForURLString: %@", activityError);
            }
            else {
                NSLog(@"extensionCancelledByUserError: %@", activityError);
            }
            
            if (completion) {
                completion(nil, error);
            }
            
            return;
        }
        
        __strong __typeof__(self) strongMe = miniMe;
        [strongMe processExtensionItem:returnedItems[0] completion:^(NSDictionary *loginDictionary, NSError *error) {
            if (completion) {
                completion(loginDictionary, error);
            }
        }];
    };
    
    [viewController presentViewController:activityViewController animated:YES completion:nil];
#endif
}
- (BOOL)isSystemAppExtensionAPIAvailable {
#ifdef __IPHONE_8_0
    return NSClassFromString(@"NSExtensionItem") != nil;
#else
    return NO;
#endif
}

- (UIActivityViewController *)activityViewControllerForItem:(NSDictionary *)item viewController:(UIViewController*)viewController sender:(id)sender typeIdentifier:(NSString *)typeIdentifier {
#ifdef __IPHONE_8_0
    
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:item typeIdentifier:typeIdentifier];
    
    NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
    extensionItem.attachments = @[ itemProvider ];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[ extensionItem ]  applicationActivities:nil];
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        controller.popoverPresentationController.barButtonItem = sender;
    }
    else if ([sender isKindOfClass:[UIView class]]) {
        controller.popoverPresentationController.sourceView = [sender superview];
        controller.popoverPresentationController.sourceRect = [sender frame];
    }
    else {
        NSLog(@"sender can be nil on iPhone");
    }
    
    return controller;
#else
    return nil;
#endif
}

- (void)processExtensionItem:(NSExtensionItem *)extensionItem completion:(void (^)(NSDictionary *loginDictionary, NSError *error))completion {
    if (extensionItem.attachments.count == 0) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Unexpected data returned by App Extension: extension item had no attachments." };
        NSError *error = [[NSError alloc] initWithDomain:AppExtensionErrorDomain code:AppExtensionErrorCodeUnexpectedData userInfo:userInfo];
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    
    NSItemProvider *itemProvider = extensionItem.attachments[0];
    
    [itemProvider loadItemForTypeIdentifier:kUTTypeAppExtensionFindLoginAction options:nil completionHandler:^(NSDictionary *loginDictionary, NSError *itemProviderError)
     {
         NSError *error = nil;
         if (!loginDictionary) {
             NSLog(@"Failed to loadItemForTypeIdentifier: %@", itemProviderError);
             
         }
         
         if (completion) {
             if ([NSThread isMainThread]) {
                 completion(loginDictionary, error);
             }
             else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     completion(loginDictionary, error);
                 });
             }
         }
     }];
}

@end
