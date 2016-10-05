//
//  pp_Protein.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 20/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_Protein.h"

@implementation pp_Protein

@synthesize no;
@synthesize charges;
@synthesize isopoint;
@synthesize MolWt;
@synthesize NoOfSub1;
@synthesize NoOfSub2;
@synthesize NoOfSub3;
@synthesize subunit1;
@synthesize subunit2;
@synthesize subunit3;
@synthesize original_amount;
@synthesize amount;
@synthesize temp;
@synthesize pH1;
@synthesize pH2;
@synthesize sulphate;
@synthesize activity;
@synthesize original_activity;
@synthesize K1;
@synthesize K2;
@synthesize K3;
@synthesize hisTag;

// Single colon parameter names to allow initWithData:::::::::::::::
- (pp_Protein*) initWithData:(int) in_no
                     :(int[]) in_charges
                     :(float) in_isopoint
                     :(float) in_MolWt
                     :(int) in_NoOfSub1
                     :(int) in_NoOfSub2
                     :(int) in_NoOfSub3
                     :(float) in_subunit1
                     :(float) in_subunit2
                     :(float) in_subunit3
                     :(float) in_original_amount
                     :(float) in_amount
                     :(float) in_temp
                     :(float) in_pH1
                     :(float) in_pH2
                     :(float) in_sulphate
                     :(int) in_original_activity
                     :(int) in_activity

{
    self.no = in_no;
    self.charges = [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt:abs(in_charges[0])],  //asp
                                                            [NSNumber numberWithInt:abs(in_charges[1])],  //glu
                                                            [NSNumber numberWithInt:abs(in_charges[2])],  //his
                                                            [NSNumber numberWithInt:abs(in_charges[3])],  //lys
                                                            [NSNumber numberWithInt:abs(in_charges[4])],  //arg
                                                            [NSNumber numberWithInt:abs(in_charges[5])],  //tyr
                                                            [NSNumber numberWithInt:abs(in_charges[6])],  //cys
                                                            nil];
    if (in_charges[2] < -5 ) self.hisTag = YES;
    else self.hisTag = NO;
    
    
    self.isopoint = in_isopoint;
    self.MolWt = in_MolWt;
    self.NoOfSub1 = in_NoOfSub1;
    self.NoOfSub2 = in_NoOfSub2;
    self.NoOfSub3 = in_NoOfSub3;
    self.subunit1 = in_subunit1;
    self.subunit2 = in_subunit2;
    self.subunit3 = in_subunit3;
    self.original_amount = in_original_amount;
    self.amount = in_amount;
    self.temp = in_temp;
    self.pH1 = in_pH1;
    self.pH2 = in_pH2;
    self.sulphate = in_sulphate;
    self.activity = in_activity;
    self.original_activity = in_original_activity;
    self.K1 = 0.0;
    self.K2 = 0.0;
    self.K3 = 0.0;
    
    return self;
    
}


@end
