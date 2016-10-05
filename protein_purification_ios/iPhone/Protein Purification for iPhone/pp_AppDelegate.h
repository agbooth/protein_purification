//
//  pp_AppDelegate.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 18/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

#define app ((pp_AppDelegate *)[[UIApplication sharedApplication] delegate])

#import "pp_ProteinData.h"
#import "pp_Commands.h"
#import "pp_Account.h"
#import "pp_Separation.h"

#import "pp_SplashViewController.h"
#import "pp_GetMixtureController.h"
#import "MGSplitViewController.h"

@class pp_ProteinData;
@class pp_Commands;
@class pp_Account;
@class pp_Separation;
@class pp_SplashViewController;
@class pp_GetMixtureController;

@interface pp_AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) MGSplitViewController* splitViewController;
@property (nonatomic, retain) id masterViewController;
@property (nonatomic, retain) id detailViewController;
@property (nonatomic, retain) pp_ProteinData* proteinData;
@property (nonatomic, retain) pp_Commands* commands;
@property (nonatomic, retain) pp_Separation* separation;
@property (nonatomic, retain) pp_Account* account;
@property (nonatomic) Boolean iOS7;

@end
