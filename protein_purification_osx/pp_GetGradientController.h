//
//  pp_GetGradientController.h
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_GetGradientController : NSViewController
{
	NSPanel *thisPanel;
	NSTextField *startValue;
	NSTextField *endValue;
	NSStepper *startStepper;
	NSStepper *endStepper;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSImageView *image;
	NSTextField *startLabel;
	NSTextField *endLabel;
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSTextField *startValue;
@property (assign) IBOutlet NSTextField *endValue;
@property (assign) IBOutlet NSStepper *startStepper;
@property (assign) IBOutlet NSStepper *endStepper;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSTextField *startLabel;
@property (assign) IBOutlet NSTextField *endLabel;

- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
- (IBAction)startStepperDidChange:(id)sender;
- (IBAction)endStepperDidChange:(id)sender;

- (void)showDialog;
- (float) getStart;
- (float) getEnd;
@end
