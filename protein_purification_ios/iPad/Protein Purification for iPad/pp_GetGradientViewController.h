//
//  pp_GetGradientViewController.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_GetGradientView.h"
#import "pp_AppDelegate.h"
#import "pp_SeparationDelegate.h"

@interface pp_GetGradientViewController : UIViewController


@property (nonatomic) int sepType;
@property (nonatomic) int sepMedia;
@property (nonatomic) bool elutionpHRequired;
@property (nonatomic, retain) id <SeparationDelegate> delegate;

@end
