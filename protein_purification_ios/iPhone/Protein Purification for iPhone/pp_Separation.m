//
//  pp_Separation.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 02/08/2012.
//

/* This class contains the functions for calculating how the proteins
   separate when each technique is applied. It sets the three constants
   for the Gaussian curves that describe the distribution of each protein.
 */

#import "pp_Separation.h"

@implementation pp_Separation {
    
    pp_ProteinData* pd;
    pp_Commands* pc;
    
    NSMutableArray* fractions;
    
}

@synthesize sepString;
@synthesize mediumString;

- (pp_Separation*) init {
    
    self = [super init];
    if (self)
    {
        pd = app.proteinData;
        pc = app.commands;
    }
    return self;
}

- (float) Gauss: (int) i pos: (int) x
{
    float exponent = ((float)x - [pd GetK1OfProtein:i])/[pd GetK2OfProtein:i];
    exponent *= exponent/2.0;
    if (exponent > 50.0) return 0.0;
    else return [pd GetK3OfProtein:i] * exp(-exponent);
}

- (void) SetPlotArray
{
    
    if (fractions) fractions = nil;
    
    fractions = [[NSMutableArray alloc] init];
    // there is no fraction zero, so put a dummy object into the array
    [fractions addObject:[[NSObject alloc] init]];
    
    for (int fraction=1; fraction<251; fraction++)
    {
        // Work out the fractional composition of each protein
        // done by calculating the Gaussian curve for each.
        // Protein zero is the sum of all proteins.
        
        NSMutableArray* absorbance = [[NSMutableArray alloc] init];
        [absorbance addObject:[[NSNumber alloc] initWithFloat:0.0]];
        
        // For each fraction, work out how much of each protein it contains
        for (int i=1; i<=app.proteinData.noOfProteins; i++)
        {
            // avoid a division by zero
            if ([app.proteinData GetK2OfProtein:i]< 0.00001)
                [app.proteinData SetK2OfProtein:i value:0.00001];
            
            float value = [self Gauss:i pos:fraction];
            
            [absorbance addObject:[[NSNumber alloc] initWithFloat:value]];
            
            // Total amount in this fraction is held by 'protein 0'.
            float total = [[absorbance objectAtIndex:0] floatValue];
            total += value;
            [absorbance replaceObjectAtIndex:0 withObject:[[NSNumber alloc] initWithFloat:total]];
            
        }
        [fractions addObject:absorbance];
    }
}

- (float) GetPlotElement: (int) fraction protein: (int) protein
{
    
    NSMutableArray* proteins = [fractions objectAtIndex:fraction];
    return [[proteins objectAtIndex:protein] floatValue];
    
}

- (void) HeatTreatment: (float) temperature duration: (float) duration
{
    [pd ResetSoluble];
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        [pd AppendSoluble:[pd GetCurrentAmountOfProtein:i]];
        
        float exponent = ( temperature - [pd GetTempOfProtein:i])/200.0 * duration;
        
        if (exponent > 0.0)
        {
            if (exponent < 50.0)
                [pd SetSolubleOfProtein:i value:[pd GetSolubleOfProtein:i] * exp(-exponent)];
            else
                [pd SetSolubleOfProtein:i value:0.0];
        }
        [pd SetSolubleOfProtein:0 value:[pd GetSolubleOfProtein:0] + [pd GetSolubleOfProtein:i]];
    }
    for (int i=0; i<=pd.noOfProteins; i++)
    {
        if ([pd GetSolubleOfProtein:i] < 0.0) [pd SetSolubleOfProtein:i value:0.0];
        [pd SetCurrentAmountOfProtein:i value:[pd GetSolubleOfProtein:i]];
    }
}

// Calculates the log of the solubility in the absence of salt
- (float) getLogSzero: (int) proteinNo
{
    // Get the number of negatively charged residues - all assumed to be exposed and fully charged at pH 7
    // including C Termini but excluding CYS and TYR
    NSMutableArray* charges = ((pp_Protein*)[pd.Proteins objectAtIndex:proteinNo]).charges;
    int negCharges =  [[charges objectAtIndex:0] intValue]
                    + [[charges objectAtIndex:1] intValue]
                    + [pd GetNoOfSub1OfProtein:proteinNo]
                    + [pd GetNoOfSub2OfProtein:proteinNo]
                    + [pd GetNoOfSub3OfProtein:proteinNo];
    
    // Get the overall molecular weight
    float MolWt = [pd GetMolWtOfProtein:proteinNo];
    
    // Assume the protein is spherical and calculate 'molecular radius'
    float MolRad = pow(MolWt*0.75/M_PI,1.0/3.0);
    
    // Calculate the 'molecular surface area'
    float MolArea = 4.0*M_PI*MolRad*MolRad;
    
    // Calculate negative charge per unit area
    float chargePerArea = (float)negCharges/MolArea;
    
    // Convert to Log Szero - factor is from experimental data (nice round figure!)
    return chargePerArea * 600.0;
}

//Calculates the salt concentration required to give a solubility of 10mg/mL
// Same parameters as ammonium sulphate fractionation.
- (float) getSalt: (int) proteinNo
{
    return ([self getLogSzero:proteinNo]-1.0)/([self getLogSzero:proteinNo]/2.5);
}

- (void) AmmoniumSulphateFractionation
{
    // No longer needed
}

// Based on Kramer, R.M. et al., (2012) Biophysical Journal 102, 1907-1915
- (void) AS: (float) saturation
{
    [pd ResetInsoluble];
    [pd ResetSoluble];
    
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        [pd.Soluble addObject:[NSNumber numberWithFloat: 0.0]];
        [pd.Insoluble addObject:[NSNumber numberWithFloat: 0.0]];
        
        
        // Convert to Log Szero - factor is from experimental data (nice round figure!)
        float logSzero = [self getLogSzero:i];
        
        // All our proteins must be fully soluble at 10mg/mL in the absence of AS
        // So logSzero must never be less than log(10)
        if (logSzero < 1.0) logSzero = 1.0;
        
        // Approximate beta seems roughly right from experimental data
        float beta = logSzero / 2.5;
        
        // Get molarity of ammonium sulphate
        // Saturated ammonium sulphate is 3.9M
        float molarity = saturation*3.9/100.0;
        
        // Calculate the solubility of the protein in mg/mL
        float solubility = pow(10.0, logSzero - beta*molarity);
        
        // Assume our protein's concentration is 10mg/mL
        // If this is greater than the solubility, we will get a precipitate
        float precipitated = 10.0 - solubility;
        if (precipitated < 0.0) precipitated = 0.0;
        
        // Update the proteinData for this protein
        [pd SetInsolubleOfProtein:i value:precipitated/10.0*[pd GetCurrentAmountOfProtein:i]];
        [pd SetSolubleOfProtein:i value: [pd GetCurrentAmountOfProtein:i] - [pd GetInsolubleOfProtein:i]];
        
        // Update the proteinData for the whole mixture
        [pd SetInsolubleOfProtein:0 value:[pd GetInsolubleOfProtein:0] + [pd GetInsolubleOfProtein:i]];
    }
    
    [pd SetSolubleOfProtein:0 value:[pd GetCurrentAmountOfProtein:0] - [pd GetInsolubleOfProtein:0]];
}

/*

- (void) AmmoniumSulphateFractionation
{
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        if ([pd GetCurrentAmountOfProtein:i] != 0.0)
        {
            [pd SetK1OfProtein:i value:[pd GetSulphateOfProtein:i] - 35.0];
            [pd SetK2OfProtein:i value:20.0];
            [pd SetK3OfProtein:i value:10.0*[pd GetCurrentAmountOfProtein:i]/[pd GetK2OfProtein:i]];
        }
        else
        {
            [pd SetK1OfProtein:i value:1000.0];
            [pd SetK2OfProtein:i value:5.0];
            [pd SetK3OfProtein:i value:0.0];
        }
    }
}


- (void) AS: (float) saturation
{
    [pd ResetInsoluble];
    [pd ResetSoluble];
    
    int end = (int)round((2.5 * saturation));

    for (int i=1; i<=pd.noOfProteins; i++)
    {
        [pd.Soluble addObject:[NSNumber numberWithFloat: 0.0]];
        [pd.Insoluble addObject:[NSNumber numberWithFloat: 0.0]];
        
        for (int j=0; j<=end; j+=5)
            [pd SetInsolubleOfProtein:i value:[pd GetInsolubleOfProtein:i] + [self Gauss:i pos:j]];
        
        [pd SetInsolubleOfProtein:i value:[pd GetInsolubleOfProtein:i] * 0.201775626];
        
        if ([pd GetInsolubleOfProtein:i] < 0.0) [pd SetInsolubleOfProtein:i value:0.0];
        
        if ([pd GetInsolubleOfProtein:i] > [pd GetCurrentAmountOfProtein:i])
            [pd SetInsolubleOfProtein:i value:[pd GetCurrentAmountOfProtein:i]];
        
        [pd SetSolubleOfProtein:i value: [pd GetCurrentAmountOfProtein:i] - [pd GetInsolubleOfProtein:i]];
        
        [pd SetInsolubleOfProtein:0 value:[pd GetInsolubleOfProtein:0] + [pd GetInsolubleOfProtein:i]];
        

    }
    
    [pd SetSolubleOfProtein:0 value:[pd GetCurrentAmountOfProtein:0] - [pd GetInsolubleOfProtein:0]];
}
*/
 
- (void) GelFiltrationElution: (float) excluded included: (float) included hires: (bool) hires
{
    float startgel = log(excluded);
    float endgel = log(included);
    float grad =  startgel - endgel;
    
    for (int i=1; i<=pd.noOfProteins; i++) {
        
        if ([pd GetCurrentAmountOfProtein:i] > 0.0) {
            
            // check if protein is within resolving limits
            if (([pd GetMolWtOfProtein:i] > included) && ([pd GetMolWtOfProtein:i] < excluded))
            {
                // set position of peak
                float proteinpos = log([pd GetMolWtOfProtein:i]);
                
                
                [pd SetK1OfProtein:i value:50.0+(170.0*(startgel-proteinpos)/grad)];
                
                float Factor;
                if (hires)
                    Factor = [pd GetK1OfProtein:i]/150.0;
                else
                    Factor = [pd GetK1OfProtein:i]/100.0;
                
                // set width of peak
                [pd SetK2OfProtein:i value:Factor*sqrt([pd GetCurrentAmountOfProtein:i])];
            }
            
            else {
                // protein is excluded from the gel
                if ([pd GetMolWtOfProtein:i] >= excluded)
                {
                    [pd SetK1OfProtein:i value:50.0];
                    [pd SetK2OfProtein:i value:5.0];
                }
                // protein fully penetrates the gel
                if ([pd GetMolWtOfProtein:i] <= included)
                {
                    [pd SetK1OfProtein:i value: 220.0];
                    [pd SetK2OfProtein:i value:2.55*sqrt([pd GetCurrentAmountOfProtein:i])];
                }
                // sharpen up if hires
                if (hires)
                    [pd SetK2OfProtein:i value:[pd GetK2OfProtein:i]/1.5];
            }
            if ([pd GetK2OfProtein:i] < 5.0) [pd SetK2OfProtein:i value:5.0];  
            // set height of peak
            [pd SetK3OfProtein:i value: 10.0*[pd GetCurrentAmountOfProtein:i]/[pd GetK2OfProtein:i]];
        }
        else
            [pd SetK3OfProtein:i value:0.0];
    }
}

- (void) DEAESaltElution: (float) startgrad  endGrad: (float) endgrad pH: (float) pH titrable: (bool) titratable
{
    float grad = endgrad - startgrad;
    
    for (int i=1; i<=pd.noOfProteins; i++) {
        
        
        if ([pd GetCurrentAmountOfProtein:i] > 0.0 ) {
            
            if ((pH < [pd GetpH1OfProtein:i]) || (pH > [pd GetpH2OfProtein:i]))
                [pd SetCurrentActivityOfProtein:i value:0];
            
            float charge = [pd chargeAt:pH protein:i];
            
            if ((charge > 0.0) || (titratable && (pH >= 10.0))) {
                // if the protein is positively charged
                // or if the medium has lost its charge
                // the protein will not be bound
                [pd SetK1OfProtein:i value:40.0];
                [pd SetK2OfProtein:i value:5.0];
            }
            else {
                // molar is the salt concentration required to elute protein[i]
                float molar = -charge/44.0;
                if (molar <= startgrad) {
                    // immediately washed off by the start of the gradient
                    [pd SetK1OfProtein:i value:85.0];
                    [pd SetK2OfProtein:i value:2.0];
                }
                else {
                    // elution is a function of the salt concentration
                    if (startgrad >= endgrad) {
                        // the gradient is inverted, so by now everything that
                        // could be eluted has already been washed through
                        // so keep everything else bound to the column
                        [pd SetK1OfProtein:i value:1000.0];
                        [pd SetK2OfProtein:i value:5.0];
                    }
                    else {
                        // gradient is not inverted so calculate the elution volume
                        [pd SetK1OfProtein:i value:85.0 + (165.0*((molar - startgrad)/grad))];
                        [pd SetK2OfProtein:i value:sqrt([pd GetCurrentAmountOfProtein:i]/grad/2.0)];
                    }
                }
            }
            [pd SetK3OfProtein:i value:10.0 * [pd GetCurrentAmountOfProtein:i]/[pd GetK2OfProtein:i]];
        }
        else
            [pd SetK3OfProtein:i value:0.0];
        
    }
}

- (void) DEAEpHElution: (float) startgrad  endGrad: (float) endgrad pH: (float) pH titrable: (bool) titratable
{
    
    float factor = 10.0;
    float grad = startgrad - endgrad; // decreasing pH for DEAE
    
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        
        if ([pd GetCurrentAmountOfProtein:i] > 0.0)
        {
            
            if ((pH < [pd GetpH1OfProtein:i]) || (pH > [pd GetpH2OfProtein:i]) ||
                (startgrad < [pd GetpH1OfProtein:i]) || (startgrad > [pd GetpH2OfProtein:i]))
                [pd SetCurrentActivityOfProtein:i value:0];
            
            float isopoint = [pd GetIsoPointOfProtein:i];
            
            if ((pH < isopoint) || (titratable && (pH >= 10.0)))
            {
                // protein is positively charged or column is uncharged
                // so protein runs straight through
                [pd SetK1OfProtein:i value:40.0];
                [pd SetK2OfProtein:i value:5.0];
            }
            else {
                if (isopoint >= startgrad) {
                    // immediately washed off by the start of the gradient
                    [pd SetK1OfProtein:i value:85.0];
                    [pd SetK2OfProtein:i value:2.0];
                }
                else {
                    // elution is function of charge
                    if (endgrad >= startgrad) {
                        // if gradient is inverted then by this stage everything
                        // that is going to elute will have done so in one step
                        // so keep everything else on the column
                        [pd SetK1OfProtein:i value:1000.0];
                        [pd SetK2OfProtein:i value:5.0];
                    }
                    else {
                        // gradient not inverted so calculate elution volume
                        [pd SetK1OfProtein:i value:85.0+(165.0*(startgrad-isopoint)/grad)];
                        [pd SetK2OfProtein:i value:factor*sqrt([pd GetCurrentAmountOfProtein:i]/grad/2.0)];
                    }
                }
            }
            [pd SetK3OfProtein:i value:10.0 * [pd GetCurrentAmountOfProtein:i]/[pd GetK2OfProtein:i]];
        }
        else
            [pd SetK3OfProtein:i value:0.0];
    }
}

- (void) CMSaltElution: (float) startgrad  endGrad: (float) endgrad pH: (float) pH titrable: (bool) titratable
{
    
    float grad = endgrad - startgrad;
    
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        
        if ([pd GetCurrentAmountOfProtein:i] > 0.0)
        {
            
            if ((pH < [pd GetpH1OfProtein:i]) || (pH > [pd GetpH2OfProtein:i]))
                [pd SetCurrentActivityOfProtein:i value:0];
            
            float charge = [pd chargeAt:pH protein:i];
            
            if ((charge < 0.0) || (titratable && (pH <= 3.0)))
            {
                // if the protein is negatively charged
                // or if the medium has lost its charge
                // the protein will not be bound
                [pd SetK1OfProtein:i value:40.0];
                [pd SetK2OfProtein:i value:5.0];
            }
            else {
                // molar is the salt concentration required to elute protein[i]
                float molar = charge/66.0;
                if (molar <= startgrad) {
                    // immediately washed off by the start of the gradient
                    [pd SetK1OfProtein:i value:85.0];
                    [pd SetK2OfProtein:i value:2.0];
                }
                else {
                    // elution is a function of the salt concentration
                    if (startgrad >= endgrad) {
                        // the gradient is inverted, so by now everything that
                        // could be eluted has already been washed through
                        // so keep everything else bound to the column
                        [pd SetK1OfProtein:i value:1000.0];
                        [pd SetK2OfProtein:i value:5.0];
                    }
                    else {
                        // gradient is not inverted so calculate the elution volume
                        [pd SetK1OfProtein:i value:85.0+(165.0*(molar-startgrad)/grad)];
                        [pd SetK2OfProtein:i value:sqrt([pd GetCurrentAmountOfProtein:i]/grad/2.0)];
                    }
                }
            }
            [pd SetK3OfProtein:i value:10.0 * [pd GetCurrentAmountOfProtein:i]/[pd GetK2OfProtein:i]];
        }
        else
            [pd SetK3OfProtein:i value:0.0];
    }
}

- (void) CMpHElution: (float) startgrad  endGrad: (float) endgrad pH: (float) pH titrable: (bool) titratable
{
    
    float factor = 10.0;
    float grad = endgrad - startgrad; // increasing pH for CM
    
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        
        if ([pd GetCurrentAmountOfProtein:i] > 0.0)
        {
            
            if ((pH < [pd GetpH1OfProtein:i]) || (pH > [pd GetpH2OfProtein:i]) ||
                (startgrad < [pd GetpH1OfProtein:i]) || (startgrad > [pd GetpH2OfProtein:i]))
                [pd SetCurrentActivityOfProtein:i value:0];
            
            float isopoint = [pd GetIsoPointOfProtein:i];
                        
            if ((pH >= isopoint) || (titratable && (pH <= 3.0)))
            {
                // protein is negatively charged or column is uncharged
                // so protein runs straight through
                [pd SetK1OfProtein:i value:40.0];
                [pd SetK2OfProtein:i value:5.0];
            }
            else {
                if (isopoint <= startgrad) {
                    // immediately washed off by the start of the gradient
                    [pd SetK1OfProtein:i value:85.0];
                    [pd SetK2OfProtein:i value:2.0];
                }
                else {
                    // elution is function of charge
                    if (endgrad <= startgrad) {
                        // if gradient is inverted then by this stage everything
                        // that is going to elute will have done so in one step
                        // so keep everything else on the column
                        [pd SetK1OfProtein:i value:1000.0];
                        [pd SetK2OfProtein:i value:5.0];
                    }
                    else {
                        // gradient not inverted so calculate elution volume
                        [pd SetK1OfProtein:i value:85.0+(165.0*(isopoint-startgrad)/grad)];
                        [pd SetK2OfProtein:i value:factor*sqrt([pd GetCurrentAmountOfProtein:i]/grad/2.0)];
                    }
                }
            }
            [pd SetK3OfProtein:i value:10.0 * [pd GetCurrentAmountOfProtein:i]/[pd GetK2OfProtein:i]];
        }
        else
            [pd SetK3OfProtein:i value:0.0];
    }
}

// Works by working out the maximum salt concentration at which a protein is soluble.
// Assumes that the protein will be released from the matrix if the salt concentration is
// less than or equal to this.  (Don't ask how an insoluble protein evaded centrifugation and
// could be loaded onto the column in soluble form. That's why there is a fiddle in doPrecipitate().
// At least we have some measure of 'hydrophilicity' that we can use in the absence of any
// information on the hydrophobicity of the protein.
// We now no longer need the Sulphate entries in the data file.
- (void) HICElution: (float) startgrad endGrad: (float) endgrad  medium: (int) medium salt_concn: (float) salt_concn
{
    
    // emerge earlier from phenyl-Sepharose
    float factor;
    if (medium == Phenyl_Sepharose) factor = 100.0;
    else factor = 125.0;
    
    float grad = startgrad - endgrad;
    
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        
        if ([pd GetCurrentAmountOfProtein:i] > 0.0)
        {
            //float salt = [pd GetSulphateOfProtein:i]/200.0;
            float salt = [self getSalt:i];
            //if (salt < 0.0) salt = 0.0;
            // If salt < 0.0, the protein will bind to the column, even in the absence of salt and can't be washed off.
            // This is reasonable. Live with it. Uncommenting the line will cause problems with the elution display.
            if (salt > startgrad) {
                // salt concn. is not high enough
                // for this protein to stick to column
                [pd SetK1OfProtein:i value:40.0];
                [pd SetK2OfProtein:i value:5.0];
            }
            else if (grad==0.0) {
                // obscure case when a flat gradient is used
                // whose concentration is sufficient to bind the protein to the column
                // avoids a division by zero
                [pd SetK1OfProtein:i value:40.0];
                [pd SetK2OfProtein:i value:5.0];
            }
            else {
                [pd SetK1OfProtein:i value:85.0+(factor*(startgrad-salt)/grad)];
                [pd SetK2OfProtein:i value:2.0*sqrt([pd GetCurrentAmountOfProtein:i])/grad];
            }
            [pd SetK3OfProtein:i value:10.0 * [pd GetCurrentAmountOfProtein:i]/[pd GetK2OfProtein:i]];
        }
        else
            [pd SetK3OfProtein:i value:0.0];
    }
}

// affinity medium and affinity elution should be constants defined in pp_Commands.h
- (void) Affinity_elution:(int) affinity_medium affinity_elution: (int) affinity_elution
{
    
    // get ligand affinities - scrambled for each enzyme.
    int affinity_ligand=0;
    int low_affinity=1;
    int medium_affinity = 2;
    int high_affinity = 3;
    
    int polyclonal = 4;
    int inhibitor = 5;
    int nickel = 6;
    
    int i = pd.enzyme % 6;
    
    switch (affinity_medium) {
        case AntibodyA:
            switch (i)
        {
            case 1: affinity_ligand = medium_affinity;break;
            case 2: affinity_ligand = low_affinity;break;
            case 3: affinity_ligand = low_affinity;break;
            case 4: affinity_ligand = high_affinity;break;
            case 5: affinity_ligand = medium_affinity;break;
        }
            break;
        case AntibodyB:
            switch (i)
        {
            case 1: affinity_ligand = low_affinity;break;
            case 2: affinity_ligand = medium_affinity;break;
            case 3: affinity_ligand = high_affinity;break;
            case 4: affinity_ligand = low_affinity;break;
            case 5: affinity_ligand = high_affinity;break;
        }
            break;
        case AntibodyC:
            switch (i)
        {
            case 1: affinity_ligand = high_affinity;break;
            case 2: affinity_ligand = high_affinity;break;
            case 3: affinity_ligand = medium_affinity;break;
            case 4: affinity_ligand = medium_affinity;break;
            case 5: affinity_ligand = low_affinity;break;
        }
            break;
        case Polyclonal:
            affinity_ligand = polyclonal;break;
            
        case Immobilized_inhibitor:
            affinity_ligand = inhibitor;break;
            
        case NiNTAagarose:
            affinity_ligand = nickel;
    }
    
    for ( i=1; i<=pd.noOfProteins; i++)
    {
        if ([pd GetCurrentAmountOfProtein:i] > 0.0)
        {
            if (i==pd.enzyme)
            {
                
                // ideal situations
                if (((affinity_ligand==medium_affinity) && (affinity_elution == Tris)) ||
                    ((affinity_ligand==medium_affinity) && (affinity_elution == Acid)) ||
                    ((affinity_ligand==polyclonal) && (affinity_elution == Tris)) ||
                    ((affinity_ligand==polyclonal) && (affinity_elution == Acid)) ||
                    ((affinity_ligand==inhibitor) && (affinity_elution == Inhibitor))
                    ||
                    ((affinity_ligand==nickel) && (affinity_elution==Imidazole) && [pd GetHisTagOfProtein:i])
                    )
                {
                    
                    [pd SetK1OfProtein:i value:100.0];
                    
                    float gdFactor = [pd GetK1OfProtein:i]/100.0;
                    
                    // losses due to failure to elute
                    if (affinity_ligand == medium_affinity) [pd SetCurrentAmountOfProtein:i value: [pd GetCurrentAmountOfProtein:i]*0.75];
                    if (affinity_ligand == polyclonal) [pd SetCurrentAmountOfProtein:i value: [pd GetCurrentAmountOfProtein:i]*0.3];
                    if (affinity_ligand == inhibitor) [pd SetCurrentAmountOfProtein:i value: [pd GetCurrentAmountOfProtein:i]*0.8];
                    
                    // losses due to denaturation
                    if (affinity_elution == Acid) [pd SetCurrentAmountOfProtein:i value: [pd GetCurrentAmountOfProtein:i]*0.5];
                    
                    [pd SetK2OfProtein:i value: gdFactor * sqrt([pd GetCurrentAmountOfProtein:i])];
                    if ([pd GetK2OfProtein:i]< 5.0)  [pd SetK2OfProtein:i value:5.0];
                    
                    //Window.alert("Current Amount is "+pd.getCurrentAmount(i)+"Current Activity is "+pd.getCurrentActivity(i));
                }
                
                else if (affinity_ligand == high_affinity) {
                    // infinity chromatography
                    [pd SetK1OfProtein:i value:5000.0];
                    [pd SetK2OfProtein:i value:5.0];
                }
                else {
                    // default to running straight through
                    [pd SetK1OfProtein:i value:50.0];
                    [pd SetK2OfProtein:i value:5.0];
                    if (affinity_elution == Acid) [pd SetCurrentAmountOfProtein:i value: [pd GetCurrentAmountOfProtein:i]*0.5];
                }
            }
            else {
                [pd SetK1OfProtein:i value:50.0];
                [pd SetK2OfProtein:i value:5.0];
            }
            [pd SetK3OfProtein:i value:10.0 * [pd GetCurrentAmountOfProtein:i]/[pd GetK2OfProtein:i]];
        }
        else
            [pd SetK3OfProtein:i value:0.0];
    }
}


- (void) PoolFractionsFrom: (int) start To: (int) end
{
    float thisarea;
    float totalarea;
    
    double current_amount;
    double total_amount = 0.0;
    
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        
        totalarea = sqrt(M_PI*2.0)*[pd GetK2OfProtein:i]*[pd GetK3OfProtein:i];
        thisarea = 0.0;
        if (totalarea==0.0)
            [pd SetCurrentAmountOfProtein:i value:0.0];
        else
        {
            
            if (start==125) thisarea = (float)([self GetPlotElement:249 protein:i]+[self GetPlotElement:250 protein:i]);
            else {
                if (start==end)
                    thisarea = (double)([self GetPlotElement:2*start-1 protein:i]+[self GetPlotElement:2*start protein:i]);
                else {
                    for (int k=start; k<=end; k++)
                        thisarea += (double)([self GetPlotElement:2*k-1 protein:i]+[self GetPlotElement:2*k protein:i]);
                }
            }
            
            current_amount = [pd GetCurrentAmountOfProtein:i];
            current_amount *= thisarea/totalarea;
            [pd SetCurrentAmountOfProtein:i value:current_amount];
            
            total_amount += current_amount;
        }
    }

    [pd SetCurrentAmountOfProtein:0 value:total_amount];
    [pd IncrementStep];
}

- (NSString*) CheckPrecipitatedWith: (float) salt_conc
{
    
    NSString* MessageString;
    
    [pd ResetInsoluble];
    
    for (int i=1; i<=pd.noOfProteins; i++)
    {
        
        [pd.Insoluble addObject:[NSNumber numberWithFloat:0.0]];
        
        float current_amount = [pd GetCurrentAmountOfProtein:i];
        
        // Get the log of the solubility
        float logSzero = [self getLogSzero:i];
        
        // All our proteins must be fully soluble at 10mg/mL in the absence of AS
        // So logSzero must never be less than log(10)
        if (logSzero < 1.0) logSzero = 1.0;
        
        // Fiddle the beta to precipitate less than would be predicted.
        // Doesn't affect the chromatography.
        float beta = logSzero / 4.0;
        
        // Get molarity of salt
        float molarity = salt_conc;
        
        // Calculate the solubility of the protein in mg/mL
        float solubility = pow(10.0, logSzero - beta*molarity);
        
        // Assume our protein's concentration is 10mg/mL
        // If this is greater than the solubility, we will get a precipitate
        float precipitated = 10.0 - solubility;
        if (precipitated < 0.0) precipitated = 0.0;
        
        
        
        [pd SetInsolubleOfProtein:i value:precipitated/10.0*[pd GetCurrentAmountOfProtein:i]];
        
        if ([pd GetInsolubleOfProtein:i] > current_amount)
            [pd SetInsolubleOfProtein: i value:current_amount];
        if ([pd GetInsolubleOfProtein:i] < 0.001) [pd SetInsolubleOfProtein: i value:0.0];
        
        [pd SetInsolubleOfProtein:0 value: [pd GetInsolubleOfProtein:0]+[pd GetInsolubleOfProtein:i]];
    }
    if ( ([pd GetInsolubleOfProtein:0]/[pd GetCurrentAmountOfProtein:0]) >= 0.001)
    {
        if ([pd GetInsolubleOfProtein:pd.enzyme] == 0.0)
        {
            float prot_prec = [pd GetInsolubleOfProtein:0]/[pd GetCurrentAmountOfProtein:0]*100.0;
            MessageString = [NSString stringWithFormat:NSLocalizedString(@"Precipitation Warning 1",@""),prot_prec];
        }
        else
        {
            float enz_prec = [pd GetInsolubleOfProtein:pd.enzyme]/[pd GetCurrentAmountOfProtein:pd.enzyme]*100.0;
            float prot_prec = [pd GetInsolubleOfProtein:0]/[pd GetCurrentAmountOfProtein:0]*100.0;
            MessageString = [NSString stringWithFormat:NSLocalizedString(@"Precipitation Warning 2",@""),enz_prec,prot_prec];
        }
        
        return MessageString;
    }
    
    else
        // nothing precipitated out - just draw the profile
        return @"";
    
}

// Called from HICMenuViewController
- (void) doPrecipitate
{
    for (int i=0; i<=pd.noOfProteins; i++) {
        float current_amount = [pd GetCurrentAmountOfProtein:i];
        current_amount -= [pd GetInsolubleOfProtein:i];
        [pd SetCurrentAmountOfProtein:i value:current_amount];
    }
}

@end
