//
//  pp_GetFractionView.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_AppDelegate.h"

@interface pp_GetFractionView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic) int fractionValue;

@property (nonatomic) int noOfProteins;

@end
