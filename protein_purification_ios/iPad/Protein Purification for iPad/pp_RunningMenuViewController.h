//
//  pp_RunningMenuViewController.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_GelFiltMenuViewController.h"
#import "pp_IonExchMenuViewController.h"
#import "pp_HICMenuViewController.h"
#import "pp_AffMediaMenuViewController.h"
#import "pp_GetPoolViewController.h"
#import "pp_GelView.h"
#import "pp_GelViewController.h"
#import "pp_GetFractionViewController.h"
#import "pp_GetFractionsViewController.h"

@interface pp_RunningMenuViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

- (void) abandonScheme;

@end
