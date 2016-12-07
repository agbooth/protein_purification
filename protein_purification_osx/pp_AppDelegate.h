//
//  pp_AppDelegate.h
//  Protein Purification XCode 3.2
//
//  Created by Andrew Booth on 20/08/2013.
//  All rights reserved.
//

#import <Cocoa/Cocoa.h>


#import "pp_Commands.h"
#import "pp_Account.h"
#import "pp_Separation.h"
#import "pp_ProteinData.h"

#define app ((pp_AppDelegate *)[[NSApplication sharedApplication] delegate])

@class pp_Commands;
@class pp_Account;
@class pp_Separation;
@class pp_ProteinData;

@interface pp_AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSAnimationDelegate> 
{
	NSWindow *window;
	pp_Commands *commands;
	pp_Account *account;
	pp_Separation *separation;
	pp_ProteinData *proteinData;
	NSColor* bgColor;
	float duration;
	Boolean windowClosed;
	NSMenu *menuStart;
	NSMenu *menuHelp;
	NSMenuItem *itemChooseMixture;
	NSMenuItem *itemAbout;
	NSMenuItem *itemAbandonScheme;
	NSMenuItem *itemAbandonStep;
	NSMenuItem *itemStoreMaterial;
	NSMenuItem *itemStartStored;
	NSMenuItem *itemAmmoniumSulfate;
	NSMenuItem *itemHeatTreatment;
	NSMenuItem *itemGelFiltration;
	NSMenuItem *itemIonExchange;
	NSMenuItem *itemHydrophobic;
	NSMenuItem *itemAffinity;
	NSMenuItem *item1DPAGE;
	NSMenuItem *item2DPAGE;
	NSMenuItem *itemCoomassie;
	NSMenuItem *itemImmunoblot;
	NSMenuItem *itemHideGel;
	NSMenuItem *itemHideBlot;
	NSMenuItem *itemAssayEnzyme;
	NSMenuItem *itemDiluteFractions;
	NSMenuItem *itemPoolFractions;
	NSMenuItem *itemShowHelp;
	NSMenuItem *itemTutorial;
	
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) pp_Commands *commands;
@property (nonatomic, retain) pp_Account *account;
@property (nonatomic, retain) pp_Separation *separation;
@property (nonatomic, retain) pp_ProteinData *proteinData;
@property (nonatomic, assign) NSColor* bgColor;
@property (nonatomic) float duration;
@property (nonatomic) Boolean windowClosed;


@property (retain) IBOutlet NSMenu *menuStart;
@property (retain) IBOutlet NSMenu *menuHelp;


@property (assign) IBOutlet NSMenuItem *itemChooseMixture;
@property (assign) IBOutlet NSMenuItem *itemAbout;
@property (assign) IBOutlet NSMenuItem *itemAbandonScheme;
@property (assign) IBOutlet NSMenuItem *itemAbandonStep;
@property (assign) IBOutlet NSMenuItem *itemStoreMaterial;
@property (assign) IBOutlet NSMenuItem *itemStartStored;
@property (assign) IBOutlet NSMenuItem *itemAmmoniumSulfate;
@property (assign) IBOutlet NSMenuItem *itemHeatTreatment;
@property (assign) IBOutlet NSMenuItem *itemGelFiltration;
@property (assign) IBOutlet NSMenuItem *itemIonExchange;
@property (assign) IBOutlet NSMenuItem *itemHydrophobic;
@property (assign) IBOutlet NSMenuItem *itemAffinity;
@property (assign) IBOutlet NSMenuItem *item1DPAGE;
@property (assign) IBOutlet NSMenuItem *item2DPAGE;
@property (assign) IBOutlet NSMenuItem *itemCoomassie;
@property (assign) IBOutlet NSMenuItem *itemImmunoblot;
@property (assign) IBOutlet NSMenuItem *itemHideGel;
@property (assign) IBOutlet NSMenuItem *itemHideBlot;
@property (assign) IBOutlet NSMenuItem *itemAssayEnzyme;
@property (assign) IBOutlet NSMenuItem *itemDiluteFractions;
@property (assign) IBOutlet NSMenuItem *itemPoolFractions;
@property (assign) IBOutlet NSMenuItem *itemShowHelp;
@property (assign) IBOutlet NSMenuItem *itemTutorial;

- (IBAction)dispatch:(id)sender;
- (void) changeToView:(NSView*) view;




@end
