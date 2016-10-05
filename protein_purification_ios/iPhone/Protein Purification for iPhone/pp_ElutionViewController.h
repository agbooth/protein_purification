//
//  pp_ElutionViewController.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 25/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pp_AppDelegate.h"
#import "MGSplitViewController.h"

@interface pp_ElutionViewController : UIViewController <MGSplitViewControllerDelegate>

@property (nonatomic, retain) id delegate;

@end
