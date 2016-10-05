//
//  pp_GetFractionViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//


#import "pp_GetFractionViewController.h"


@implementation pp_GetFractionViewController {

pp_GelViewController* gelVC;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        app.commands.pooled = YES;  // needed if the fraction is to be indicated on the elution view
        gelVC = nil;
    }
    return self;
}

- (void) loadView
{
    
    self.view = [[pp_GetFractionView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle: NSLocalizedString(@"Done",@"")
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(setValueAndGo)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.title = NSLocalizedString(@"Fraction", @"");
}



- (void) setValueAndGo
{
    app.commands.pooled = NO; // must put it back or the gel will show pooled fractions
    
    app.commands.frax = nil;
    
    app.commands.frax = [[NSMutableArray alloc] initWithCapacity:1];
    [app.commands.frax addObject:[NSNumber numberWithInt:((pp_GetFractionView*)self.view).fractionValue]];
    
    

    app.commands.oneDshowing = NO;
    app.commands.twoDshowing = YES;
    
    
    UINavigationController* nav = (UINavigationController*)[app.splitViewController.viewControllers objectAtIndex:1];
    
    bool alreadyShowing = [nav.topViewController isKindOfClass:[pp_GelViewController class]];
    
    if (alreadyShowing)
        gelVC = (pp_GelViewController*)nav.topViewController;
    else
    {
        gelVC = [[pp_GelViewController alloc] initWithNibName:nil bundle:nil];
        gelVC.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
        [nav pushViewController:gelVC animated:YES];
    }
    ((pp_GelView*)gelVC.view).twoDGel = YES;
    gelVC.title = NSLocalizedString(@"2D - PAGE",@"");
    
    nav = (UINavigationController*)[app.splitViewController.viewControllers objectAtIndex:0];
    [nav popViewControllerAnimated:NO];// Must not be animating when we hide the master view.
    
    if (!app.splitViewController.isLandscape) [gelVC hideMasterView];
    
    
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}



@end
