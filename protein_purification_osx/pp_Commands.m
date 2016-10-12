//
//  pp_Commands.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 22/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_Commands.h"
#import "pp_Protein.h"
#import "pp_AppDelegate.h"
#import "pp_GetMixtureController.h"
#import "pp_GetProteinController.h"
#import "pp_SplashView.h"
#import "pp_RecordView.h"
#import "pp_ElutionView.h"
#import "pp_ASDialogController.h"
#import "pp_ASChoiceController.h"
#import "pp_StepRecord.h"
#import "pp_HeatDialogController.h"
#import "pp_GelFiltController.h"
#import "pp_IonExController.h"
#import "pp_GetPHController.h"
#import "pp_GetGradientController.h"
#import "pp_GetHICController.h"
#import "pp_AffinityController.h"
#import "pp_GetPoolController.h"
#import "pp_GelView.h"
#import "pp_GetFractionController.h"
#import "pp_GetFractionsController.h"

@implementation pp_Commands

@synthesize sepType;
@synthesize sepMedia;
@synthesize pooled;
@synthesize assayed;
@synthesize hasFractions;
@synthesize hasGradient;
@synthesize comingFromHelp;
@synthesize elutionpH;
@synthesize gradientIsSalt;
@synthesize startGrad;
@synthesize endGrad;
@synthesize overDiluted;
@synthesize scale;
@synthesize affinityElution;
@synthesize startOfPool;
@synthesize endOfPool;
@synthesize noOfFractions;
@synthesize oneDshowing;
@synthesize twoDshowing;
@synthesize twoDGel;
@synthesize showBlot;
@synthesize frax;
@synthesize hires;
@synthesize titratable;
@synthesize included;
@synthesize excluded;

NSString *fileString;

- (void)dispatch:(id)sender
{
    if (sender==app.itemAbout) [self about_command];
    if (sender==app.itemChooseMixture) [self start_command];
    if (sender==app.itemAbandonScheme) [self abandon_scheme_command];
    if (sender==app.itemAbandonStep) [self abandon_step_command];
    if (sender==app.itemStoreMaterial) [self store_command];
    if (sender==app.itemStartStored) [self start_stored];
    if (sender==app.itemAmmoniumSulfate) [self amm_sulf_command];
    if (sender==app.itemHeatTreatment) [self heat_treatment_command];
    if (sender==app.itemGelFiltration) [self gel_filtration_command];
    if (sender==app.itemIonExchange) [self ion_exchange_command];
    if (sender==app.itemHydrophobic) [self HIC_command];
    if (sender==app.itemAffinity) [self affinity_command];
    if (sender==app.itemAssayEnzyme) [self assay_command];
    if (sender==app.itemDiluteFractions) [self dilute_command];
    if (sender==app.itemPoolFractions) [self pool_command];
    if (sender==app.item1DPAGE) [self oneD_PAGE_command];
    if (sender==app.item2DPAGE) [self twoD_PAGE_command];
    if (sender==app.itemCoomassie) [self coomassie_command];
    if (sender==app.itemImmunoblot) [self immunoblot_command];
    if ((sender==app.itemHideGel) || (sender==app.itemHideBlot)) [self hide_command];
}

- (void) about_command
{
    NSString *locBookName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleHelpBookName"];
    [[NSHelpManager sharedHelpManager] openHelpAnchor:@"about"  inBook:locBookName];
}

- (void)start_command
{
    // Show the Get Mixture dialog.
    
    pp_GetMixtureController* gmc = [[[pp_GetMixtureController alloc] init] autorelease];
    [gmc showDialog];
    
    NSInteger result = [gmc getSelection];
    
    if (result==-1) return;
    
    // Get the selected row
    NSString* selection;
    switch (result)
    {
        case 0: selection = @"Default Mixture"; break;
        case 1: selection = @"Easy3 Mixture"; break;
        case 2: selection = @"Example Mixture"; break;
        case 3: selection = @"Complex Mixture"; break;
    }
    
    // Load the selected mixture
    [self loadMixtureData:selection];
    
    // Ensure the menus are disabled.
    [self activateSeparationMenu:NO];
    [self activateElectroMenu:NO];
    [self activateFractionsMenu:NO];
   
    // Show the Get Protein dialog.
    
    pp_GetProteinController* gpc = [[pp_GetProteinController alloc] init];
    [gpc showDialog];
    
    NSInteger enzymeID = [gpc getSelection];
    
    
    if (enzymeID==-1) return;
    
    // Inform the ProteinData
    app.proteinData.enzyme = enzymeID;
    
    
    // Show the stability data alert.
    pp_Protein* protein = [app.proteinData.Proteins objectAtIndex:enzymeID];
    
    NSAlert* alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert setMessageText:[NSString stringWithFormat:NSLocalizedString(@"Stability Data",@""),enzymeID, [protein temp],[protein pH1],[protein pH2]]];
    [alert.window setBackgroundColor:app.bgColor];
    [alert runModal];
    
    // Change the menus.
    [self endSplash];
    
    // Initialize stuff.
    [self conditionStart:YES];
    
    // Show the progress record.
    pp_RecordView* rv = [[[pp_RecordView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
	[app changeToView:rv];
  
}


- (void) start_stored
{
    if (!app.Registered)
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Sorry",@"")];
        [alert setInformativeText:NSLocalizedString(@"Not registered",@"")];
        [alert.window setBackgroundColor:app.bgColor];
        [alert runModal];
        
        return;
        
    }
    
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Set array of file types
    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"ppmixture", nil];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:NO];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] != NSOKButton ) return;
    
    // Make sure the splash screen is showing
    pp_SplashView* sv = [[[pp_SplashView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
    [app changeToView:sv];
    
    // Get the list of all files selected
    NSArray *files = [openDlg URLs];
        
    // Get the full path of the file
    NSString* filePath = [[files objectAtIndex:0] path];
    
    NSString* name = [[files objectAtIndex:0] lastPathComponent];
    NSArray* nameParts = [name componentsSeparatedByString:@"."];
        
    // Load the data from the file.
    
	NSError* error;
    NSString* fileString = [NSString stringWithContentsOfFile:filePath
                                                     encoding:NSUTF8StringEncoding
														error:&error];
	
    // (Re)create the pp_ProteinData object;
    if (app.proteinData) app.proteinData = Nil;
    app.proteinData = [[[pp_ProteinData alloc] init] autorelease];


    [app.proteinData parseData: fileString];
	
	
    
    // Ensure the menus are disabled.
    [self activateSeparationMenu:NO];
    [self activateElectroMenu:NO];
    [self activateFractionsMenu:NO];
    
    app.proteinData.mixtureName = [nameParts objectAtIndex:0];
	
	if (app.proteinData.noOfProteins == 0)
	{
		NSAlert* alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:app.proteinData.mixtureName];
		[alert setInformativeText:NSLocalizedString(@"This mixture contains no proteins.",@"")];
		[alert.window setBackgroundColor:app.bgColor];
		[alert runModal];
        
		return;
	}
	if (app.proteinData.noOfProteins == -1)
	{
		NSAlert* alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert setMessageText:app.proteinData.mixtureName];
		[alert setInformativeText:NSLocalizedString(@"Error in mixture file.",@"")];
		[alert.window setBackgroundColor:app.bgColor];
		[alert runModal];
        
		return;
	}
    
    if (app.proteinData.hasScheme)
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"No",@"")];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:app.proteinData.mixtureName];
        [alert setInformativeText:NSLocalizedString(@"This mixture has a purification history. Do you want to continue it?",@"")];
        [alert.window setBackgroundColor:app.bgColor];
        NSInteger result = [alert runModal];
		
        
        if (result==1000)
        {
            [app.proteinData parseScheme:fileString];
    
            self.hasFractions = NO;
            self.pooled = YES;
            self.overDiluted = NO;
            self.assayed = NO;
            self.scale = 0.5;
            if (self.frax)
                [self.frax removeAllObjects];
            else
                self.frax = [[[NSMutableArray alloc]init] autorelease];
        }
        else
        {
            pp_GetProteinController* gpc = [[[pp_GetProteinController alloc] init] autorelease];
            [gpc showDialog];
            
            NSInteger enzymeID = [gpc getSelection];
            
            
            if (enzymeID==-1) return;
            
            // Inform the ProteinData
            app.proteinData.enzyme = enzymeID;
            
            
            // Show the stability data alert.
            pp_Protein* protein = [app.proteinData.Proteins objectAtIndex:enzymeID];
            
            NSAlert* alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
            [alert setAlertStyle:NSInformationalAlertStyle];
            [alert setMessageText:[NSString stringWithFormat:NSLocalizedString(@"Stability Data",@""),enzymeID, [protein temp],[protein pH1],[protein pH2]]];
            [alert.window setBackgroundColor:app.bgColor];
            [alert runModal];
            
            [self conditionStart:YES];

        }
    }
    else  // no scheme
    {
		
		pp_GetProteinController* gpc = [[[pp_GetProteinController alloc] init] autorelease];
		[gpc showDialog];
		
		NSInteger enzymeID = [gpc getSelection];
		
		
		if (enzymeID==-1) return;
		
		// Inform the ProteinData
		app.proteinData.enzyme = enzymeID;
		
		
		// Show the stability data alert.
		pp_Protein* protein = [app.proteinData.Proteins objectAtIndex:enzymeID];
		
		NSAlert* alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
		[alert setAlertStyle:NSInformationalAlertStyle];
		[alert setMessageText:[NSString stringWithFormat:NSLocalizedString(@"Stability Data",@""),enzymeID, [protein temp],[protein pH1],[protein pH2]]];
		[alert.window setBackgroundColor:app.bgColor];
		[alert runModal];
		
		[self conditionStart:YES];
		
	}

    [self endSplash];
   
    // Show the progress record.
    pp_RecordView* rv = [[[pp_RecordView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
	[app changeToView:rv];
    
}


- (Boolean) store_command
{
    if (!app.Registered)
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Sorry",@"")];
        [alert setInformativeText:NSLocalizedString(@"Not registered",@"")];
        [alert.window setBackgroundColor:app.bgColor];
        [alert runModal];
        
        return NO;
        
    }
    
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    NSArray* allowedTypes = [NSArray arrayWithObject:@"ppmixture"];
    [savePanel setAllowedFileTypes:allowedTypes];
    [savePanel setCanCreateDirectories:YES];
    NSInteger result = [savePanel runModal];
    
    if (result==0) return NO;
    
    NSURL* url = [savePanel URL];
    NSString* data = [app.proteinData writeMixture:app.account];
    NSError *error;
    
    BOOL ok = [data writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (!ok)
    {
        // an error occurred
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:[url lastPathComponent]];
        [alert setInformativeText:[error localizedFailureReason]];
        [alert.window setBackgroundColor:app.bgColor];
        [alert runModal];
        
        return NO;
    }
    
    return YES;
}

- (void) abandon_scheme_command
{
    if (app.account)
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"No",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes",@"")];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Do you want to store your material before abandoning the scheme?",@"")];
        [alert.window setBackgroundColor:app.bgColor];
        NSInteger result = [alert runModal];
        
        if (result==1000) return;  //Cancel
        
        if (result==1002)          // Yes
        {
            if (![self store_command]) return;
        }
        
        
    }
    [self startSplash];
	
	pp_SplashView* sv = [[[pp_SplashView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
	[app changeToView:sv];
}

- (void) abandon_step_command
{
    if (app.account)
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"No",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes",@"")];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Abandon step warning",@"")];
        [alert.window setBackgroundColor:app.bgColor];
        NSInteger result = [alert runModal];

        if (result==1000) return;  // NO
    }
    pp_RecordView* rv = [[[pp_RecordView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
	[app changeToView:rv]; 
    
    self.hasFractions = NO;
    self.assayed = NO;
    self.pooled = YES;
    self.hasGradient = NO;
    
    [self activateSeparationMenu:YES];
    [self activateFractionsMenu:NO];
    
    [app.item1DPAGE setEnabled:YES];
    [app.item2DPAGE setEnabled:YES];
    [app.itemCoomassie setEnabled:NO];
    [app.itemImmunoblot setEnabled:NO];
    [app.itemHideGel setEnabled:NO];
    [app.itemHideGel setHidden:NO];
    [app.itemHideBlot setEnabled:NO];
    [app.itemHideBlot setHidden:YES];
    
    [app.itemAbandonStep setEnabled:NO];
    
    
    
}

- (void) activateSeparationMenu: (BOOL) activate
{
    [app.itemAmmoniumSulfate setEnabled:activate];
    [app.itemHeatTreatment setEnabled:activate];
    [app.itemGelFiltration setEnabled:activate];
    [app.itemIonExchange setEnabled:activate];
    [app.itemHydrophobic setEnabled:activate];
    [app.itemAffinity setEnabled:activate];    
}

- (void) activateElectroMenu: (BOOL) activate
{
    [app.item1DPAGE setEnabled:activate];
    [app.item2DPAGE setEnabled:activate];
    [app.itemCoomassie setEnabled:activate];
    [app.itemImmunoblot setEnabled:activate];
    [app.itemHideGel setEnabled:activate];
    [app.itemHideBlot setEnabled:activate];
    [app.itemHideBlot setHidden:YES];
}

- (void) activateFractionsMenu: (BOOL) activate
{
    [app.itemAssayEnzyme setEnabled:activate];
    [app.itemDiluteFractions setEnabled:activate];
    [app.itemPoolFractions setEnabled:activate];
}

- (void) startSplash
{
    [app.menuStart setTitle:NSLocalizedString(@"Start",@"")];
    [app.itemChooseMixture setHidden:NO];
    [app.itemAbandonScheme setEnabled:NO];
    [app.itemAbandonStep setEnabled:NO];
    [app.itemStoreMaterial setEnabled:NO];
    [app.itemStartStored setEnabled:YES];
    [self activateSeparationMenu:NO];
    [self activateFractionsMenu:NO];
    [app.item1DPAGE setEnabled:NO];
    [app.item2DPAGE setEnabled:NO];
    [app.itemCoomassie setEnabled:NO];
    [app.itemImmunoblot setEnabled:NO];
    [app.itemHideGel setEnabled:NO];
    [app.itemHideGel setHidden:NO];
    [app.itemHideBlot setEnabled:NO];
    [app.itemHideBlot setHidden:YES];
    
    app.account = Nil;  // So we won't be asked if we want to save the material on exit.
    app.separation = Nil;
    app.proteinData = Nil;
}

- (void) endSplash
{
    [app.menuStart setTitle:NSLocalizedString(@"Manage",@"")];
    [app.itemChooseMixture setHidden:YES];
    [app.itemAbandonScheme setEnabled:YES];
    [app.itemAbandonStep setEnabled:NO];
    [app.itemStoreMaterial setEnabled:YES];
    [app.itemStartStored setEnabled:YES];
    [self activateSeparationMenu:YES];
    [self activateFractionsMenu:NO];
    [app.item1DPAGE setEnabled:YES];
    [app.item2DPAGE setEnabled:YES];
    [app.itemCoomassie setEnabled:NO];
    [app.itemImmunoblot setEnabled:NO];
    [app.itemHideGel setEnabled:NO];
    [app.itemHideGel setHidden:NO];
    [app.itemHideBlot setEnabled:NO];
    [app.itemHideBlot setHidden:YES];
}


// Called after the mixture is selected.
- (void) loadMixtureData: (NSString*) sender
{
    
    if (app.proteinData) app.proteinData = Nil;
    
    app.proteinData = [[[pp_ProteinData alloc] init] autorelease];
    
    // Read the file from the bundle
    NSString *filePath = [[NSBundle mainBundle] pathForResource:sender ofType:@"txt"];
    
    if (filePath)
    {
        // Load mixture from file
        fileString = [NSString stringWithContentsOfFile:filePath 
                                                         encoding:NSUTF8StringEncoding error:nil];
            
        [app.proteinData parseData:fileString];
        app.proteinData.mixtureName = sender;
    }
   
}


- (void) conditionStart:(BOOL) refill
{
    if (app.separation) [app.separation release];
    app.separation = [[[pp_Separation alloc] init] autorelease];
    
    if (app.account) [app.account release];
    app.account = [[[pp_Account alloc] init ] autorelease];
    
    self.sepType = None;
    self.pooled = YES;
    self.assayed = NO;
    self.hasFractions = NO;
    self.hasGradient = NO;
    self.gradientIsSalt = YES;
    self.overDiluted = NO;
    self.elutionpH = -1.0;
    self.startGrad = -1.0;
    self.endGrad = -1.0;
    
    self.oneDshowing = NO;
    self.twoDshowing = NO;
    
    self.comingFromHelp = NO;
    
    app.proteinData.step = 0;
	
	if (refill)
	{
		//Make sure all proteins are present in full amount
		//as some may have been lost if we are using a stored mixture.
    
		for (int i=0; i<=app.proteinData.noOfProteins; i++)
			[app.proteinData SetCurrentAmountOfProtein:i value:[app.proteinData GetOriginalAmountOfProtein:i]];
    }
	
    self.frax = [[[NSMutableArray alloc]init] autorelease];
}

- (void) amm_sulf_command
{
    pp_ASDialogController*  asdc = [[[pp_ASDialogController alloc] init] autorelease];
    [asdc showDialog];
    
    float saturation = [asdc getSaturation];
    
    if (saturation==-1) return;
    
    [self doAmmoniumSulfate:saturation];
    
    
}

- (void) heat_treatment_command
{
    pp_HeatDialogController*  hdc = [[[pp_HeatDialogController alloc] init] autorelease];
    [hdc showDialog];
    
    float heatTemp = [hdc getTemp];
    float heatTime = [hdc getTime];
    
    if (heatTemp==-1) return;
    
    [self doHeatTreatment:heatTemp forTime:heatTime];
}

- (void) gel_filtration_command
{
    // Get the separation medium
    pp_GelFiltController*  gfc = [[[pp_GelFiltController alloc] init] autorelease];
    [gfc showDialog];
    
    NSInteger medium = [gfc getSelection];
    if (medium == -1) return;
    
    switch (medium)
    {
        case Sephadex_G50:
            self.sepMedia = Sephadex_G50;
			self.sepType = Gel_filtration;
			self.hires = NO;
			self.included = 1500;
			self.excluded = 30000;
            app.separation.mediumString = NSLocalizedString(@"Sephadex G-50", @"");
            break;
            
        case Sephadex_G100:
            self.sepMedia = Sephadex_G100;
			self.sepType = Gel_filtration;
			self.hires = NO;
			self.included = 4000;
			self.excluded = 150000;
            app.separation.mediumString = NSLocalizedString(@"Sephadex G-100", @"");
            break;
            
        case Sephacryl_S200:
            self.sepMedia = Sephacryl_S200;
			self.sepType = Gel_filtration;
			self.hires = YES;
			self.included = 5500;
			self.excluded = 220000;
            app.separation.mediumString = NSLocalizedString(@"Sephacryl S-200 HR", @"");
            break;
            
        case Ultrogel_54:
            self.sepMedia = Ultrogel_54;
			self.sepType = Gel_filtration;
			self.hires = NO;
			self.included = 6000;
			self.excluded = 70000;
            app.separation.mediumString = NSLocalizedString(@"Ultrogel AcA 54", @"");
            break;
            
        case Ultrogel_44:
            self.sepMedia = Ultrogel_44;
			self.sepType = Gel_filtration;
			self.hires = NO;
			self.included = 12000;
			self.excluded = 130000;
            app.separation.mediumString = NSLocalizedString(@"Ultrogel AcA 44", @"");
            break;
            
        case Ultrogel_34:
            self.sepMedia = Ultrogel_34;
			self.sepType = Gel_filtration;
			self.hires = NO;
			self.included = 20000;
			self.excluded = 400000;
            app.separation.mediumString = NSLocalizedString(@"Ultrogel AcA 34", @"");
            break;
            
        case BioGel_P60:
            self.sepMedia = BioGel_P60;
			self.sepType = Gel_filtration;
			self.hires = NO;
			self.included = 3000;
			self.excluded = 60000;
            app.separation.mediumString = NSLocalizedString(@"Bio-Gel P-60", @"");
            break;
            
        case BioGel_P150:
            self.sepMedia = BioGel_P150;
			self.sepType = Gel_filtration;
			self.hires = NO;
			self.included = 15000;
			self.excluded = 150000;
            app.separation.mediumString = NSLocalizedString(@"Bio-Gel P-150", @"");
            break;
            
        case BioGel_P300:
            self.sepMedia = BioGel_P300;
			self.sepType = Gel_filtration;
			self.hires = NO;
			self.included = 60000;
			self.excluded = 400000;
            app.separation.mediumString = NSLocalizedString(@"Bio-Gel P-300", @"");            
    }
    
    // Run the column
    [self doGelFiltration];
    
}

- (void) ion_exchange_command
{
    // Select the ion exchanger and the gradient type
    pp_IonExController*  iec = [[[pp_IonExController alloc] init] autorelease];
    [iec showDialog];
    
    NSInteger medium = [iec getMedium];
    if (medium == -1) return;
    
    self.gradientIsSalt = iec.gradientIsSalt;
    
    switch (medium)
    {
        case DEAE_cellulose:
            self.sepMedia = DEAE_cellulose;
            self.sepType = Ion_exchange;
            self.titratable = YES;
            app.separation.mediumString = NSLocalizedString(@"DEAE-cellulose", @"");
            break;
            
        case CM_cellulose:
            self.sepMedia = CM_cellulose;
            self.sepType = Ion_exchange;
            self.titratable = YES;
            app.separation.mediumString = NSLocalizedString(@"CM-cellulose", @"");
            break;
            
        case Q_Sepharose:
            self.sepMedia = Q_Sepharose;
            self.sepType = Ion_exchange;
            self.titratable = NO;
            app.separation.mediumString = NSLocalizedString(@"Q-Sepharose", @"");
            break;
            
        case S_Sepharose:
            self.sepMedia = S_Sepharose;
            self.sepType = Ion_exchange;
            self.titratable = YES;
            app.separation.mediumString = NSLocalizedString(@"S-Sepharose", @"");
    }
    
    // Get the equilibration pH
    pp_GetPHController* gpc = [[[pp_GetPHController alloc] init] autorelease];
    [gpc showDialog];
    
    self.elutionpH = [gpc getpH];
    if (self.elutionpH == -1) return;
    
    // Get the start end end of the gradient
    pp_GetGradientController* ggc = [[[pp_GetGradientController alloc] init] autorelease];
    [ggc showDialog];
    
    self.startGrad = [ggc getStart];
    self.endGrad = [ggc getEnd];
    
    if (self.startGrad == -1) return;
    
    // Run the column
    [self doIonExchange];
   
}

- (void) HIC_command
{
    pp_GetHICController*  ghc = [[[pp_GetHICController alloc] init] autorelease];
    [ghc showDialog];
    
    NSInteger medium = [ghc getSelection];
    if (medium == -1) return;
    
    switch (medium)
    {
        case Phenyl_Sepharose:
            self.sepMedia = Phenyl_Sepharose;
            self.sepType = Hydrophobic_interaction;
            app.separation.mediumString = NSLocalizedString(@"Phenyl-Sepharose CL-4B", @"");
            break;
            
        case Octyl_Sepharose:
            self.sepMedia = Octyl_Sepharose;
            self.sepType = Ion_exchange;
            app.separation.mediumString = NSLocalizedString(@"Octyl-Sepharose CL-4B", @"");
    }
    
    self.gradientIsSalt = YES;
    
    pp_GetGradientController* ggc = [[[pp_GetGradientController alloc] init] autorelease];
    [ggc showDialog];
    
    self.startGrad = [ggc getStart];
    self.endGrad = [ggc getEnd];
    
    if (self.startGrad==-1) return;
    
    // Has anything precipitated out in the starting buffer?
 
    NSString* message = [app.separation CheckPrecipitatedWith:startGrad];
    
    if (![message isEqualToString:@""])
    {
        // Yes - ask if we should get rid of it and continue.
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"No",@"")];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:message];
        [alert.window setBackgroundColor:app.bgColor];
        NSInteger result = [alert runModal];
        
        // No - abandon step.
        if (result == 1001) return;
        
        // Yes remove the precipitated material
        [app.separation doPrecipitate];
    }
    
    // Run the column
    [self doHIC];
}

- (void) affinity_command
{
    pp_AffinityController*  ac = [[[pp_AffinityController alloc] init] autorelease];
    [ac showDialog];
    
    NSInteger ligand = [ac getLigand];
    if (ligand == -1) return;
    
    self.sepType = Affinity;
    self.sepMedia = ligand;
    
    switch (ligand) {
        case AntibodyA:
            app.separation.mediumString = [NSString stringWithFormat:NSLocalizedString(@"immobilized monoclonal antibody MC01A",@""), app.proteinData.enzyme];
            break;
            
        case AntibodyB:
            app.separation.mediumString = [NSString stringWithFormat:NSLocalizedString(@"immobilized monoclonal antibody MC01B",@""), app.proteinData.enzyme];
            break;
            
        case AntibodyC:
            app.separation.mediumString = [NSString stringWithFormat:NSLocalizedString(@"immobilized monoclonal antibody MC01C",@""), app.proteinData.enzyme];
            break;
        
        case Polyclonal:
            app.separation.mediumString = NSLocalizedString(@"immobilized polyclonal IgG",@"");
            break;
          
        case Immobilized_inhibitor:
            app.separation.mediumString = NSLocalizedString(@"immobilized competitive inhibitor",@"");
            break;

        case NiNTAagarose:
            app.separation.mediumString = NSLocalizedString(@"Ni-NTA agarose",@"");
            break;
            
        default:
            break;
    }
    
    self.affinityElution = [ac getElution];
    
    if ((app.proteinData.enzyme % 3 > 0) && (self.sepMedia==Immobilized_inhibitor))
    {
        // The competitive inhibitor can't be immobilized.
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Sorry",@"")];
        [alert setInformativeText:NSLocalizedString(@"Apology",@"")];
        [alert.window setBackgroundColor:app.bgColor];
        [alert runModal];
        return;
    }
    
    [self doAffinity];
}

- (void) assay_command
{
    [app.itemAssayEnzyme setEnabled:NO];
    self.assayed = YES;
    [app.account addCost:2.0];
    [app.window.contentView setNeedsDisplay:YES];
}

- (void) dilute_command
{
    self.scale *= 2.0;
    if (self.scale == 16.0) [app.itemDiluteFractions setEnabled:NO];
    
    [app.account addCost:1.0];
    [app.window.contentView setNeedsDisplay:YES];
}

- (void) pool_command
{
    pp_GetPoolController*  gpc = [[pp_GetPoolController alloc] init];
    [gpc showDialog];
    
    if (!app.commands.pooled) return;
    
    [self doPoolFractions];
}

- (void) oneD_PAGE_command
{
    [self activateSeparationMenu:NO];
    [self activateFractionsMenu:NO];
    
    noOfFractions = 0;
    
    if (pooled)
        noOfFractions = 1;
    else
    {
        pp_ElutionView* ev = [[[pp_ElutionView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
        [app changeToView:ev];
        
        pp_GetFractionsController* gfv = [[[pp_GetFractionsController alloc] init] autorelease];
        [gfv showDialog];
        noOfFractions = (int)[gfv getNoOfFractions];
    }
    
    if (noOfFractions==-1)
    {
        [self activateSeparationMenu:pooled];
        [self activateFractionsMenu:!pooled];
        [self activateElectroMenu:YES];
        
        [app.item1DPAGE setEnabled:YES];
        [app.item2DPAGE setEnabled:YES];
        [app.itemCoomassie setEnabled:NO];
        [app.itemImmunoblot setEnabled:NO];
        
        [app.itemHideGel setHidden:NO];
        [app.itemHideGel setEnabled:NO];
        
        [app.itemHideBlot setHidden:YES];
        [app.itemHideBlot setEnabled:NO];
        
        return;
    }
    
    twoDGel = NO;
    showBlot = NO;
    
    [app.account addCost:5.0];
    
    [app.item1DPAGE setEnabled:NO];
    [app.item2DPAGE setEnabled:YES];
    [app.itemCoomassie setEnabled:NO];
    [app.itemImmunoblot setEnabled:YES];
    
    [app.itemHideGel setHidden:NO];
    [app.itemHideGel setEnabled:YES];
    
    [app.itemHideBlot setHidden:YES];
    [app.itemHideBlot setEnabled:YES];
    
    pp_GelView* gv = [[[pp_GelView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
    [app changeToView:gv];
    
}


- (void) twoD_PAGE_command
{
    [self activateSeparationMenu:NO];
    [self activateFractionsMenu:NO];
    
    noOfFractions = 0;
    
    if (pooled)
        noOfFractions = 1;
    else
    {
        pp_ElutionView* ev = [[[pp_ElutionView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
        [app changeToView:ev];
        
        pp_GetFractionController* gfv = [[[pp_GetFractionController alloc] init] autorelease];
        [gfv showDialog];
        noOfFractions = (int)[gfv getNoOfFractions];
    }
    
    if (noOfFractions==-1)
    {
        [self activateSeparationMenu:pooled];
        [self activateFractionsMenu:!pooled];
        [self activateElectroMenu:YES];
        
        [app.item1DPAGE setEnabled:YES];
        [app.item2DPAGE setEnabled:YES];
        [app.itemCoomassie setEnabled:NO];
        [app.itemImmunoblot setEnabled:NO];
        
        [app.itemHideGel setHidden:NO];
        [app.itemHideGel setEnabled:NO];
        
        [app.itemHideBlot setHidden:YES];
        [app.itemHideBlot setEnabled:NO];
        
        return;
    }
    
    twoDGel = YES;
    showBlot = NO;
    
    [app.account addCost:5.0];
    
    [app.item1DPAGE setEnabled:YES];
    [app.item2DPAGE setEnabled:NO];
    [app.itemCoomassie setEnabled:NO];
    [app.itemImmunoblot setEnabled:YES];
    
    [app.itemHideGel setHidden:NO];
    [app.itemHideGel setEnabled:YES];
    
    [app.itemHideBlot setHidden:YES];
    [app.itemHideBlot setEnabled:YES];
    
    pp_GelView* gv = [[[pp_GelView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
    [app changeToView:gv];


}

- (void) coomassie_command
{
    [app.itemHideGel setHidden:NO];
    [app.itemHideGel setEnabled:YES];
    
    [app.itemHideBlot setHidden:YES];
    [app.itemHideBlot setEnabled:YES];
    
    [app.itemCoomassie setEnabled:NO];
    [app.itemImmunoblot setEnabled:YES];
    
    showBlot = NO;
    
    //pp_GelViewController* gvc = [[pp_GelViewController alloc] init];
    //[app changeToView:gvc];
    
    [app.window.contentView setNeedsDisplay:YES];
}

- (void) immunoblot_command
{
    [app.itemHideGel setHidden:YES];
    [app.itemHideGel setEnabled:YES];
    
    [app.itemHideBlot setHidden:NO];
    [app.itemHideBlot setEnabled:YES];
    
    [app.itemCoomassie setEnabled:YES];
    [app.itemImmunoblot setEnabled:NO];
    
    showBlot = YES;
    
  //  pp_GelViewController* gvc = [[pp_GelViewController alloc] init];
  //  [app changeToView:gvc];
    
    [app.window.contentView setNeedsDisplay:YES];
}

- (void) hide_command
{
    [self activateSeparationMenu:pooled];
    [self activateFractionsMenu:!pooled];
    [self activateElectroMenu:YES];
    
    [app.item1DPAGE setEnabled:YES];
    [app.item2DPAGE setEnabled:YES];
    [app.itemCoomassie setEnabled:NO];
    [app.itemImmunoblot setEnabled:NO];
    
    [app.itemHideGel setHidden:NO];
    [app.itemHideGel setEnabled:NO];
    
    [app.itemHideBlot setHidden:YES];
    [app.itemHideBlot setEnabled:NO];
    
    if (hasFractions)
    {
        pp_ElutionView* ev = [[[pp_ElutionView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
        [app changeToView:ev];
    }
    else
    {
        pp_RecordView* rv = [[[pp_RecordView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
        [app changeToView:rv];
    }
}

- (void) doAmmoniumSulfate: (float) percent
{
    [app.separation AS: percent];
    
    pp_ASChoiceController* ascc = [[[pp_ASChoiceController alloc] init] autorelease];
    ascc.enz_prec = [app.proteinData GetInsolubleOfProtein:app.proteinData.enzyme]/[app.proteinData GetCurrentAmountOfProtein:app.proteinData.enzyme]*100.0;
    ascc.prot_prec = [app.proteinData GetInsolubleOfProtein:0]/[app.proteinData GetCurrentAmountOfProtein:0]*100.0;
    [ascc showDialog];
   
    NSInteger result = [ascc getSelection];
	
	switch (result)
    {
        case 0:
        {
            for (int i=0; i<=app.proteinData.noOfProteins; i++)
                [app.proteinData SetCurrentAmountOfProtein:i value:[app.proteinData GetInsolubleOfProtein:i]];
            break;
        }
        case 1:
        {
            for (int i=0; i<=app.proteinData.noOfProteins; i++)
                [app.proteinData SetCurrentAmountOfProtein:i value:[app.proteinData GetSolubleOfProtein:i]];
            break;
        }
        default: return;
    }
   
    self.sepType = Ammonium_sulfate;
    [app.account addCost:2.0];
    [app.proteinData IncrementStep];
    [app.account addStepRecord];
    
    [self finishStep];
	
	
    
}

- (void) doHeatTreatment:(float)temperature forTime:(float) time
{
    [app.separation HeatTreatment:temperature duration:time];
    self.sepType = Heat_treatment;
    [app.account addCost:1.0];
    [app.proteinData IncrementStep];
    [app.account addStepRecord];
    
    [self finishStep];
}


- (void) doGelFiltration
{
    app.separation.sepString = NSLocalizedString(@"Gel filtration",@"");
    [app.separation GelFiltrationElution:self.excluded included:self.included hires:self.hires];
    [app.separation SetPlotArray];
    
    self.hasGradient = NO;
    [app.account addCost:5.0];
    
    [self setToRunning];
    
}

- (void) doIonExchange
{
    app.separation.sepString = NSLocalizedString(@"Ion exchange chromatography",@"");
    switch (sepMedia)
	{
        case DEAE_cellulose:
            if (gradientIsSalt) [app.separation DEAESaltElution:startGrad
                                                           endGrad:endGrad
                                                                pH:elutionpH
                                                          titrable:YES];
            else [app.separation DEAEpHElution:startGrad
                                       endGrad:endGrad
                                            pH:elutionpH
                                      titrable:YES];
            break;
            
        case CM_cellulose:
            if (gradientIsSalt) [app.separation CMSaltElution:startGrad
                                                        endGrad:endGrad
                                                             pH:elutionpH
                                                       titrable:YES];
            else [app.separation CMpHElution:startGrad
                                       endGrad:endGrad
                                            pH:elutionpH
                                      titrable:YES];
            break;
            
        case Q_Sepharose:
            if (gradientIsSalt) [app.separation DEAESaltElution:startGrad
                                                        endGrad:endGrad
                                                             pH:elutionpH
                                                       titrable:NO];
            else [app.separation DEAEpHElution:startGrad
                                       endGrad:endGrad
                                            pH:elutionpH
                                      titrable:NO];

            break;
            
        case S_Sepharose:
            if (gradientIsSalt) [app.separation CMSaltElution:startGrad
                                                      endGrad:endGrad
                                                           pH:elutionpH
                                                     titrable:NO];
            else [app.separation CMpHElution:startGrad
                                     endGrad:endGrad
                                          pH:elutionpH
                                    titrable:NO];
            break;
	}
    
	[app.separation SetPlotArray];
    
	self.hasGradient = YES;
    [app.account addCost:5.0];
    
    [self setToRunning];
}

- (void) doHIC
{
    app.separation.sepString = NSLocalizedString(@"Hydrophobic interaction chromatography",@"");
    
    [app.separation HICElution:startGrad endGrad:endGrad medium:sepMedia salt_concn:startGrad];
    [app.separation SetPlotArray];
    
    self.hasGradient = YES;
    [app.account addCost:5.0];
    
    [self setToRunning];
}

- (void) doAffinity
{
    app.separation.sepString = NSLocalizedString(@"Affinity chromatography",@"");
    
    [app.separation Affinity_elution:sepMedia affinity_elution:affinityElution];
    [app.separation SetPlotArray];
    
    self.hasGradient = NO;
    [app.account addCost:25.0];
    
    [self setToRunning];
}

- (void) doPoolFractions
{
    
    if (!app.Registered)
    {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Sorry",@"")];
        [alert setInformativeText:NSLocalizedString(@"Not registered",@"")];
        [alert.window setBackgroundColor:app.bgColor];
        [alert runModal];
        
        pp_RecordView* rv = [[[pp_RecordView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
        [app changeToView:rv];
        
        self.hasFractions = NO;
        self.pooled = YES;
        self.overDiluted = NO;
        self.assayed = NO;
        self.scale = 0.5;
        [self.frax removeAllObjects];
        [self activateFractionsMenu:NO];
        [self activateSeparationMenu:YES];
        [app.itemAbandonStep setEnabled:NO];
        
        return;
    }
    
    [app.separation PoolFractionsFrom:startOfPool To:endOfPool];
    
    [app.account addStepRecord];
    self.hasFractions = NO;
    self.pooled = YES;
    self.overDiluted = NO;
    self.assayed = NO;
    self.scale = 0.5;
    [self.frax removeAllObjects];
    [self activateFractionsMenu:NO];
    [self activateSeparationMenu:YES];
    [app.itemAbandonStep setEnabled:NO];
    
    [self finishStep];
}

- (void) setToRunning
{
    self.scale = 0.5;
    self.assayed = NO;
    self.pooled = NO;
    self.hasFractions = YES;
    
    [self activateSeparationMenu:NO];
    [self activateFractionsMenu:YES];
    
    [app.itemAbandonStep setEnabled:YES];
    [app.item1DPAGE setEnabled:YES];
    [app.item2DPAGE setEnabled:YES];
    
    // Show the elution profile.
    pp_ElutionView* ev = [[[pp_ElutionView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
    [app changeToView:ev];
}


- (BOOL) showProgress
{
    // Has there been a disaster?
    int enzyme = app.proteinData.enzyme;
	int step = app.proteinData.step;
  
    float enz = [app.proteinData GetCurrentAmountOfProtein:enzyme] * [app.proteinData GetCurrentActivityOfProtein:enzyme] * 100.0;
	float cost = [app.account getCost]  * 100.0 / enz;
	
    
    NSString* message = @"Oops";
    
    if ((enz < 0.01) || (step==11) || (cost > 1000.0))  // Oops
	{
        if (enz < 0.01) message = NSLocalizedString(@"You have lost the enzyme!", @"");
        else if (step==11) message = NSLocalizedString(@"Not finished after 10 steps...", @"");
        else if (cost > 1000.0) message = NSLocalizedString(@"Cost is too high!", @"");
        
        NSString* infoText = NSLocalizedString(@"Financial advisers", @"");
        // Create an NSAlert
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes",@"")];
        [alert addButtonWithTitle:NSLocalizedString(@"No",@"")];
        [alert setMessageText:message];
        [alert setInformativeText:infoText];
        [alert.window setBackgroundColor:app.bgColor];
        
        // Show the NSAlert and wait for the result
        NSInteger result = [alert runModal];
        
        if (result==1001)
            [NSApp terminate:self];
        else
		{
			[app.account dealloc];
			app.account = Nil;
            [self abandon_scheme_command];
			return NO;
		}
        
    }
    return YES; // All's well...
}

- (void) finishStep
{
    if ([self showProgress])
    {
        pp_StepRecord* record = [app.account getStepRecord:app.proteinData.step];
		
		
        NSString* message = [NSString stringWithFormat:NSLocalizedString(@"RecordTitle",@""),app.proteinData.step];
        NSString* infoText = [NSString stringWithFormat:NSLocalizedString(@"RecordMessage",@""),
                              [record getProteinAmount],
                              [record getEnzymeUnits],
                              [record getEnrichment],
                              [record getEnzymeYield],
                              [record getCosting]];
        // Create an NSAlert
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
        [alert setMessageText:message];
        [alert setInformativeText:infoText];
        [alert.window setBackgroundColor:app.bgColor];
        
        // Show the NSAlert
        [alert runModal];
        
        pp_RecordView* rv = [[[pp_RecordView alloc] initWithFrame: ((NSView*)app.window.contentView).bounds] autorelease];
        [app changeToView:rv];
    }
}

- (void) tutorial_command
{
    NSURL *url = [NSURL URLWithString:NSLocalizedString(@"tutorial", @"")];
    [[NSWorkspace sharedWorkspace] openURL:url];
}
 

@end
