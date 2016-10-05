//
//  pp_GetStoredMixtureController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 21/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_GetStoredMixtureController.h"
#import "pp_AppDelegate.h"

@interface pp_GetStoredMixtureController () {
    NSMutableArray *_objects;
}
@end

@implementation pp_GetStoredMixtureController {
    
    pp_GetProteinViewController* gpmvc;
    
}

@synthesize detailItem = _detailItem;

- (id) initWithStyle:(UITableViewStyle) style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Refrigerator", @"");
        gpmvc = nil;
    }
    return self;
}

// Read the mixture file from the Documents folder. Return NO if failure.
- (bool) getMixtureFilenames
{
    
    bool returnValue = NO;
    
    NSFileManager* fm = [[NSFileManager alloc] init];
    
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSArray* filesInDocs = [fm contentsOfDirectoryAtPath:docs error:nil];
    
    if (filesInDocs)
    {
        
        for (NSString* file in filesInDocs)
        {
            
            NSString* path = [docs stringByAppendingPathComponent:file];
            NSDictionary *attribs = [fm attributesOfItemAtPath:path error: NULL];
            NSString* fileType = [attribs objectForKey: NSFileType];
            
            if ([fileType isEqualToString:NSFileTypeDirectory]) continue;  // don't include directories
            
            if (![file hasPrefix:@"."])  // don't show hidden files
            {
                NSString* fileWithoutSuffix;
                // strip off suffix
                if ([file hasSuffix:@".ppmixture"])
                    fileWithoutSuffix = [file stringByDeletingPathExtension];
                
                [self insertNewObject:(NSString *)fileWithoutSuffix];
            }
        }
        returnValue = YES;
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
    
    // switch off the elastic
    [self.tableView setBounces:NO];

    // Try to get the mixture filenames
    
    if (![self getMixtureFilenames])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No mixtures found in Documents.\n(This message should never appear.)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
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
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;   
        // So each time a mixture is selected, its data are initialized.
        [self notifyAppDelegateStoredMixtureSelected]; 
    }
    
    
}

- (void)notifyAppDelegateStoredMixtureSelected
{
    // Notify the AppDelegate's commands object that the mixture has been selected/reselected.
    // The commands object will then load the data for the selected mixture.
    
    if (self.detailItem) {
        
        [app.commands loadStoredMixtureData:(NSString*)self.detailItem];
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}

#pragma mark - Table View

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header = @"";
    
    switch (section)
    {
        case 0: header = NSLocalizedString(@"Stored mixtures",@""); break;
            
    }
    return header;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString* header = @"";
    
    switch (section)
    {
        case 0: header = NSLocalizedString(@"Stored mixtures are accessible via the apps tab in iTunes.",@""); break;
            
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
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}





@end
