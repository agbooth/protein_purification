//
//  pp_HICMenuViewController.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_GetGradientViewController.h"
#import "pp_SeparationDelegate.h"
#import "pp_AppDelegate.h"

@interface pp_HICMenuViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate> { id <SeparationDelegate> delegate; }


@end
