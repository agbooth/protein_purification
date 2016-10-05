//
//  pp_Commands.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 22/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_Commands.h"
#import "pp_AppDelegate.h"

@implementation pp_Commands {
    
    UIAlertView* alert1;
    UIAlertView* alert2;
    UIAlertView* alert3;
    
    NSString *fileString;
    
}

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
@synthesize oneDshowing;
@synthesize twoDshowing;
@synthesize frax;

- (pp_Commands*) init {
    
    self = [super init];
    if (self)
    {
        alert1 = nil;
        alert2 = nil;
        alert3 = nil;
       
        [self conditionStart];
    }
    return self;
}

- (void) incrementLaunchCount
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSInteger count = [ud integerForKey:@"timesLaunched"];
    count++;
    [ud setObject:[NSNumber numberWithLong:count] forKey:@"timesLaunched"];
    
    //NSLog(@"LaunchCount is %d",count);
}

- (NSInteger) getLaunchCount
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:@"timesLaunched"];
}


- (void) enableUpgrade
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:YES] forKey:@"appUpgraded"];
    [self conditionStart];
    pp_SplashViewController* splashVC = [[pp_SplashViewController alloc] initWithNibName:(NSString *)nil bundle:(NSBundle *)nil];
    UINavigationController* detailNC = [app.splitViewController.viewControllers objectAtIndex:1];
    [detailNC setViewControllers:[NSArray arrayWithObject:splashVC] animated:YES];
    [app.splitViewController setDelegate:splashVC];
    
    // If the master view is showing, hide it
    if (app.splitViewController.isShowingMaster)
        [app.splitViewController toggleMasterView:self];
    
    // Change the master View Controller
    pp_GetMixtureController* gmVC = [[pp_GetMixtureController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* masterNC = [app.splitViewController.viewControllers objectAtIndex:0];
    [masterNC setViewControllers:[NSArray arrayWithObject:gmVC] animated:YES];
}


// Called after the mixture is selected.
- (void) loadMixtureData: (NSString*) sender {
    
    if (app.proteinData) app.proteinData = nil;
    
    app.proteinData = [[pp_ProteinData alloc] init];
    
    //[app.proteinData setDefaultValues];
    
    // Load mixture from file
    // Read the file from the bundle
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:sender ofType:@"txt"];
    
    if (filePath) {  
        
        fileString = [NSString stringWithContentsOfFile:filePath 
                                                         encoding:NSUTF8StringEncoding error:nil];
            
        [app.proteinData parseData:fileString];
        app.proteinData.mixtureName = sender;
    }
   
}

// Called after the mixture is selected.
- (void) loadStoredMixtureData: (NSString*) sender {
    
    if (app.proteinData) app.proteinData = nil;
    
    app.proteinData = [[pp_ProteinData alloc] init];
    
    // Load mixture from file
    // Read the file from the Documents folder
    
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString* filename = [NSString stringWithString:sender];
    
    // Make sure the suffix is there
    if (![filename hasSuffix:@".ppmixture"]) filename = [filename stringByAppendingString:@".ppmixture"];
    
    NSString* filePath = [docs stringByAppendingPathComponent:filename];
    
    if (filePath) {
        
        fileString = [NSString stringWithContentsOfFile:filePath
                                                         encoding:NSUTF8StringEncoding error:nil];
        
        
        [app.proteinData parseData:fileString];
        app.proteinData.mixtureName = sender;
        
        if (app.proteinData.noOfProteins == 0)
        {
            alert3 = [[UIAlertView alloc] initWithTitle:sender
                                                message:NSLocalizedString(@"This mixture contains no proteins.",@"")
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                      otherButtonTitles:nil];
            [alert3 show];
            
            return;
        }
        
        if (app.proteinData.noOfProteins == -1)
        {
            alert3 = [[UIAlertView alloc] initWithTitle:sender
                                                message:NSLocalizedString(@"Error in mixture file.",@"")
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                      otherButtonTitles:nil];
            [alert3 show];
            
            return;
        }
        
        if (app.proteinData.hasScheme)
        {
            alert3 = [[UIAlertView alloc] initWithTitle:sender
                                                message:NSLocalizedString(@"This mixture has a purification history. Do you want to continue it?",@"")
                                               delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"Yes",@"")
                                      otherButtonTitles:NSLocalizedString(@"No",@""),nil];
            [alert3 show];
        }
        else
        {
            pp_GetProteinViewController* gpmvc = [[pp_GetProteinViewController alloc] init];
            
            // The view's properties must be set BEFORE the view is manipulated
            gpmvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
            ((pp_GetProteinView*)gpmvc.view).noOfProteins = app.proteinData.noOfProteins;
            ((pp_GetProteinView*)gpmvc.view).mixtureName = app.proteinData.mixtureName;
            
            UINavigationController* masterNC = (UINavigationController*)[app.splitViewController masterViewController];
            [masterNC pushViewController: gpmvc animated:YES];

        }
    }
}

- (void) conditionStart
{
    if (app.separation) app.separation = nil;
    app.separation = [[pp_Separation alloc] init];
    
    if (app.account) app.account = nil;
    app.account = [[pp_Account alloc] init ];
    
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
    
    app.proteinData.step = 0;
    
    self.frax = [[NSMutableArray alloc]init];
}

- (void) goHome
{
    
}

- (void) showProgress
{
    // has there been a disaster?
    int enzyme = app.proteinData.enzyme;
    int step = app.proteinData.step;
    
    float enz = [app.proteinData GetCurrentAmountOfProtein:enzyme]*[app.proteinData GetCurrentActivityOfProtein:enzyme]*100.0;
    float cost = [app.account getCost]/enz*100.0;
    
    NSString* alertTitle = @"";
    NSString* alertMessage = @"";
    if ((enz < 0.01) || (step==11) || (cost > 1000.0))
    {
        if (enz <0.01)
            alertTitle = NSLocalizedString(@"You have lost the enzyme!",@"");
        else if (step==11)
            alertTitle = NSLocalizedString(@"Not finished after 10 steps...",@"");
        else if (cost > 1000.0)
            alertTitle = NSLocalizedString(@"Cost is too high!",@"");
        alertMessage = NSLocalizedString(@"Financial advisers",@"");
        
        alert1 = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Grateful acceptance",@"")
                                              otherButtonTitles:nil];
        [alert1 show];
        return; // just to be safe, but shouldn't get here.
    }

    pp_StepRecord* record = [app.account getStepRecord:app.proteinData.step];
    
    NSString* title = [NSString stringWithFormat:NSLocalizedString(@"RecordTitle",@""),app.proteinData.step];
    //NSString* reportMessage = [NSString stringWithFormat:@"\n\n\n\n\n"];
    NSString* reportMessage = [NSString stringWithFormat:NSLocalizedString(@"Total protein: %.d mg\nTotal enzyme: %d Units\nEnrichment: %.1f\nYield: %.1f%%\nCost: %.3f hours/100 Units",@""),
                               (int)round([record getProteinAmount]),
                               (int)round([record getEnzymeUnits]),
                               [record getEnrichment],
                               [record getEnzymeYield],
                               [record getCosting]
                               ];
    
    /*
    UILabel* leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,50,200,100)];
    leftLabel.text = NSLocalizedString(@"Total protein\nTotal enzyme\nEnrichment\nYield\nCost (hours/100 Units)",@"");
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textColor = [UIColor whiteColor];;
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.numberOfLines = 5;
    
    UILabel* rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(190,50,200,100)];
    rightLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%.d mg\n%d units\n%.1f\n%.1f%%\n%.3f",@""),
                       (int)round([record getProteinAmount]),
                       (int)round([record getEnzymeUnits]),
                       [record getEnrichment],
                       [record getEnzymeYield],
                       [record getCosting]];
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.textColor = [UIColor whiteColor];;
    rightLabel.backgroundColor = [UIColor clearColor];
    rightLabel.numberOfLines = 5;
                      
    UIView* panel = [[UIView alloc] init];
    [panel addSubview:leftLabel];
    [panel addSubview:rightLabel];
  */
    alert2 = [[UIAlertView alloc] initWithTitle:title
                                        message:reportMessage
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",@"")
                              otherButtonTitles:nil];
    [alert2 show];
}

- (void)showMasterView
{
    if (!app.splitViewController.isShowingMaster)
    {
        [app.splitViewController toggleMasterView:self];
        app.splitViewController.showsMasterInLandscape = YES;
        app.splitViewController.showsMasterInPortrait = YES;
    }
}

- (void)hideMasterView
{
    if (app.splitViewController.isShowingMaster)
    {
        [app.splitViewController toggleMasterView:self];
        app.splitViewController.showsMasterInLandscape = NO;
        app.splitViewController.showsMasterInPortrait = NO;
    }
}


- (void) resetRunningMenu
{
    self.hasFractions = NO;
    self.pooled = YES;
    self.overDiluted = NO;
    self.assayed = NO;
    self.frax = [[NSMutableArray alloc]init];
    
    [app.splitViewController.detailViewController.view setHidden:YES];
    [app.splitViewController.masterViewController.view setHidden:YES];
    
    // Change the master View Controller
    pp_MainMenuViewController* mainVC = [[pp_MainMenuViewController alloc]initWithStyle: UITableViewStyleGrouped];
    UINavigationController* masterNC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [app.splitViewController setMasterViewController:masterNC];
    
    pp_RecordViewController* recordVC = [[pp_RecordViewController alloc] initWithNibName:(NSString *)nil bundle:(NSBundle *)nil];
    recordVC.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    UINavigationController* detailNC = [[UINavigationController alloc] initWithRootViewController:recordVC];
   
    [app.splitViewController setDetailViewController:detailNC];
    
    [app.splitViewController setDelegate:recordVC];
    
    [self hideMasterView];
    
}

- (void) setToRunningMenu
{
    self.hasFractions = YES;
    self.pooled = NO;
    self.overDiluted = NO;
    self.assayed = NO;
    self.scale = 0.5;
    self.frax = [[NSMutableArray alloc]init];
    
    [app.splitViewController.masterViewController.view setHidden:YES];

    // Change the master View Controller
    pp_RunningMenuViewController* running = [[pp_RunningMenuViewController alloc]initWithStyle: UITableViewStyleGrouped];
    UINavigationController* masterNC = [[UINavigationController alloc] initWithRootViewController:running];
    [app.splitViewController setMasterViewController:masterNC];
    

}

- (void) showHelpPage: (NSString*) helpFile
{
    
    comingFromHelp = YES;
    
    UINavigationController* detailNC = (UINavigationController*)[app.splitViewController detailViewController];
    pp_HelpViewController* helpVC = [[pp_HelpViewController alloc] init];
    helpVC.helpFile = helpFile;
    [detailNC pushViewController:helpVC animated:YES];
}

- (void) drawElution
{
    // Change the detail ViewController
    pp_ElutionViewController* elutionVC = [[pp_ElutionViewController alloc] initWithNibName:(NSString *)nil bundle:(NSBundle *)nil];
    elutionVC.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    UINavigationController* detailNC = (UINavigationController*)[app.splitViewController detailViewController];
    [detailNC setViewControllers:[NSArray arrayWithObject:elutionVC] animated:YES];
    [app.splitViewController setDelegate:elutionVC];
}

-(void) doEnzymeAssay
{
    self.assayed = YES;
    [app.account addCost:2.0];
    [((pp_ElutionViewController*)(app.splitViewController.delegate)).view setNeedsDisplay];
    
}

-(void) doDiluteFractions
{
    
    [app.account addCost:1.0];
    self.scale *= 2.0;
    if (self.scale==16.0)
        self.overDiluted = YES;
    
    [((pp_ElutionViewController*)(app.splitViewController.delegate)).view setNeedsDisplay];
    
}

- (void) doPoolFractions
{
   
    [app.separation  PoolFractionsFrom: self.startOfPool To: (int) self.endOfPool];
    [app.account addStepRecord];
    [self showProgress];
   
    [self resetRunningMenu];
}

- (void) doAmmoniumSulfate: (float) percent
{
    [app.separation AmmoniumSulphateFractionation];
    [app.separation AS: percent];
}

- (NSString*) checkASPrecipitate
{
    float enz_prec = [app.proteinData GetInsolubleOfProtein:app.proteinData.enzyme]/[app.proteinData GetCurrentAmountOfProtein:app.proteinData.enzyme]*100.0;
    float prot_prec = [app.proteinData GetInsolubleOfProtein:0]/[app.proteinData GetCurrentAmountOfProtein:0]*100.0;
    
    NSString* MessageString = [NSString stringWithFormat:NSLocalizedString(@"AS Precipitation Question",@""),enz_prec,prot_prec];
    
    return MessageString;
}

- (void) finishAmmoniumSulfate: (int) choice
{
    if (choice == 0) return; // alert cancelled
    if (choice == 1)   // precipitated maerial chosen
    {
        for (int i=0; i<=app.proteinData.noOfProteins;i++)
            [app.proteinData SetCurrentAmountOfProtein:i value:[app.proteinData GetInsolubleOfProtein:i]];
    }
    if (choice == 2)  // soluble material chosen
    {
        for (int i=0; i<=app.proteinData.noOfProteins;i++)
            [app.proteinData SetCurrentAmountOfProtein:i value:[app.proteinData GetSolubleOfProtein:i]];
    }
    self.sepType = Ammonium_sulfate;
    [app.account addCost:2.0];
    [app.proteinData IncrementStep];
    [app.account addStepRecord];
    [self showProgress];
    [self resetRunningMenu];
}

- (void) doHeatTreatment:(float)temperature time:(float) time
{
    [app.separation HeatTreatment:temperature duration:time];
    self.sepType = Heat_treatment;
    [app.account addCost:1.0];
    [app.proteinData IncrementStep];
    [app.account addStepRecord];
    [self showProgress];
    [self resetRunningMenu];
}

- (void) doGelFiltration
{
    float included;
    float excluded;
    bool hires;
    
    app.separation.sepString = NSLocalizedString(@"Gel filtration",@"");
    
    switch (self.sepMedia)
    {
        case Sephadex_G50:
            excluded = 30000.0;
            included = 1500.0;
            hires = NO;
            app.separation.mediumString = NSLocalizedString(@"Sephadex G-50",@"");
            break;
            
        case Sephadex_G100:
            excluded = 150000.0;
            included = 4000.0;
            hires = NO;
            app.separation.mediumString = NSLocalizedString(@"Sephadex G-100",@"");
            break;
            
        case Sephacryl_S200:
            excluded = 220000.0;
            included = 5500.0;
            hires = YES;
            app.separation.mediumString = NSLocalizedString(@"Sephacryl S-200 HR",@"");
            break;
            
        case Ultrogel_54:
            excluded = 70000.0;
            included = 6000.0;
            hires = NO;
            app.separation.mediumString = NSLocalizedString(@"Ultrogel AcA 54",@"");
            break;
            
        case Ultrogel_44:
            excluded = 130000.0;
            included = 12000.0;
            hires = NO;
            app.separation.mediumString = NSLocalizedString(@"Ultrogel AcA 44",@"");
            break;
            
        case Ultrogel_34:
            excluded = 400000.0;
            included = 20000.0;
            hires = NO;
            app.separation.mediumString = NSLocalizedString(@"Ultrogel AcA 34",@"");
            break;
            
        case BioGel_P60:
            excluded = 60000.0;
            included = 3000.0;
            hires = NO;
            app.separation.mediumString = NSLocalizedString(@"Bio-Gel P-60",@"");
            break;
            
        case BioGel_P150:
            excluded = 150000.0;
            included = 15000.0;
            hires = NO;
            app.separation.mediumString = NSLocalizedString(@"Bio-Gel P-150",@"");
            break;
            
        case BioGel_P300:
            excluded = 400000.0;
            included = 60000.0;
            hires = NO;
            app.separation.mediumString = NSLocalizedString(@"Bio-Gel P-300",@"");
            break;
            
    }
    
    [app.separation GelFiltrationElution:excluded included:included hires:hires];
    [app.separation SetPlotArray];
    
    self.scale = 0.5;
    self.hasGradient = NO;
    
    [self drawElution];
    [self setToRunningMenu];
    
    [app.account addCost:5.0];
   // pp_StepRecord* stepRec = [app.account getStepRecord:app.proteinData.step];
   // [stepRec incrementCosting:5.0];

    
}

- (void) doIonExchange
{
    app.separation.sepString = NSLocalizedString(@"Ion exchange chromatography",@"");
    switch (self.sepMedia)
    {
        case DEAE_cellulose:
            app.separation.mediumString = NSLocalizedString(@"DEAE-cellulose",@"");
            
            if (self.gradientIsSalt==YES)
                [app.separation DEAESaltElution:self.startGrad endGrad:self.endGrad pH:self.elutionpH titrable:YES];
            else [app.separation DEAEpHElution:self.startGrad endGrad:self.endGrad pH:self.elutionpH titrable:YES];
            
            break;
            
        case CM_cellulose:
            app.separation.mediumString = NSLocalizedString(@"CM-cellulose",@"");
            
            if (self.gradientIsSalt==YES)
                [app.separation CMSaltElution:self.startGrad endGrad:self.endGrad pH:self.elutionpH titrable:YES];
            else [app.separation CMpHElution:self.startGrad endGrad:self.endGrad pH:self.elutionpH titrable:YES];
            
            break;
            
        case Q_Sepharose:
            app.separation.mediumString = NSLocalizedString(@"Q-Sepharose",@"");
            
            if (self.gradientIsSalt==YES)
                [app.separation DEAESaltElution:self.startGrad endGrad:self.endGrad pH:self.elutionpH titrable:NO];
            else [app.separation DEAEpHElution:self.startGrad endGrad:self.endGrad pH:self.elutionpH titrable:NO];
            
            break;
            
        case S_Sepharose:
            app.separation.mediumString = NSLocalizedString(@"S-Sepharose",@"");
            
            if (self.gradientIsSalt==YES)
                [app.separation CMSaltElution:self.startGrad endGrad:self.endGrad pH:self.elutionpH titrable:NO];
            else [app.separation CMpHElution:self.startGrad endGrad:self.endGrad pH:self.elutionpH titrable:NO];
            
            break;
    }
    
        
    [app.separation SetPlotArray];
    
    self.scale = 0.5;
    self.hasGradient = YES;
    
    [self drawElution];
    [self setToRunningMenu];
    
    [app.account addCost:5.0];
}

- (void) doHydrophobicInteraction
{
    app.separation.sepString = NSLocalizedString(@"Hydrophobic interaction chromatography",@"");
    switch (self.sepMedia)
    {
        case Phenyl_Sepharose:
            app.separation.mediumString = NSLocalizedString(@"Phenyl-Sepharose CL-4B",@"");
            break;
            
        case Octyl_Sepharose:
            app.separation.mediumString = NSLocalizedString(@"Octyl-Sepharose CL-4B",@"");
            break;
    }
    
    [app.separation HICElution:self.startGrad endGrad:self.endGrad medium:self.sepMedia salt_concn:self.startGrad];
    
    [app.separation SetPlotArray];
    
    self.scale = 0.5;
    self.hasGradient = YES;
    
    [self drawElution];
    [self setToRunningMenu];
    
    [app.account addCost:5.0];
}

- (void) doAffinityElution
{
    app.separation.sepString = NSLocalizedString(@"Affinity chromatography",@"");
    switch (self.sepMedia)
    {
        case AntibodyA:
            app.separation.mediumString = [NSString stringWithFormat:NSLocalizedString(@"monoclonal antibody MC01A",@""), app.proteinData.enzyme];
            break;
            
        case AntibodyB:
            app.separation.mediumString = [NSString stringWithFormat:NSLocalizedString(@"monoclonal antibody MC01B",@""), app.proteinData.enzyme];
            break;
            
        case AntibodyC:
            app.separation.mediumString = [NSString stringWithFormat:NSLocalizedString(@"monoclonal antibody MC01C",@""), app.proteinData.enzyme];
            break;
            
        case Polyclonal:
            app.separation.mediumString = NSLocalizedString(@"polyclonal IgG",@"");
            break;
            
        case Immobilized_inhibitor:
            app.separation.mediumString = NSLocalizedString(@"competitive inhibitor",@"");
            break;
            
        case NiNTAagarose:
            app.separation.mediumString = NSLocalizedString(@"Ni-NTA agarose",@"");
            break;
            
    }
    
    [app.separation Affinity_elution:app.commands.sepMedia affinity_elution:app.commands.affinityElution];
    
    [app.separation SetPlotArray];
    
    self.scale = 0.5;
    self.hasGradient = NO;
    
    [self drawElution];
    [self setToRunningMenu];
    
    [app.account addCost:25.0];
}
- (void) abandonScheme
{
    pp_SplashViewController* splashVC = [[pp_SplashViewController alloc] initWithNibName:(NSString *)nil bundle:(NSBundle *)nil];
    UINavigationController* detailNC = (UINavigationController*)[app.splitViewController detailViewController];
    [detailNC setViewControllers:[NSArray arrayWithObject:splashVC] animated:YES];
    [app.splitViewController setDelegate:splashVC];
    
    // If the master view is showing, hide it
    if (app.splitViewController.isShowingMaster)
        [app.splitViewController toggleMasterView:self];
    
    // Change the master View Controller
    pp_GetMixtureController* gmVC = [[pp_GetMixtureController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* masterNC = (UINavigationController*)[app.splitViewController masterViewController];
    [masterNC setViewControllers:[NSArray arrayWithObject:gmVC] animated:YES];
    
}


#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == alert3)
    {
        if (buttonIndex == 0)
        {
            // Parse scheme
            [app.proteinData parseScheme:fileString];
            [self resetRunningMenu];
        }
        else
        {
            pp_GetProteinViewController* gpmvc = [[pp_GetProteinViewController alloc] init];
            
            // The view's properties must be set BEFORE the view is manipulated
            gpmvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
            ((pp_GetProteinView*)gpmvc.view).noOfProteins = app.proteinData.noOfProteins;
            ((pp_GetProteinView*)gpmvc.view).mixtureName = app.proteinData.mixtureName;
            
            UINavigationController* masterNC = (UINavigationController*)[app.splitViewController masterViewController];
            [masterNC pushViewController: gpmvc animated:YES];
        }
    }
    else
        [self abandonScheme];
}

@end
