//
//  pp_IonExchMenuViewController.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_AppDelegate.h"
#import "pp_GetGradientViewController.h"
#import "pp_SeparationDelegate.h"

@interface pp_IonExchMenuViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> { id <SeparationDelegate> delegate; }


@end

