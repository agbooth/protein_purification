//
//  pp_GetGradientViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//


#import "pp_GetGradientViewController.h"

@interface pp_GetGradientViewController ()

@end

@implementation pp_GetGradientViewController

@synthesize sepType;
@synthesize sepMedia;
@synthesize elutionpHRequired;
@synthesize delegate;

- (void) loadView
{
    
    self.view = [[pp_GetGradientView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    ((pp_GetGradientView*)self.view).elutionpHRequired = self.elutionpHRequired;
    ((pp_GetGradientView*)self.view).sepType = self.sepType;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle: NSLocalizedString(@"Done",@"")
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(setValuesAndGo)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}



- (void) setValuesAndGo
{
    app.commands.elutionpH = ((pp_GetGradientView*)self.view).elutionFloatValue;
    app.commands.startGrad = ((pp_GetGradientView*)self.view).startFloatValue;
    app.commands.endGrad   = ((pp_GetGradientView*)self.view).endFloatValue;
    app.commands.sepType   = self.sepType;       // set by the parent object
    app.commands.sepMedia   = self.sepMedia;     // by the parent object
    app.commands.hasGradient = YES;
        
    // Now do the separation
    [delegate doSeparation];
    [app.commands hideMasterView];
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


@end
