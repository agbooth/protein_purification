//
//  pp_GelView.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 14/08/2012.
//
//

#import <UIKit/UIKit.h>
#import "pp_AppDelegate.h"
enum {
    left,
    centre,
    right
};

@interface pp_GelView : UIView

@property (nonatomic) bool showBlot;
@property (nonatomic) bool twoDGel;

@end
