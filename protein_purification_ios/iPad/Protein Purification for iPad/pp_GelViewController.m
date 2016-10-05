//
//  pp_GelViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 14/08/2012.
//
//

#import "pp_GelViewController.h"

@interface pp_GelViewController ()

@end



@implementation pp_GelViewController

UISegmentedControl* segments;

bool twoDBlotDone = NO;

- (id)initWithNibName:(NSString *)nibNameOrnil bundle:(NSBundle *)nibBundleOrnil
{
    self = [super initWithNibName:nibNameOrnil bundle:nibBundleOrnil];
    if (self) {
        segments = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"2D - PAGE",@"");
    
    [self didRotateFromInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle: NSLocalizedString(@"Help",@"")
                                    style:0
                                    target:self
                                    action:@selector(showHelp)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
 
    NSMutableArray* titles = [[NSMutableArray alloc] init];
    NSString* Coomassie = NSLocalizedString(@"Coomassie Blue",@"");
    NSString* Immuno = NSLocalizedString(@"Immunoblot",@"");
    [titles addObject:Coomassie];
    [titles addObject:Immuno];
    
    segments = [[UISegmentedControl alloc] initWithItems:titles];
    segments.segmentedControlStyle = UISegmentedControlStyleBar;
    [segments addTarget:self action:@selector(toggleBlot) forControlEvents:UIControlEventValueChanged];
    segments.selectedSegmentIndex = 0;

    self.navigationItem.titleView = segments;
    
    
    // add the swipe and tape gesture recognizers
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(handleSwipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(handleSwipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleTap)];
    [self.view addGestureRecognizer:tap];
    
    
    if (!app.splitViewController.isShowingMaster)
    {
        [self addMasterButton];
    }
    else
    {
        [self removeMasterButton];
    }

}

- (void) changeto1DPage
{
    
    ((pp_GelView*)self.view).showBlot = NO;
    ((pp_GelView*)self.view).twoDGel = NO;
    
    app.commands.oneDshowing = YES;
    app.commands.twoDshowing = NO;
    UINavigationController* masterNC = [app.splitViewController.viewControllers objectAtIndex:0];
    [((UITableViewController*)masterNC.topViewController).tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange (0, 2)] withRowAnimation:UITableViewRowAnimationFade];
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ self.title = NSLocalizedString(@"1D - PAGE",@"");[self.view setNeedsDisplay]; }
                    completion:NULL];
    segments.selectedSegmentIndex = 0;
    [app.account addCost:3.0];
    twoDBlotDone = NO;

}

- (void) changeto2DPage
{   
    
    ((pp_GelView*)self.view).showBlot = NO;
    ((pp_GelView*)self.view).twoDGel = YES;
    
    app.commands.oneDshowing = NO;
    app.commands.twoDshowing = YES;
    
    UINavigationController* masterNC = [app.splitViewController.viewControllers objectAtIndex:0];
    [((UITableViewController*)masterNC.topViewController).tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange (0, 2)] withRowAnimation:UITableViewRowAnimationFade];
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{ self.title = NSLocalizedString(@"2D - PAGE",@""); [self.view setNeedsDisplay]; }
                    completion:NULL];
    segments.selectedSegmentIndex = 0;
    [app.account addCost:5.0];
    twoDBlotDone = NO;
}

- (void)toggleBlot
{
    if (segments.selectedSegmentIndex == 0) // Coomassie Blue
    {
        ((pp_GelView*)self.view).showBlot = NO;
        
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                               [self.view setNeedsDisplay];
                           } completion:nil];
        
        // no charge for reviewing gel
        
    }
    else //Immunoblot
    {
        ((pp_GelView*)self.view).showBlot = YES;
        
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                               [self.view setNeedsDisplay];
                           } completion:nil];
        
        // only charge for the first view of the blot
        if (!twoDBlotDone)
        {
            [app.account addCost:5.0];
            twoDBlotDone = YES;
        }
    }
    
}


- (void) loadView
{
    self.view = [[pp_GelView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    ((pp_GelView*)self.view).showBlot = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    // At this point we are either coming back from showing Help - app.commands.comingFromHelp will be YES
    // or we are about to be dismissed in order to show the Progress report - app.commands.comingFromHelp will be NO
    
    if (! app.commands.comingFromHelp)  // Not coming back from Help, must be going to the Progress Report
    {                                   // clear both flags so the separations group is shown in the Master view
        app.commands.oneDshowing = NO;
        app.commands.twoDshowing = NO;
        
    
    }
    else app.commands.comingFromHelp = NO; // The flag was set in Help.
    
    
    UINavigationController* masterNC = [app.splitViewController.viewControllers objectAtIndex:0];
    //NSLog(@"visible ViewController is %@",masterNC.viewControllers[0]);
    [((UITableViewController*)masterNC.viewControllers[0]).tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange (0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];

    
    
    [super viewWillDisappear:animated];
}
/*
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    for (UIView *v in [self.view subviews]){
        [v removeFromSuperview];
    }
}
*/
- (void) showHelp
{
    [app.commands showHelpPage:@"Main_Contents"];
    
}

- (void)handleSwipeRight
{
    [self showMasterView];
}

- (void)handleSwipeLeft
{
    [self hideMasterView];
}

- (void)handleTap
{
    [self hideMasterView];
}

- (void)showMasterView
{
    if (!app.splitViewController.isShowingMaster)
    {
        [app.splitViewController toggleMasterView:self];
        app.splitViewController.showsMasterInLandscape = YES;
        app.splitViewController.showsMasterInPortrait = YES;
        [self removeMasterButton];
            }
}

- (void)hideMasterView
{
    if (app.splitViewController.isShowingMaster)
    {
        [app.splitViewController toggleMasterView:self];
        app.splitViewController.showsMasterInLandscape = NO;
        app.splitViewController.showsMasterInPortrait = NO;
        [self addMasterButton];
    }
}

- (void)addMasterButton
{
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItems = nil;
    
    UIBarButtonItem* methodsButton = [[UIBarButtonItem alloc]
                                      initWithTitle: NSLocalizedString(@"Methods",@"")
                                      style:0
                                      target:self
                                      action:@selector(showMasterView)];
 
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:methodsButton,nil];

}

- (void)removeMasterButton
{
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItems = nil;
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - Split view

#pragma mark -
#pragma mark MGSplit view support

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}


- (void)splitViewController:(MGSplitViewController*)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem
	   forPopoverController: (UIPopoverController*)pc
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	[self addMasterButton];
    
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(MGSplitViewController*)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	[self removeMasterButton];
}


- (void)splitViewController:(MGSplitViewController*)svc
		  popoverController:(UIPopoverController*)pc
  willPresentViewController:(UIViewController *)aViewController
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willChangeSplitOrientationToVertical:(BOOL)isVertical
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willMoveSplitToPosition:(float)position
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (float)splitViewController:(MGSplitViewController *)svc constrainSplitPosition:(float)proposedPosition splitViewSize:(CGSize)viewSize
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	return proposedPosition;
}



@end
