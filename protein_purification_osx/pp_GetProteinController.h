//
//  pp_GetProteinController.h
//  Protein Purification
//
//  Created by Andrew Booth on 29/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_GetProteinController : NSViewController <NSControlTextEditingDelegate>
{
	NSPanel *thisPanel;
	NSImageView *image;
	NSTextField *message;
	NSComboBox *combo;
	NSButton *OKButton;
	IBOutlet NSButton *CancelButton;
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSTextField *message;
@property (assign) IBOutlet NSComboBox *combo;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;

- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
- (void) showDialog;
- (NSInteger) getSelection;

@end
