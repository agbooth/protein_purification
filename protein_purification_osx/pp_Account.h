//
//  pp_Account.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 05/08/2012.
//
//

#import <Foundation/Foundation.h>
#import "pp_AppDelegate.h"
#import "pp_StepRecord.h"
#import "pp_Commands.h"
#import "pp_ProteinData.h"

@class pp_AppDelegate;
@class pp_Commands;
@class pp_StepRecord;

@interface pp_Account : NSObject
{
	pp_ProteinData* pd;
	pp_Commands* pc;
	pp_StepRecord* record;
	NSMutableArray* account;
	float costing;
	int enzyme;
	float enz;
}
@property (retain) NSMutableArray* account;

- (pp_Account*) init;
- (void) addCost: (float) cost;
- (float) getCost;
- (void) setCost: (float) cost;
- (void) appendRecord: (pp_StepRecord*) record;
- (void) addStepRecord;
- (pp_StepRecord*) getStepRecord: (int) i;
@end
