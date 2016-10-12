//
//  Protein_Purification_XCode_3_2AppDelegate.m
//  Protein Purification XCode 3.2
//
//  Created by Andrew Booth on 20/08/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "pp_AppDelegate.h"
#import "pp_SplashView.h"
#import "pp_Commands.h"

@implementation pp_AppDelegate

@synthesize window;
@synthesize commands;
@synthesize account;
@synthesize separation;
@synthesize proteinData;
@synthesize duration;
@synthesize menuStart;
@synthesize menuHelp;
@synthesize itemAbout;
@synthesize itemChooseMixture;
@synthesize itemAbandonScheme;
@synthesize itemAbandonStep;
@synthesize itemStoreMaterial;
@synthesize itemStartStored;
@synthesize itemAmmoniumSulfate;
@synthesize itemHeatTreatment;
@synthesize itemGelFiltration;
@synthesize itemIonExchange;
@synthesize itemHydrophobic;
@synthesize itemAffinity;
@synthesize item1DPAGE;
@synthesize item2DPAGE;
@synthesize itemCoomassie;
@synthesize itemImmunoblot;
@synthesize itemHideGel;
@synthesize itemHideBlot;
@synthesize itemAssayEnzyme;
@synthesize itemDiluteFractions;
@synthesize itemPoolFractions;
@synthesize itemShowHelp;
@synthesize itemTutorial;
@synthesize bgColor;
@synthesize windowClosed;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.commands = [[[pp_Commands alloc] init] autorelease];
    
    self.bgColor = [NSColor colorWithCalibratedRed:0.86328125 green:0.86328125 blue:0.86328125 alpha:1.0];
    
    self.window.backgroundColor = bgColor;
    
    // The screen will not be resizeable, so make sure it is a sensible size, based on 3/4 of the height of the screen.
    NSRect screenRect = [NSScreen mainScreen].frame;
    
    float scaledHeight = screenRect.size.height*0.75;
    float yOffset = (screenRect.size.height - scaledHeight)/2.0;
    
    float scaledWidth = scaledHeight*1024.0/748.0;
    float xOffset = (screenRect.size.width - scaledWidth)/2.0;
    
    NSRect windowRect = NSMakeRect(xOffset,yOffset, scaledWidth, scaledHeight);
    
    [self.window setFrame:windowRect display:NO];
    
    // Set the window's view to a pp_SplashView
    [self.window.contentView addSubview:[[[pp_SplashView alloc] initWithFrame: ((NSView*)self.window.contentView).bounds] autorelease]];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

// Intercept the close button if necessary with an NSWindowDelegate method.
- (BOOL)windowShouldClose:(id)sender
{
    self.windowClosed = NO;  // Assume the window is open at the moment.
    self.windowClosed = [self applicationShouldTerminate:sender]; // See if we can close it.
    return self.windowClosed;  // YES to close the window, NO to leave it open.
}

// Intercept termination if necessary with an NSApplicationDelegate method.
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // If there is no pp_Account object, then there is nothing to save yet.
    // If the main NSWindow has closed, then this code has already been run - don't run it again.
    
    if (account  && !self.windowClosed)
    {
        NSAlert* alert = [[[NSAlert alloc] init] autorelease];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"No",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes",@"")];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Do you want to store your material before leaving?",@"")];
        [alert.window setBackgroundColor:bgColor];
        NSInteger result = [alert runModal];
        
        if (result==1000) return NO;  //Cancel
        
        if (result==1002)          // Yes - try to save the data
        {
            if (![commands store_command]) return NO; // There was an error.
        }
    }
    
    return YES;  // Goodbye.
}


// Handle menu action messages - pass them to the pp_Commands object.
- (IBAction)dispatch:(id)sender
{
    [self.commands dispatch:sender];
}

// Change the view in the window's contentView.
// Use a cross-fade animation to ease the visual effect.
- (void) changeToView:(NSView*) view
{
    // Add the new view to the contentView
    [self.window.contentView addSubview:view];
    
    NSViewAnimation *theAnim;
    
    NSMutableDictionary* firstViewDict;
    NSMutableDictionary* secondViewDict;
    
    NSArray* subviews = ((NSView*)(self.window.contentView)).subviews;
    
    NSView* firstView = [subviews objectAtIndex:0];
    NSView* secondView = [subviews objectAtIndex:1];
    
    {
        // Create the attributes dictionary for the first view.
        firstViewDict = [NSMutableDictionary dictionaryWithCapacity:2];
        
        // Specify the view to fade out.        
        [firstViewDict setObject:firstView forKey:NSViewAnimationTargetKey];
        [firstViewDict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
    }
    {
        // Create the attributes dictionary for the second view.
        secondViewDict = [NSMutableDictionary dictionaryWithCapacity:2];
        
        // Set the view to fade in.
        [secondViewDict setObject:secondView forKey:NSViewAnimationTargetKey];
        [secondViewDict setObject:NSViewAnimationFadeInEffect forKey:NSViewAnimationEffectKey];
    }
    
    // Create the view animation object.
    theAnim = [[[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:firstViewDict, secondViewDict, nil]]autorelease];
    [theAnim setDelegate:self];
    
    // Set some additional attributes for the animation.
    [theAnim setDuration:0.3];
    [theAnim setAnimationCurve:NSAnimationLinear];
    
    // Run the animation.
    [theAnim startAnimation];
    
}

- (void)animationDidEnd:(NSAnimation *)animation
{
	NSArray* subviews = ((NSView*)(self.window.contentView)).subviews;
	[[subviews objectAtIndex:0] removeFromSuperview];
}
@end

