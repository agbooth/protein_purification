//
//  pp_AffElutionMenuViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import "pp_AffElutionMenuViewController.h"

@interface pp_AffElutionMenuViewController ()

@end

@implementation pp_AffElutionMenuViewController

@synthesize sepMedia;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Elution",@"");
    
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


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header = @"";
    
    switch (section)
    {
        case 0: header = NSLocalizedString(@"Elute with:",@""); break;
        
        case 1: header = NSLocalizedString(@"Information",@""); break;
        
    }
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (void) doSeparation
{
    if ((app.proteinData.enzyme % 3 > 0) && (app.commands.sepMedia==Immobilized_inhibitor))
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry",@"")
                                                        message:NSLocalizedString(@"Apology",@"")
                                                        delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
        [app.commands doAffinityElution];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section)
    {
            
        case 0:
        
        switch (indexPath.row)
        {
                
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"2mM-Tris/HCl pH 7.4",@""); break;
                
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"0.2M-glycine/HCl pH 2.3",@""); break;
                
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"5mM-competitive inhibitor",@""); break;
                
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"150mM-imidazole, 300mM-NaCl pH 7.0",@""); break;
                
        }
        break;
            
        
            
    }
    
    
    
    return cell;
    
   
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    switch (indexPath.section)
    {
        case 0:
            
            app.commands.sepType = Affinity;
            app.commands.sepMedia = self.sepMedia;
            app.commands.affinityElution = Tris + indexPath.row;
            app.commands.hasGradient = NO;
            
            [self doSeparation];
            
            [app.commands hideMasterView];
            
            break;
            
        case 1:
            
            break;
    }
    
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // Nothing to do - just dismiss the alertView.
}

@end
