//
//  pp_AffMediaMenuViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 28/07/2012.
//
//

#import "pp_AffMediaMenuViewController.h"

@interface pp_AffMediaMenuViewController ()

@end

@implementation pp_AffMediaMenuViewController

pp_AffElutionMenuViewController* aemvc;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        aemvc = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = NSLocalizedString(@"Ligand",@"");
    //self.detailNavigationViewController.navigationItem.leftBarButtonItem.title = self.title;
    
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
        case 0: header = NSLocalizedString(@"Affinity chromatography",@""); break;
        
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
        case 0: return 6;
        
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
    
    int enzyme = app.proteinData.enzyme;

    switch (indexPath.section)
    {
            
        case 0:
        
        switch (indexPath.row)
        {
                
                                
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Immobilized monoclonal antibody MC01A",@""), enzyme]; break;
                
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Immobilized monoclonal antibody MC01B",@""), enzyme]; break;
                
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Immobilized monoclonal antibody MC01C",@""), enzyme]; break;
                
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"Immobilized polyclonal IgG",@""); break;
                
                case 4:
                    cell.textLabel.text = NSLocalizedString(@"Immobilized competitive inhibitor",@""); break;
                
                case 5:
                    cell.textLabel.text = NSLocalizedString(@"Ni-NTA agarose",@""); break;
                
        }
        break;
            
        case 1:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = NSLocalizedString(@"Affinity chromatography",@""); break;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    switch (indexPath.section)
    {
        case 0:
            
            aemvc = [[pp_AffElutionMenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
                        
            aemvc.sepMedia = AntibodyA + indexPath.row;
            
            
            [self.navigationController pushViewController: aemvc animated:YES];

            break;
            
        case 1:
            
                [app.commands showHelpPage:@"Affinity"];
            
            break;
    }
    
}

@end
