//
//  pp_AmmSulfView.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_AppDelegate.h"
#import "CPPickerView.h"

@interface pp_AmmSulfView : UIView <CPPickerViewDelegate, CPPickerViewDataSource>

@property (nonatomic) float ammsulfFloatValue;


@end
