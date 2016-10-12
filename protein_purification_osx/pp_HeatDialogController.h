//
//  pp_HeatDialogController.h
//  Protein Purification
//
//  Created by Andrew Booth on 29/07/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_HeatDialogController : NSViewController
{
	NSPanel *thisPanel;
	NSTextField *tempValue;
	NSTextField *timeValue;
	NSStepper *tempStepper;
	NSStepper *timeStepper;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSButton *HelpButton;
	NSBox *tempBox;
	NSBox *timeBox;
	NSImageView *image;
}
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSTextField *tempValue;
@property (assign) IBOutlet NSTextField *timeValue;
@property (assign) IBOutlet NSStepper *tempStepper;
@property (assign) IBOutlet NSStepper *timeStepper;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSButton *HelpButton;
@property (assign) IBOutlet NSBox *tempBox;
@property (assign) IBOutlet NSBox *timeBox;
@property (assign) IBOutlet NSImageView *image;

- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
- (IBAction)HelpButtonPressed:(id)sender;
- (IBAction)tempStepperDidChange:(id)sender;
- (IBAction)timeStepperDidChange:(id)sender;

- (void)showDialog;
- (float) getTemp;
- (float) getTime;
@end
