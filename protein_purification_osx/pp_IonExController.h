//
//  pp_IonExController.h
//  Protein Purification
//
//  Created by Andrew Booth on 03/08/2013.
//  Copyright (c) 2013 Andrew Booth. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pp_IonExController : NSViewController
{
	NSImageView *image;
	NSPanel *thisPanel;
	NSMatrix *mediaGroup;
	NSMatrix *elutionGroup;
	NSButton *OKButton;
	NSButton *CancelButton;
	NSButton *HelpButton;
	Boolean mediumSelected;
	Boolean elutionSelected;
	NSInteger medium;
	Boolean gradientIsSalt;
}
@property (assign) IBOutlet NSImageView *image;
@property (retain) IBOutlet NSPanel *thisPanel;
@property (assign) IBOutlet NSMatrix *mediaGroup;
@property (assign) IBOutlet NSMatrix *elutionGroup;
@property (assign) IBOutlet NSButton *OKButton;
@property (assign) IBOutlet NSButton *CancelButton;
@property (assign) IBOutlet NSButton *HelpButton;
@property (nonatomic) Boolean mediumSelected;
@property (nonatomic) Boolean elutionSelected;
@property (nonatomic) NSInteger medium;
@property (nonatomic) Boolean gradientIsSalt;

- (IBAction)mediaGroupChanged:(id)sender;
- (IBAction)elutionGroupChanged:(id)sender;
- (IBAction)OKButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;
- (IBAction)HelpButtonPressed:(id)sender;

- (void) showDialog;

- (NSInteger) getMedium;

@end
