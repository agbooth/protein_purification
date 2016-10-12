//
//  pp_Separation.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 02/08/2012.
//
//

#import "pp_AppDelegate.h"

@interface pp_Separation : NSObject
{
	NSString* sepString;
	NSString* mediumString;
}

@property (nonatomic, retain) NSString* sepString;
@property (nonatomic, retain) NSString* mediumString;


- (pp_Separation*) init;
- (float) Gauss: (int) i pos: (int) x;
- (void) SetPlotArray;
- (float) GetPlotElement: (int) fraction protein: (int) protein;

- (void) HeatTreatment: (float) temperature duration: (float) duration;

- (void) AmmoniumSulphateFractionation;

- (void) AS: (float) saturation;

- (void) GelFiltrationElution: (float) excluded included: (float) included hires: (bool) hires;

- (void) DEAESaltElution: (float) startgrad  endGrad: (float) endgrad pH: (float) pH titrable: (bool) titratable;

- (void) DEAEpHElution: (float) startgrad  endGrad: (float) endgrad pH: (float) pH titrable: (bool) titratable;

- (void) CMSaltElution: (float) startgrad  endGrad: (float) endgrad pH: (float) pH titrable: (bool) titratable;

- (void) CMpHElution: (float) startgrad  endGrad: (float) endgrad pH: (float) pH titrable: (bool) titratable;

- (void) HICElution: (float) startgrad endGrad: (float) endgrad  medium: (int) medium salt_concn: (float) salt_concn;

- (void) Affinity_elution:(int) affinity_medium affinity_elution: (int) affinity_elution;

- (void) PoolFractionsFrom: (int) start To: (int) end;

- (NSString*) CheckPrecipitatedWith: (float) salt_conc;

- (void) doPrecipitate;

@end
