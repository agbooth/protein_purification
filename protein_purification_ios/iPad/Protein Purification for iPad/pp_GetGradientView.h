//
//  pp_GetGradientView.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_AppDelegate.h"
#import "CPPickerView.h"

@interface pp_GetGradientView : UIView <CPPickerViewDelegate, CPPickerViewDataSource>

@property (nonatomic) float elutionFloatValue;
@property (nonatomic) float startFloatValue;
@property (nonatomic) float endFloatValue;

@property (nonatomic) bool elutionpHRequired;
@property (nonatomic) int sepType;

@end
