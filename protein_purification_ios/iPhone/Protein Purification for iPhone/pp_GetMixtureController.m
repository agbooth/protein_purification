//
//  pp_GetMixtureController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 21/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_GetMixtureController.h"
#import "pp_AppDelegate.h"

@interface pp_GetMixtureController () {
    NSMutableArray *_objects;
}
@end

@implementation pp_GetMixtureController {
    
    pp_GetProteinViewController* gpmvc;
    pp_GetStoredMixtureController* gsmvc;
    
}

@synthesize detailItem = _detailItem;

- (id) initWithStyle:(UITableViewStyle) style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Mixtures", @"");
        
        gpmvc = nil;
        gsmvc = nil;
    }
    return self;
}

// Read the mixture file from the bundle. Return NO if failure.
- (bool) readMixtureFile {
    
    bool returnValue = NO;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Mixtures" ofType:@"txt"];  
    if (filePath) {  
        
        NSString *fileString = [NSString stringWithContentsOfFile:filePath 
                                                         encoding:NSUTF8StringEncoding error:nil];
        
        [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        if (fileString) {  
            NSArray* lines = [fileString componentsSeparatedByString:@"\n"];
            int noOfMixtures = [[lines objectAtIndex:0] intValue];
            
            for (int i=1; i<= noOfMixtures; i++)
            {
                // Strip off any remaining control characters
                NSCharacterSet* charSet = [NSCharacterSet controlCharacterSet];
                NSString* cleaned = [[lines objectAtIndex:i] stringByTrimmingCharactersInSet:charSet];
                
                [self insertNewObject:(NSString *)cleaned];
            }
           /******************************
            
            //ADD "Load mixture item here 
            
            [self insertNewObject:(NSString *)NSLocalizedString(@"Load Mixture...",@"")];
            
            // THEN ADD CODE to notifyAppDelegateMixtureSelected
            
            ******************************/
            returnValue = YES;
        } 
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } 
    return returnValue;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set the UITableView's delegate
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];  
    
    // switch off the elastic
    [self.tableView setBounces:NO];

    // Try to read the Mixtures.txt file
    
    if (![self readMixtureFile])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Mixtures file not found in bundle.\n(This message should never appear.)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];   
    }
}




- (void) viewWillAppear:(BOOL)animated
{
    _detailItem = @"";
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundView:[[UIView alloc]init]];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    
    [super viewWillAppear:animated];
    
}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    [_objects addObject:sender];
    
    
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // So each time a mixture is selected, its data are initialized.
        [self notifyAppDelegateMixtureSelected];
    }
    
    
}

- (void)notifyAppDelegateMixtureSelected
{
    // Notify the AppDelegate's commands object that the mixture has been selected/reselected.
    // The commands object will then load the data for the selected mixture.
    
    if (self.detailItem)
    {
        
        [app.commands loadMixtureData:(NSString*)self.detailItem];
        
    }
}

- (int) countStoredMixtures
{
    NSFileManager* fm = [[NSFileManager alloc] init];
    
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSArray* filesInDocs = [fm contentsOfDirectoryAtPath:docs error:nil];
    
    NSMutableArray* filtered = [[NSMutableArray alloc] init];
    
    for (NSString* file in filesInDocs)  // don't count hidden files
    {
        if (![file hasPrefix:@"."]) [filtered addObject:file ];
    }
    
    return filtered.count;
}

#pragma mark - Table View


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header = @"";
    
    switch (section)
    {
        case 0: header = NSLocalizedString(@"Available mixtures",@""); break;
            
        case 1: header = NSLocalizedString(@"Start from stored material",@""); break;
            
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *cellText = selectedCell.textLabel.text;
    
        [self setDetailItem: cellText];
    
        gpmvc = [[pp_GetProteinViewController alloc] init];
    
        // The view's properties must be set BEFORE the view is manipulated
        gpmvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
        ((pp_GetProteinView*)gpmvc.view).noOfProteins = app.proteinData.noOfProteins;
        ((pp_GetProteinView*)gpmvc.view).mixtureName = cellText;
    
        [self.navigationController pushViewController: gpmvc animated:YES];
    }
    else
    {
        int count = [self countStoredMixtures];

        if (count == 0)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Refrigerator",@"")
                                                           message:NSLocalizedString(@"You have no stored mixtures.",@"")
                                                          delegate:nil
                                                 cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                                 otherButtonTitles:nil];
            [alert show];
            [self.tableView reloadData];
            return;
        }
        
        gsmvc = [[pp_GetStoredMixtureController alloc] initWithStyle:UITableViewStyleGrouped];
        
        // The view's properties must be set BEFORE the view is manipulated
        gsmvc.view.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
        
        [self.navigationController pushViewController: gsmvc animated:YES];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return _objects.count;
    else return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.section == 0)
    {
        NSString *object = [_objects objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [object description];
        [cell.textLabel sizeToFit];
    }
    if (indexPath.section == 1)
    {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = NSLocalizedString(@"Choose a stored mixture",@"");
        [cell.textLabel sizeToFit];
    }
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}





@end
