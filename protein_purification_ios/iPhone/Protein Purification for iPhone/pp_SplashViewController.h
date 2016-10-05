//
//  pp_SplashViewController.h
//
//  Created by Andrew Booth on 21/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "pp_AppDelegate.h"
#import "pp_GetMixtureController.h"
#import "pp_HelpViewController.h"
#import "pp_MainMenuViewController.h"
#import "MGSplitViewController.h"
#import "pp_RecordView.h"

@class pp_GetMixtureController;

@interface pp_SplashViewController : UIViewController <MGSplitViewControllerDelegate>

@property (nonatomic, retain) id senderItem;


@property (nonatomic, retain) pp_GetMixtureController* tableViewController;


- (void) changeToMainViewController;
@end
