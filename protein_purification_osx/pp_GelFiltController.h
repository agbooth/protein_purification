//
//  pp_GelFiltController.h
//  Protein Purification
//
//  Created by Andrew Booth on 02/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_GelFiltController : NSViewController
{
	NSPanel *thisPanel;
	NSImageView *image;
	NSBox *box;
	NSMatrix *radioGroup;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSButton *HelpButton;
}

@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSBox *box;
@property (assign) IBOutlet NSMatrix *radioGroup;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSButton *HelpButton;

- (IBAction)radioGroupChanged:(id)sender;
- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
- (IBAction)HelpButtonPressed:(id)sender;

- (void)showDialog;
- (NSInteger) getSelection;

@end
