//
//  pp_ASDialogController.h
//  Protein Purification
//
//  Created by Andrew Booth on 27/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_ASDialogController : NSViewController
{
	NSPanel *thisPanel;
	NSTextField *value;
	NSStepper *stepper;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSButton *HelpButton;
	NSBox *box;
	NSImageView *image;
}

@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSTextField *value;
@property (assign) IBOutlet NSStepper *stepper;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSButton *HelpButton;
@property (assign) IBOutlet NSBox *box;
@property (assign) IBOutlet NSImageView *image;

- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
- (IBAction)HelpButtonPressed:(id)sender;
- (IBAction)stepperDidChange:(id)sender;

- (void)showDialog;
- (float) getSaturation;

@end
