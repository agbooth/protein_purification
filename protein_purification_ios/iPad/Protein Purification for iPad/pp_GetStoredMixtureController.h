//
//  pp_GetStoredMixtureController.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 21/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pp_Protein.h"
#import "pp_RecordViewController.h"
#import "pp_SplashViewController.h"
#import "pp_GetProteinView.h"
#import "pp_GetProteinViewController.h"


@interface pp_GetStoredMixtureController : UITableViewController <UITableViewDelegate>

@property (nonatomic, retain) id detailItem;


@end