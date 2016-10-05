//
//  pp_StepRecord.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 05/08/2012.
//
//

#import <Foundation/Foundation.h>

@interface pp_StepRecord : NSObject
@property (nonatomic, retain) NSMutableDictionary* dict;

- (pp_StepRecord*) init;
- (void) setStepType: (int) steptype;
- (int) getStepType;
- (void) setProteinAmount: (float) amount;
- (float) getProteinAmount;
- (void) setEnzymeUnits: (float) units;
- (float) getEnzymeUnits;
- (void) setEnzymeYield: (float) enzyield;
- (float) getEnzymeYield;
- (void) setEnrichment: (float) enrichment;
- (float) getEnrichment;
- (void) setCosting: (float) costing;
- (float) getCosting;
- (void) incrementCosting:(float) increment;
@end
