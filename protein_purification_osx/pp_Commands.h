//
//  pp_Commands.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 22/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pp_AppDelegate.h"


enum
{
    None,
    Ammonium_sulfate,
    Heat_treatment,
    Gel_filtration,
    Ion_exchange,
    Hydrophobic_interaction,
    Affinity,
    Sephadex_G50,
    Sephadex_G100,
    Sephacryl_S200,
    Ultrogel_54,
    Ultrogel_44,
    Ultrogel_34,
    BioGel_P60,
    BioGel_P150,
    BioGel_P300,
    DEAE_cellulose,
    CM_cellulose,
    Q_Sepharose,
    S_Sepharose,
    Phenyl_Sepharose,
    Octyl_Sepharose,
    AntibodyA,
    AntibodyB,
    AntibodyC,
    Polyclonal,
    Immobilized_inhibitor,
    NiNTAagarose,
    Tris,
    Acid,
    Inhibitor,
    Imidazole
};

@interface pp_Commands : NSObject
{
	int sepType;
	int sepMedia;
	bool  pooled;
	bool  assayed;
	bool  hasFractions;
	bool  hasGradient;
	float elutionpH;
	bool  gradientIsSalt;
	float startGrad;
	float endGrad;
	bool  overDiluted;
	float scale;
	int affinityElution;
	int startOfPool;
	int endOfPool;
	int noOfFractions;
	bool comingFromHelp;
	bool oneDshowing;
	bool twoDshowing;
	bool twoDGel;
	bool showBlot;
	bool hires;
	float included;
	float excluded;
	bool titratable;
	NSMutableArray* frax;
}

@property (nonatomic) int sepType;
@property (nonatomic) int sepMedia;
@property (nonatomic) bool  pooled;
@property (nonatomic) bool  assayed;
@property (nonatomic) bool  hasFractions;
@property (nonatomic) bool  hasGradient;
@property (nonatomic) float elutionpH;
@property (nonatomic) bool  gradientIsSalt;
@property (nonatomic) float startGrad;
@property (nonatomic) float endGrad;
@property (nonatomic) bool  overDiluted;
@property (nonatomic) float scale;
@property (nonatomic) int affinityElution;
@property (nonatomic) int startOfPool;
@property (nonatomic) int endOfPool;
@property (nonatomic) int noOfFractions;
@property (nonatomic) bool comingFromHelp;
@property (nonatomic) bool oneDshowing;
@property (nonatomic) bool twoDshowing;
@property (nonatomic) bool twoDGel;
@property (nonatomic) bool showBlot;
@property (nonatomic) bool hires;
@property (nonatomic) float included;
@property (nonatomic) float excluded;
@property (nonatomic) bool titratable;
@property (nonatomic, retain) NSMutableArray* frax;



- (pp_Commands*) init;

- (void)dispatch:(id)sender;
- (void) about_command;

- (void) start_command;
- (void) start_stored;
- (Boolean) store_command;
- (void) abandon_scheme_command;
- (void) abandon_step_command;
- (void) amm_sulf_command;
- (void) heat_treatment_command;
- (void) gel_filtration_command;
- (void) ion_exchange_command;
- (void) HIC_command;
- (void) affinity_command;

- (void) oneD_PAGE_command;
- (void) twoD_PAGE_command;
- (void) coomassie_command;
- (void) immunoblot_command;
- (void) hide_command;

- (void) assay_command;
- (void) dilute_command;
- (void) pool_command;

- (void) enter_reg_command;
- (void) register_command;
- (void) tutorial_command;

- (void) activateSeparationMenu: (BOOL) activate;
- (void) activateElectroMenu: (BOOL) activate;
- (void) activateFractionsMenu: (BOOL) activate;

- (void) doAmmoniumSulfate: (float) percent;
- (void) doHeatTreatment:(float)temperature forTime:(float) time;
- (void) doGelFiltration;
- (void) doIonExchange;
- (void) doHIC;
- (void) doAffinity;

- (void) doPoolFractions;

- (void) loadMixtureData: (NSString*) sender;
- (void) conditionStart:(BOOL)refill;
- (void) endSplash;
- (void) startSplash;
- (void) finishStep;
- (void) setToRunning;
- (BOOL) showProgress;

@end
