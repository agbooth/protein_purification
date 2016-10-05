//
//  pp_HICMenuViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import "pp_HICMenuViewController.h"

@interface pp_HICMenuViewController ()

@end

@implementation pp_HICMenuViewController {

pp_GetGradientViewController* ggvc;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        ggvc = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Media",@"");
    
    // switch off the elastic
    [self.tableView setBounces:NO];
    
}



- (void) viewWillAppear:(BOOL)animated
{
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIView alloc]init]];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    [super viewWillAppear:animated];
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - Table view data source

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section==0) return NSLocalizedString(@"Remember to elute with a gradient of decreasing salt concentration.",@"");
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header = @"";
    
    switch (section)
    {
        case 0: header = NSLocalizedString(@"Hydrophobic interaction",@""); break;
        
        case 1: header = NSLocalizedString(@"Information",@""); break;
        
    }
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section)
    {
        case 0: return 2;
        
        case 1: return 1;
        
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section)
    {
            
        case 0:
        
        switch (indexPath.row)
        {
                
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Phenyl-Sepharose CL-4B",@""); break;
                
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Octyl-Sepharose CL-4B",@""); break;
                
        }
        break;
            
        case 1:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = NSLocalizedString(@"Hydrophobic interaction chromatography",@""); break;
            break;
            
    }
    
    
    
    return cell;
    
   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        app.commands.gradientIsSalt = YES;
        
        ggvc = [[pp_GetGradientViewController alloc] init];
        
        // These variables are passed to the GetGradientViewController
        // which will set the corresponding variables in app.commands
        // when the user commits to doing the separation and not before.
        ggvc.sepType = Hydrophobic_interaction;
        ggvc.sepMedia = Phenyl_Sepharose + indexPath.row;
        ggvc.elutionpHRequired = NO;
        ggvc.delegate = (id <SeparationDelegate>) self;
        
        // variables must be set BEFORE the view is manipulated
        ggvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
        
        [self.navigationController pushViewController: ggvc animated:YES];
    }
    if (indexPath.section == 1)
    {
        [app.commands showHelpPage:@"HIC"];
    }
}

-(void) doSeparation
{
    // See if anything salted out in the starting buffer
    NSString* message = [app.separation CheckPrecipitatedWith:app.commands.startGrad];
    if ([message compare:@""] !=  NSOrderedSame)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Precipitate",@"")
                                                        message:message delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Yes",@"")
                                              otherButtonTitles:NSLocalizedString(@"No",@""),nil];
        [alert show];
    }
    else // nothing precipitated out - just do the separation
       [app.commands doHydrophobicInteraction]; 
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        
    {
        [app.separation doPrecipitate];
        [app.commands doHydrophobicInteraction];

    }
    
}

@end
