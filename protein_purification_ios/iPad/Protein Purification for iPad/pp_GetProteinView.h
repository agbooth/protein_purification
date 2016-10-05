//
//  pp_GetProteinView.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_AppDelegate.h"
#import "CPPickerView.h"

@interface pp_GetProteinView : UIView <CPPickerViewDelegate, CPPickerViewDataSource>
@property (nonatomic) int proteinValue;
@property (nonatomic, retain) NSString* mixtureName;
@property (nonatomic) int noOfProteins;

@end
