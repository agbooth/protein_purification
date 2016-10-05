//
//  pp_Account.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 05/08/2012.
//
//

#import "pp_Account.h"

@implementation pp_Account {

pp_ProteinData* pd;
pp_Commands* pc;
pp_StepRecord* record;
NSMutableArray* account;
float costing;
int enzyme;
float enz;
    
}

- (pp_Account*) init {
    
    self = [super init];
    if (self)
    {
        pd = app.proteinData;
        pc = app.commands;
        
        account = [[NSMutableArray alloc] init];
        costing = 0.0;
        
        // add the data for the initial mixture
        record = [[pp_StepRecord alloc] init];
        [record setStepType: None];
        [record setProteinAmount:[pd GetOriginalAmountOfProtein:0]];
        
        enzyme = pd.enzyme;
        enz = [pd GetOriginalAmountOfProtein:enzyme]*[pd GetOriginalActivityOfProtein:enzyme]*100.0;
        [record setEnzymeUnits:enz];
        [record setEnzymeYield:100.0];
        [record setEnrichment:1.0];
        [record setCosting:costing];
        
        [account addObject:record];
        
    }
    return self;
}

- (void) addCost: (float) cost
{
    costing += cost;
}

- (float) getCost
{
    return costing;
}

- (void) setCost: (float) cost
{
    costing = cost;
}

- (void) appendRecord: (pp_StepRecord*) record
{
    [account addObject:record];
}

- (void) addStepRecord
{
    // add the data for the current state of the mixture
    enzyme = pd.enzyme;
    
    float ActivityFactor = (float)[pd GetCurrentActivityOfProtein:enzyme]/(double)[pd GetOriginalActivityOfProtein:enzyme];
    enz = [pd GetCurrentAmountOfProtein:enzyme]*[pd GetOriginalActivityOfProtein:enzyme]*100.0;
    
    float enzyield;
    if ([pd GetCurrentAmountOfProtein:enzyme]==0.0)
        enzyield = 0.0;
    else
        enzyield = [pd GetCurrentAmountOfProtein:enzyme]/[pd GetOriginalAmountOfProtein:enzyme]*100.0*ActivityFactor;
    
    float enrich;
    if (enzyield < 0.01)
        enrich = 0.0;
    else
        enrich = ([pd GetCurrentAmountOfProtein:enzyme]/[pd GetCurrentAmountOfProtein:0])/([pd GetOriginalAmountOfProtein:enzyme]/[pd GetOriginalAmountOfProtein:0])*ActivityFactor;
    
    float cost;
    if (enz > 0.01)
        cost = costing*100.0/enz;
    else
        cost = 0.0;
    
    if (record) record=nil;
    record = [[pp_StepRecord alloc]init];
    [record setStepType:pc.sepType];
    [record setProteinAmount:[pd GetCurrentAmountOfProtein:0]];
    [record setEnzymeUnits:enz];
    [record setEnzymeYield:enzyield];
    [record setEnrichment:enrich];
    [record setCosting:cost];
    
    [account addObject:record];
    
}

- (pp_StepRecord*) getStepRecord: (int) i
{
    return [account objectAtIndex:i];
}


@end
