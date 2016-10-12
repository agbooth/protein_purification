//
//  pp_ProteinData.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 20/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_ProteinData.h"



@implementation pp_ProteinData

@synthesize Proteins;
@synthesize Soluble;
@synthesize Insoluble;
@synthesize step;
@synthesize enzyme;
@synthesize noOfProteins;
@synthesize mixtureName;
@synthesize hasScheme;


- (pp_ProteinData*) init {
    
    self = [super init];
    
    self.Proteins = [[[NSMutableArray alloc] init] autorelease];
    self.Soluble = [[[NSMutableArray alloc] init] autorelease];
    self.Insoluble = [[[NSMutableArray alloc] init] autorelease];
    
    [self.Soluble addObject:[NSNumber numberWithFloat: 0.0]];
    [self.Insoluble addObject:[NSNumber numberWithFloat: 0.0]];
    self.step = 0;
    
    return self;
}

- (void) setDefaultValues {
    
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:0:(int[]){0,0,0,0,0,0,0}:0.0:0.0:0:0:0:0.0:0.0:0.0:0.0:0.0:0.0:0.0:0.0:0.0:0:0]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:1:(int[]){16,23,6,31,10,18,3}:8.1:53500.0:1:0:0:53500.0:0.0:0.0:10.0:10.0:40.0:2.5:9.5:126.0:4:4]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:2:(int[]){22,25,-8,19,26,12,5}:6.9:320000.0:4:4:0:50000.0:30000.0:0.0:42.0:42.0:60.0:5.0:10.5:167.0:2:2]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:3:(int[]){23,28,8,18,17,16,4}:5.3:42000.0:1:0:0:42000.0:0.0:0.0:14.0:14.0:50.0:3.5:10.0:61.0:4:4]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:4:(int[]){14,15,3,12,14,7,0}:6.1:37000.0:1:0:0:37000.0:0.0:0.0:35.0:35.0:40.0:4.5:10.0:139.0:2:2]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:5:(int[]){12,15,8,15,11,19,1}:7.2:200000.0:4:0:0:50000.0:0.0:0.0:20.0:20.0:50.0:3.0:11.0:82.0:3:3]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:6:(int[]){13,15,4,13,11,6,3}:6.0:32000.0:1:0:0:32000.0:0.0:0.0:34.0:34.0:40.0:5.0:11.0:81.0:1:1]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:7:(int[]){24,28,10,20,22,10,0}:6.0:58000.0:2:0:0:29000.0:0.0:0.0:15.0:15.0:40.0:4.5:11.5:105.0:2:2]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:8:(int[]){9,11,3,15,3,2,0}:6.4:27000.0:1:0:0:27000.0:0.0:0.0:49.0:49.0:40.0:5.5:10.0:199.0:4:4]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:9:(int[]){7,18,2,16,8,2,0}:6.6:23000.0:1:0:0:23000.0:0.0:0.0:24.0:24.0:50.0:4.0:9.5:141.0:3:3]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:10:(int[]){16,14,4,13,11,3,1}:5.7:45000.0:2:0:0:22500.0:0.0:0.0:34.0:34.0:50.0:3.5:11.5:182.0:3:3]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:11:(int[]){17,13,2,9,9,4,0}:4.9:22000.0:1:0:0:22000.0:0.0:0.0:11.0:11.0:50.0:3.0:11.0:167.0:3:3]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:12:(int[]){20,7,6,12,6,7,0}:5.4:21000.0:1:0:0:21000.0:0.0:0.0:21.0:21.0:50.0:4.0:11.0:83.0:7:7]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:13:(int[]){6,7,2,9,12,19,0}:9.6:20000.0:1:0:0:20000.0:0.0:0.0:21.0:21.0:40.0:3.5:10.5:91.0:2:2]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:14:(int[]){7,14,9,18,2,2,1}:7.3:140000.0:2:2:0:50000.0:20000.0:0.0:35.0:35.0:50.0:3.5:10.0:141.0:2:2]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:15:(int[]){28,32,36,44,12,12,4}:7.3:68000.0:4:0:0:17000.0:0.0:0.0:31.0:31.0:40.0:4.5:9.5:172.0:1:1]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:16:(int[]){4,4,3,2,5,2,5}:6.7:14500.0:1:0:0:14500.0:0.0:0.0:46.0:46.0:40.0:5.5:9.5:246.0:2:2]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:17:(int[]){3,8,3,18,2,3,1}:9.9:14000.0:1:0:0:14000.0:0.0:0.0:12.0:12.0:50.0:4.0:10.5:151.0:2:2]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:18:(int[]){6,24,4,18,8,6,0}:6.0:22000.0:2:0:0:11000.0:0.0:0.0:36.0:36.0:40.0:4.5:9.5:209.0:1:1]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:19:(int[]){7,12,5,9,3,3,0}:5.5:11000.0:1:0:0:11000.0:0.0:0.0:3.0:3.0:50.0:4.0:10.5:238.0:2:2]];
    [self.Proteins addObject:[[pp_Protein alloc] initWithData:20:(int[]){1,5,0,2,3,2,0}:5.3:67000.0:1:0:0:67000.0:0.0:0.0:18.0:18.0:60.0:4.0:11.5:206.0:3:3]];
    
    float total_amount = 0.0;
    
    for (int item=1; item < self.Proteins.count; item++)
    {
        total_amount+= ((pp_Protein*)[self.Proteins objectAtIndex:item]).original_amount;
    }
    ((pp_Protein*)[self.Proteins objectAtIndex: 0]).amount = total_amount;
    ((pp_Protein*)[self.Proteins objectAtIndex: 0]).original_amount = total_amount;
    
    self.noOfProteins = 20;


}

float negCharge(float pH,float pK)
{
    float z = pow(10.0, pH - pK);
    return -z/(1.0+z);
}

float posCharge(float pH, float pK)
{
    float z = pow(10.0, pH - pK);
    return 1.0/(1.0 + z);
}


/*
// Incorporating values for residues in proteins from
// Bjellqvist, B. et al. (1993) Electrophoresis 14, 1023-1031
- (float) chargeAt:(float) pH protein:(int) protein_no
{
    // Calculate the total charge on one of the proteins at a particular pH value
    int chains = ((pp_Protein*)[self.Proteins objectAtIndex: protein_no]).NoOfSub1 + 
                 ((pp_Protein*)[self.Proteins objectAtIndex: protein_no]).NoOfSub2 + 
                 ((pp_Protein*)[self.Proteins objectAtIndex: protein_no]).NoOfSub3;
    
    NSMutableArray* charges = ((pp_Protein*)[self.Proteins objectAtIndex: protein_no]).charges;
  
    float z = [(NSNumber*)[charges objectAtIndex:0] integerValue] * negCharge(pH,4.05); // asp
    z += [(NSNumber*)[charges objectAtIndex:1] integerValue] * negCharge(pH,4.45);      // glu
    z += [(NSNumber*)[charges objectAtIndex:2] integerValue] * posCharge(pH,6.25);      // his
    z += [(NSNumber*)[charges objectAtIndex:3] integerValue] *posCharge(pH,10.2);       // lys
    z += [(NSNumber*)[charges objectAtIndex:4] integerValue];                           // arg 
    z += [(NSNumber*)[charges objectAtIndex:5] integerValue] * negCharge(pH,9.95);      // tyr
    z += [(NSNumber*)[charges objectAtIndex:6] integerValue] * negCharge(pH,8.3);       // cys
    z += chains * negCharge(pH,3.55);                                                   // C-alpha
    z += chains * posCharge(pH,7.5);                                                    // N-alpha

    return z;
}
 */

// My original
- (float) chargeAt:(float) pH protein:(int) protein_no
{
    // Calculate the total charge on one of the proteins at a particular pH value
    int chains = ((pp_Protein*)[self.Proteins objectAtIndex: protein_no]).NoOfSub1 +
    ((pp_Protein*)[self.Proteins objectAtIndex: protein_no]).NoOfSub2 +
    ((pp_Protein*)[self.Proteins objectAtIndex: protein_no]).NoOfSub3;
    
    NSMutableArray* charges = ((pp_Protein*)[self.Proteins objectAtIndex: protein_no]).charges;
    
    float z = [(NSNumber*)[charges objectAtIndex:0] integerValue] * negCharge(pH,4.6);  // asp
    z += [(NSNumber*)[charges objectAtIndex:1] integerValue] * negCharge(pH,4.6);       // glu
    z += [(NSNumber*)[charges objectAtIndex:2] integerValue] * posCharge(pH,6.65);      // his
    z += [(NSNumber*)[charges objectAtIndex:3] integerValue] *posCharge(pH,10.2);       // lys
    z += [(NSNumber*)[charges objectAtIndex:4] integerValue];                           // arg
    z += [(NSNumber*)[charges objectAtIndex:5] integerValue] * negCharge(pH,9.95);      // tyr
    z += [(NSNumber*)[charges objectAtIndex:6] integerValue] * negCharge(pH,8.3);       // cys
    z += chains * negCharge(pH,3.75);                                                   // C-alpha
    z += chains * posCharge(pH,7.8);                                                    // N-alpha
    
    return z;
}



- (float) IsoelectricPoint: (int) protein_no
{
    float pH = 7.0;
    float charge =  [self chargeAt:pH protein:protein_no];
    if (charge > 0.0) {
        while (charge > 0.0) {
            pH = pH + 1.0;
            charge = [self chargeAt:pH protein:protein_no];
        }
        while (charge < 0.0) {
            pH = pH - 0.1;
            charge = [self chargeAt:pH protein:protein_no];
        }
        while (charge > 0.0) {
            pH = pH + 0.01;
            charge = [self chargeAt:pH protein:protein_no];
        }
    }
    else {
        while (charge < 0.0) {
            pH = pH - 1.0;
            charge = [self chargeAt:pH protein:protein_no];
        }
        while (charge > 0.0) {
            pH = pH + 0.1;
            charge = [self chargeAt:pH protein:protein_no];
        }
        while (charge < 0.0) {
            pH = pH - 0.01;
            charge = [self chargeAt:pH protein:protein_no];
        }
    }
    return pH;
}

- (void) parseData: (NSString*) fileString
{

    self.hasScheme = NO;
    
    NSArray* list = [fileString componentsSeparatedByString:@"\n"];
           
    // create a new list of lines - with comment lines removed
    NSMutableArray* newlist = [[NSMutableArray alloc] initWithCapacity:[list count]];
       
    for (int i=0; i<[list count]; i++)
    {
        // Skip comment lines
        if ([[list objectAtIndex:i] hasPrefix:@"//"]) 
            continue;
        else // Add non-comment line
        {
            // Strip off any remaining control characters
            NSCharacterSet* charSet = [NSCharacterSet controlCharacterSet];
            NSString* cleaned = [[list objectAtIndex:i] stringByTrimmingCharactersInSet:charSet];
            [newlist addObject:cleaned];
        }       
    }
            
    // At this point newlist contains the protein data text with the comment lines removed.
    
    self.noOfProteins = [[newlist objectAtIndex:0] intValue];
    
    if (self.noOfProteins==0) return;
    
    // Delete any existing mixture data
    if (self.Proteins) 
	{	
		self.Proteins = nil;
		
	}
            
    self.Proteins = [[NSMutableArray alloc] initWithCapacity:[newlist count] ];
    [self.Proteins addObject:[[[pp_Protein alloc] initWithData:0:(int[]){0,0,0,0,0,0,0}:0.0:0.0:0:0:0:0.0:0.0:0.0:0.0:0.0:0.0:0.0:0.0:0.0:0:0]autorelease]];
            
 
            
    for (int protein=1; protein <= self.noOfProteins; protein++) 
    {
                
        NSArray* line = [[newlist objectAtIndex:protein] componentsSeparatedByString:@","];

        if (line.count != 22) // wrong number of elements in the line
        {
            self.noOfProteins = -1;
            return;
        }
        
        int charges[7];
        for (int i=0; i<7; i++)
            charges[i] = [[line objectAtIndex:i] intValue];
                
        float isopoint=0.0;    // not in file - calculate it later
        float MolWt = [[line objectAtIndex:7] floatValue];
        int NoOfSub1 = [[line objectAtIndex:8] intValue];
        int NoOfSub2 = [[line objectAtIndex:9] intValue];
        int NoOfSub3 = [[line objectAtIndex:10] intValue];
        float subunit1 = [[line objectAtIndex:11] floatValue];
        float subunit2 = [[line objectAtIndex:12] floatValue];
        float subunit3 = [[line objectAtIndex:13] floatValue];
        float original_amount = [[line objectAtIndex:14] floatValue];
        float amount = [[line objectAtIndex:15] floatValue];
        float temp = [[line objectAtIndex:16] floatValue];
        float pH1 = [[line objectAtIndex:17] floatValue];
        float pH2 = [[line objectAtIndex:18] floatValue];
        float sulphate = [[line objectAtIndex:19] floatValue];
        int original_activity = [[line objectAtIndex:20] intValue];
        int activity = [[line objectAtIndex:21] intValue];
                
        [self.Proteins addObject:[[[pp_Protein alloc] initWithData:protein:charges:isopoint:MolWt:NoOfSub1:NoOfSub2:NoOfSub3:subunit1:subunit2:subunit3:original_amount:amount:temp:pH1:pH2:sulphate:original_activity:activity]autorelease]];
                
        // calculate the missing values
        ((pp_Protein*)[self.Proteins objectAtIndex: protein]).isopoint = [self IsoelectricPoint:protein];
                
        ((pp_Protein*)[self.Proteins objectAtIndex: 0]).amount += amount;
        ((pp_Protein*)[self.Proteins objectAtIndex: 0]).original_amount += original_amount;
               
    }
    // Check to see if there are any more data. If not, then return.
    if (self.noOfProteins == [newlist count]-2) return;
    
    //if there are more data, there should be a history
    
    self.hasScheme = YES;
    
}

- (void) parseScheme: (NSString*) fileString
{
    NSArray* list = [fileString componentsSeparatedByString:@"\n"];
    
    // create a new list of lines - with comment lines removed
    NSMutableArray* newlist = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i=0; i<[list count]; i++)
    {
        // Skip comment lines
        if ([[list objectAtIndex:i] hasPrefix:@"//"])
            continue;
        else // Add non-comment line
        {
            // Strip off any remaining control characters
            // because the lines may have ended \n\r or \r\n.
            NSCharacterSet* charSet = [NSCharacterSet controlCharacterSet];
            NSString* cleaned = [[list objectAtIndex:i] stringByTrimmingCharactersInSet:charSet];
            [newlist addObject:cleaned];
        }
    }
    
    // At this point newlist contains the protein data text with the comment lines removed.
    // Find how many proteins are in the mixture
    self.noOfProteins = [[newlist objectAtIndex:0] intValue];
    
    // Now skip to the scheme data
    self.enzyme = [[newlist objectAtIndex:self.noOfProteins+1] intValue];
    
    // Now that we know which enzyme is selected, we can (re)initialize the
    // Command variables and create new Account and Separation objects.
    [app.commands conditionStart:NO];
    
    self.step =  [[newlist objectAtIndex:self.noOfProteins+2] intValue];
    
    float enzyme_units = 0.0;
    float costing = 0.0;
    
    // Populate the Account object with StepRecord objects
    for (int j = 1; j<=self.step;  j++)
    {
        NSString* line = [newlist objectAtIndex:self.noOfProteins+3+j];
        NSArray* item =  [line componentsSeparatedByString:@","];
        
        pp_StepRecord* record = [[pp_StepRecord alloc] init];
        [record setStepType: [[item objectAtIndex:0] intValue]];
        [record setProteinAmount:[[item objectAtIndex:1] floatValue]];
        enzyme_units = [[item objectAtIndex:2] floatValue];
        [record setEnzymeUnits: enzyme_units];
        [record setEnzymeYield:[[item objectAtIndex:3] floatValue]];
        [record setEnrichment:[[item objectAtIndex:4] floatValue]];
        costing = [[item objectAtIndex:5] floatValue];
        [record setCosting:costing];
        
        [app.account appendRecord:record];
    }
    [app.account setCost:costing*enzyme_units/100.0];
}

- (NSMutableArray*) GetChargesOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).charges;
}

- (float) GetMolWtOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).MolWt;
}

- (int) GetNoOfSub1OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).NoOfSub1;
}

- (int) GetNoOfSub2OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).NoOfSub2;
}

- (int) GetNoOfSub3OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).NoOfSub3;
}

- (float) GetSubunit1OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).subunit1;
}

- (float) GetSubunit2OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).subunit2;
}

- (float) GetSubunit3OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).subunit3;
}

- (float) GetIsoPointOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).isopoint;
}

- (float) GetTempOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).temp;
}

- (float) GetK1OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).K1;
}

- (float) GetK2OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).K2;
}

- (float) GetK3OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).K3;
}

- (void) SetK1OfProtein: (int) proteinNo value: (float) K1
{
    ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).K1 = K1;
}

- (void) SetK2OfProtein: (int) proteinNo value: (float) K2
{
    ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).K2 = K2;
}

- (void) SetK3OfProtein: (int) proteinNo value: (float) K3
{
    ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).K3 = K3;
}

- (float) GetpH1OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).pH1;
}

- (float) GetpH2OfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).pH2;
}

- (float) GetSulphateOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).sulphate;
}

- (void) ResetSoluble
{
	self.Soluble = [[[NSMutableArray alloc] init] autorelease];
    [self.Soluble addObject:[NSNumber numberWithFloat: 0.0]];
    
}

- (float) GetSolubleOfProtein: (int) proteinNo
{
    return [[self.Soluble objectAtIndex:proteinNo] floatValue];
}

- (void) SetSolubleOfProtein: (int) proteinNo  value: (float) soluble
{
    [self.Soluble replaceObjectAtIndex:proteinNo withObject:[NSNumber numberWithFloat: soluble]];
}

- (void) AppendSoluble: (float) amount
{
    [self.Soluble addObject:[NSNumber numberWithFloat: amount]];
}
     
- (void) ResetInsoluble
{
	self.Insoluble = [[[NSMutableArray alloc] init] autorelease];
    [self.Insoluble addObject:[NSNumber numberWithFloat: 0.0]];
}

- (float) GetInsolubleOfProtein: (int) proteinNo
{
    return [[self.Insoluble objectAtIndex:proteinNo] floatValue];
}

- (void) SetInsolubleOfProtein: (int) proteinNo  value: (float) soluble
{
    [self.Insoluble replaceObjectAtIndex:proteinNo withObject:[NSNumber numberWithFloat: soluble]];
}

- (void) AppendInsoluble: (float) amount
{
    [self.Insoluble addObject:[NSNumber numberWithFloat: amount]];
}

- (float) GetCurrentAmountOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).amount;
}

- (void) SetCurrentAmountOfProtein: (int) proteinNo  value: (float) amount
{
    ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).amount =  amount;
}

- (float) GetOriginalAmountOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).original_amount;
}

- (void) SetOriginalAmountOfProtein: (int) proteinNo  value: (float) amount
{
    ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).original_amount =  amount;
}

- (int) GetOriginalActivityOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).original_activity;
}

- (void) SetOriginalActivityOfProtein: (int) proteinNo  value: (int) activity
{
    ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).original_activity =  activity;
}

- (int) GetCurrentActivityOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).activity;
}

- (void) SetCurrentActivityOfProtein: (int) proteinNo  value: (int) activity
{
    ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).activity =  activity;
}

- (BOOL) GetHisTagOfProtein: (int) proteinNo
{
    return ((pp_Protein*)[self.Proteins objectAtIndex:proteinNo]).hisTag;
}

- (float) GetTotalAmount
{
    float total_amount = 0.0;
    
    // add it up
    for (int item=1; item <= self.noOfProteins; item++)
        total_amount += [self GetCurrentAmountOfProtein:item];
    
    // store the result in protein zero
    [self SetCurrentAmountOfProtein:0 value: total_amount];
    
    return total_amount;
}

- (void) IncrementStep
{
    self.step++;
}

- (NSString*) writeMixture:(pp_Account*) account
{
    NSString* buf = @"";
    buf = [buf stringByAppendingString:@"// The first non-comment line must contain the number of proteins in this mixture\n"];
    buf = [buf stringByAppendingString:@"// and nothing else.\n"];
    buf = [buf stringByAppendingString:@"//\n"];
    buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d\n",noOfProteins]];
    buf = [buf stringByAppendingString:@"//\n"];
    buf = [buf stringByAppendingString:@"//\n"];
    buf = [buf stringByAppendingString:@"// The subsequent lines contain the data for each protein in the mixture.\n"];
    buf = [buf stringByAppendingString:@"// Each line must contain only comma-separated numbers with no white space or breaks.\n"];
    buf = [buf stringByAppendingString:@"// On each line the fields are as follows:\n"];
    buf = [buf stringByAppendingString:@"// Fields 1-7 contain the total numbers of ASP,GLU,HIS,LYS,ARG,TYR and CYS-SH\n"];
    buf = [buf stringByAppendingString:@"// residues respectively in the whole protein molecule (i.e aggregated over\n"];
    buf = [buf stringByAppendingString:@"// all polypeptide chains). These data are used to calculate the protein's charge\n"];
    buf = [buf stringByAppendingString:@"// at any pH value, and hence also to calculate the isoelectric point.\n"];
    buf = [buf stringByAppendingString:@"// Field 3 will be negative and less than -5 if a His tag is present.\n"];
    buf = [buf stringByAppendingString:@"// Field 8 contains the overall native molecular weight of the protein.\n"];
    buf = [buf stringByAppendingString:@"// Each protein can have up to three different types of polypeptide chain.\n"];
    buf = [buf stringByAppendingString:@"// Field 9 contains the number of polypeptides of type 1. This must always be greater than zero.\n"];
    buf = [buf stringByAppendingString:@"// Field 10 contains the number of polypeptides of type 2 if any or zero if not.\n"];
    buf = [buf stringByAppendingString:@"// Field 11 contains the number of polypeptides of type 3 if any or zero if not.\n"];
    buf = [buf stringByAppendingString:@"// Field 12 contains the molecular weight of polypeptide type 1. This cannot be zero.\n"];
    buf = [buf stringByAppendingString:@"// Field 13 contains the molecular weight of polypeptide type 2\n"];
    buf = [buf stringByAppendingString:@"//   or zero if there is only one type of polypeptide.\n"];
    buf = [buf stringByAppendingString:@"// Field 14 contains the molecular weight of polypeptide type 3\n"];
    buf = [buf stringByAppendingString:@"//   or zero if there is only one type of polypeptide.\n"];
    buf = [buf stringByAppendingString:@"// Field 15 contains the amount (in mg) of this protein in the initial mixture\n"];
    buf = [buf stringByAppendingString:@"// Field 16 contains the amount (in mg) of this protein in the mixture in its\n"];
    buf = [buf stringByAppendingString:@"//   current state.  This is to allow partially purified mixtures to be saved and\n"];
    buf = [buf stringByAppendingString:@"//   reloaded. When designing a mixture, set this field to the same value as field 15.\n"];
    buf = [buf stringByAppendingString:@"// Field 17 contains the temperature below which the enzyme activity is stable.\n"];
    buf = [buf stringByAppendingString:@"// Fields 18 and 19 contain the pH values between which the enzyme activity is stable\n"];
    buf = [buf stringByAppendingString:@"// Field 20 is no longer used.\n"];
    buf = [buf stringByAppendingString:@"// Field 21 contains an integer which represents the initial specific enzymic activity\n"];
    buf = [buf stringByAppendingString:@"//   of the protein.\n"];
    buf = [buf stringByAppendingString:@"// Field 22 contains an integer which represents the current specific activity.\n"];
    buf = [buf stringByAppendingString:@"//   This will normally be the same as the value of field 21 unless denaturation has occurred.\n"];
    buf = [buf stringByAppendingString:@"//\n"];
    buf = [buf stringByAppendingString:@"// Comment lines must begin with //.\n"];
    buf = [buf stringByAppendingString:@"// Blank lines are not allowed except at the end of the file.\n"];
    buf = [buf stringByAppendingString:@"// Be careful - there is no value/error checking done on these values.\n"];
    buf = [buf stringByAppendingString:@"// A bad file will probably crash the app. The usual disclaimers apply.\n"];
    buf = [buf stringByAppendingString:@"//\n"];
    buf = [buf stringByAppendingString:@"//                                                Andrew Booth 18th August 2012\n"];
    buf = [buf stringByAppendingString:@"//\n"];
    buf = [buf stringByAppendingString:@"// These are the data for this mixture:\n"];
    buf = [buf stringByAppendingString:@"//\n"];
    for (int p=1; p<self.Proteins.count; p++)      //proteins[0] is not written to file
    {
        
        NSMutableArray* charges = [[NSMutableArray alloc] init];
        [charges addObjectsFromArray:[self GetChargesOfProtein:p]];
        
        if ([self GetHisTagOfProtein:p])
        {
            int his = [[charges objectAtIndex:2] intValue];
            his = -his;
            [charges replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:his]];
            
        }
        
        for (int item=0; item<7; item++)
        {
            buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d,",((NSNumber*)[charges objectAtIndex:item]).intValue]];
        }
        
        // isoelectric point is not written to the file
        
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetMolWtOfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d,",[self GetNoOfSub1OfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d,",[self GetNoOfSub2OfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d,",[self GetNoOfSub3OfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetSubunit1OfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetSubunit2OfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetSubunit3OfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetOriginalAmountOfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetCurrentAmountOfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetTempOfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetpH1OfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[self GetpH2OfProtein:p]]];
        buf = [buf stringByAppendingString:@"0,"];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d,",[self GetOriginalActivityOfProtein:p]]];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d\n",[self GetCurrentActivityOfProtein:p]]];
        
    }
    if (step > 0)  // save the history
    {
        buf = [buf stringByAppendingString:@"//\n"];
        buf = [buf stringByAppendingString:@"// The scheme purification history follows:\n"];
        buf = [buf stringByAppendingString:@"// Enzyme\n"];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d\n",enzyme]];
        buf = [buf stringByAppendingString:@"// Purification steps so far\n"];
        buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d\n",step]];
        buf = [buf stringByAppendingString:@"// Method, Protein (mg), Enzyme (Units), Enzyme Yield, Enrichment, Cost\n"];
        for (int i=0; i<=step; i++)
        {
            pp_StepRecord* stepRec = [account getStepRecord:i];
            buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%d,",[stepRec getStepType]]];
            buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[stepRec getProteinAmount]]];
            buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[stepRec getEnzymeUnits]]];
            buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[stepRec getEnzymeYield]]];
            buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f,",[stepRec getEnrichment]]];
            buf = [buf stringByAppendingString:[NSString stringWithFormat:@"%f\n",[stepRec getCosting]]];
            
        }
    }
    return buf;
}

@end
