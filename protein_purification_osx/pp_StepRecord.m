//
//  pp_StepRecord.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 05/08/2012.
//
//

#import "pp_StepRecord.h"

@implementation pp_StepRecord

@synthesize dict;

- (pp_StepRecord*) init
{
    self = [super init];
    self.dict = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
    [self.dict setObject:[NSNumber numberWithInt:0] forKey:@"steptype"];
    [self.dict setObject:[NSNumber numberWithFloat:0.0] forKey:@"proteinamount"];
    [self.dict setObject:[NSNumber numberWithFloat:0.0] forKey:@"enzymeunits"];
    [self.dict setObject:[NSNumber numberWithFloat:0.0] forKey:@"enzymeyield"];
    [self.dict setObject:[NSNumber numberWithFloat:0.0] forKey:@"enrichment"];
    [self.dict setObject:[NSNumber numberWithFloat:0.0] forKey:@"costing"];
    return self;    
}

- (void) setStepType: (int) steptype
{
    [self.dict setObject:[NSNumber numberWithInt:steptype] forKey:@"steptype"];
}

- (int) getStepType
{
    return [[self.dict objectForKey:@"steptype"] intValue];
}

- (void) setProteinAmount: (float) amount
{
    [self.dict setObject:[NSNumber numberWithFloat:amount] forKey:@"proteinamount"];
}

- (float) getProteinAmount
{
    return [[self.dict objectForKey:@"proteinamount"] floatValue];
}

- (void) setEnzymeUnits: (float) units
{
    [self.dict setObject:[NSNumber numberWithFloat:units] forKey:@"enzymeunits"];
}

- (float) getEnzymeUnits
{
    return [[self.dict objectForKey:@"enzymeunits"] floatValue];
}

- (void) setEnzymeYield: (float) enzyield
{
    [self.dict setObject:[NSNumber numberWithFloat:enzyield] forKey:@"enzymeyield"];
}

- (float) getEnzymeYield
{
    return [[self.dict objectForKey:@"enzymeyield"] floatValue];
}

- (void) setEnrichment: (float) enrichment
{
    [dict setObject:[NSNumber numberWithFloat:enrichment] forKey:@"enrichment"];
}

- (float) getEnrichment
{
    return [(NSNumber*)[self.dict objectForKey:@"enrichment"] floatValue];
}

- (void) setCosting: (float) costing
{
    [self.dict setObject:[NSNumber numberWithFloat:costing] forKey:@"costing"];
}

- (float) getCosting
{
    return [(NSNumber*)[self.dict objectForKey:@"costing"] floatValue];
}

- (void) incrementCosting: (float) increment
{
    float costing = [(NSNumber*)[self.dict objectForKey:@"costing"] floatValue];
    costing += increment;
    [self.dict setObject:[NSNumber numberWithFloat:costing] forKey:@"costing"];
}

@end
