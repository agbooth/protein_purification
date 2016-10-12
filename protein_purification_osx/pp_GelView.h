//
//  pp_GelView.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 14/08/2012.
//
//

#import "pp_AppDelegate.h"


@interface pp_GelView : NSView
{
	bool showBlot;
	bool twoDGel;
}

@property (nonatomic) bool showBlot;
@property (nonatomic) bool twoDGel;

@end
