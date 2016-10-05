//
//  pp_MainMenuViewController.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_HeatViewController.h"
#import "pp_AmmSulfViewController.h"
#import "pp_GelFiltMenuViewController.h"
#import "pp_IonExchMenuViewController.h"
#import "pp_HICMenuViewController.h"
#import "pp_AffMediaMenuViewController.h"
#import "pp_GetPoolViewController.h"
#import "pp_GelViewController.h"

@interface pp_MainMenuViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

- (void) abandonScheme;
@end
