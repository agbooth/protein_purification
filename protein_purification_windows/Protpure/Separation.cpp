#include "StdAfx.h"
#include "Separation.h"
#include "ProteinData.h"
#include "Resource.h"
#include "Logs.h"

extern ProteinData *proteinData;
extern HINSTANCE hInst;

Separation::Separation(void)
{
}


Separation::~Separation(void)
{
}

double Separation::Gauss(int i, int x)
{
	double exponent = ((double)x - proteinData->getK1(i))/proteinData->getK2(i);
	exponent *= exponent/2.0;
	if (exponent > 50.0) return 0.0;
	else return proteinData->getK3(i) * exp(-exponent);
}

void Separation::SetPlotArray()
{

	fractions.clear();
	// there is no fraction zero, so put a dummy vector into the fractions vector
	std::vector<double> dummy;
	fractions.push_back(dummy);

	for (int fraction=1; fraction<251; fraction++)
	{
		// Work out the fractional composition of each protein
		// done by calculating the Gaussian curve for each.
		// Protein zero is the sum of all proteins.

		std::vector<double> absorbance;
		absorbance.push_back(0.0);

		// For each fraction, work out how much of each protein it contains
		for (int i=1; i<=proteinData->noOfProteins; i++)
		{
			// avoid a division by zero
			if (proteinData->getK2(i)< 0.00001)
				proteinData->setK2(i, 0.00001);

			double value = Gauss(i, fraction);

			absorbance.push_back(value);

			// Total amount in this fraction is held by 'protein 0'.
			double total = absorbance[0];
			total += value;
			absorbance[0] = total;

		}
		fractions.push_back(absorbance);
	}
}

double Separation::GetPlotElement(int fraction, int protein)
{
	std::vector<double> proteins = fractions.at(fraction);
	return proteins.at(protein);
}

// Calculates the log of the solubility in the absence of salt
double Separation::getLogSzero( int proteinNo )
{
	const double PI = 4.0*atan(1.0);

	// Get the number of negatively charged residues - all assumed to be exposed and fully charged at pH 7
	// including C Termini but excluding CYS and TYR
	int* charges = proteinData->Proteins.at(proteinNo).charges;
	int negCharges =    charges[0] + charges[1] 
	+ proteinData->getNoOfSub1(proteinNo) 
		+ proteinData->getNoOfSub2(proteinNo) 
		+ proteinData->getNoOfSub3(proteinNo);

	// Get the overall molecular weight
	double MolWt = proteinData->getMolWt(proteinNo);

	// Assume the protein is spherical and calculate 'molecular radius'
	double MolRad = pow(MolWt*0.75/PI,1.0/3.0);

	// Calculate the 'molecular surface area'
	double MolArea = 4.0*PI*MolRad*MolRad;

	// Calculate negative charge per unit area
	double chargePerArea = (double)negCharges/MolArea;

	// Convert to Log Szero - factor is from experimental data (nice round figure!)
	return chargePerArea * 600.0;
}

//Calculates the salt concentration required to give a solubility of 10mg/mL
double Separation::getSalt( int proteinNo)
{
	return (getLogSzero(proteinNo)-1.0)/(getLogSzero(proteinNo)/2.5);
}

// Based on Kramer, R.M. et al., (2012) Biophysical Journal 102, 1907-1915
void Separation::AS(double saturation)
{
	proteinData->resetInsoluble();
	proteinData->resetSoluble();

	for (int i=1; i<=proteinData->noOfProteins; i++)
	{
		proteinData->Soluble.push_back(0.0);
		proteinData->Insoluble.push_back(0.0);

		//Get the log of the solubility
		double logSzero = getLogSzero(i);

		// All our proteins must be fully soluble at 10mg/mL in the absence of AS
		// So logSzero must never be less than log(10)
		if (logSzero < 1.0) logSzero = 1.0;

		// Approximate beta seems roughly right from experimental data
		double beta = logSzero / 2.5;

		// Get molarity of ammonium sulphate
		// Saturated ammonium sulphate is 3.9M
		double molarity = saturation*3.9/100.0;

		// Calculate the solubility of the protein in mg/mL
		double solubility = pow(10.0, logSzero - beta*molarity);

		// Assume our protein's concentration is 10mg/mL
		// If this is greater than the solubility, we will get a precipitate
		double precipitated = 10.0 - solubility;
		if (precipitated < 0.0) precipitated = 0.0;

		// Update the proteinData for this protein
		proteinData->setInsoluble(i, precipitated/10.0*proteinData->getCurrentAmount(i));
		proteinData->setSoluble(i, proteinData->getCurrentAmount(i) - proteinData->getInsoluble(i));

		// Update the proteinData for the whole mixture
		proteinData->setInsoluble(0, proteinData->getInsoluble(0) + proteinData->getInsoluble(i));
	}
	proteinData->setSoluble(0, proteinData->getCurrentAmount(0) - proteinData->getInsoluble(0));
}

void Separation::HeatTreatment(double temperature, double duration)
{
	proteinData->resetSoluble();

	for (int i=1; i<=proteinData->noOfProteins; i++)
	{
		proteinData->appendSoluble(proteinData->getCurrentAmount(i));

		double exponent = ( temperature - proteinData->getTemp(i))/200.0 * duration;

		if (exponent > 0.0)
		{
			if (exponent < 50.0)
				proteinData->setSoluble(i, proteinData->getSoluble(i) * exp(-exponent));
			else
				proteinData->setSoluble(i, 0.0);
		}
		proteinData->setSoluble(0, proteinData->getSoluble(0) + proteinData->getSoluble(i));
	}

	for (int i=0; i<=proteinData->noOfProteins; i++)
	{
		if (proteinData->getSoluble(i) < 0.0) proteinData->setSoluble(i, 0.0);
		proteinData->setCurrentAmount(i, proteinData->getSoluble(i));
	}
}

void Separation::GelFiltrationElution(double excluded, double included, BOOL hires)
{
	
	double startgel = log(excluded);
	double endgel = log(included);
	double grad = startgel-endgel;

	for (int i=1; i<=proteinData->noOfProteins; i++)
	{
		if (proteinData->getCurrentAmount(i) > 0.0)
		{
			// Check if protein is within resolving limits
			if ((proteinData->getMolWt(i) > included) && (proteinData->getMolWt(i) < excluded))
			{
				// Set position of peak
				double proteinpos = log(proteinData->getMolWt(i));
				proteinData->setK1(i, 50.0+(170.0*(startgel-proteinpos)/grad));

				double Factor;
				if (hires)
					Factor = proteinData->getK1(i)/150.0;
				else
					Factor = proteinData->getK1(i)/100.0;

				// set width of peak
				proteinData->setK2(i, Factor*sqrt(proteinData->getCurrentAmount(i)));
			}
			else 
			{
				// protein is excluded from the gel
				if (proteinData->getMolWt(i) >= excluded)
				{
					proteinData->setK1(i, 50.0);
					proteinData->setK2(i, 5.0);
				}
				// protein fully penetrates the gel
				if (proteinData->getMolWt(i) <= included)
				{
					proteinData->setK1(i, 220.0);
					proteinData->setK2(i, 2.55*sqrt(proteinData->getCurrentAmount(i)));
				}
				// sharpen up if hires
				if (hires)
					proteinData->setK2(i, proteinData->getK2(i)/1.5);
			}
			// minimum width for any peak
			if (proteinData->getK2(i) < 5.0) proteinData->setK2(i, 5.0); 

			// set height of peak
			proteinData->setK3(i, 10.0*proteinData->getCurrentAmount(i)/proteinData->getK2(i));
		}
		else
			// the protein is not present
			proteinData->setK3(i, 0.0);
	}
}

void Separation::DEAE_salt_elution(double startgrad, double endgrad, double pH, BOOL titratable) 
{
	double grad = endgrad - startgrad;
   
    for (int i=1; i<=proteinData->noOfProteins; i++) 
	{
		if (proteinData->getCurrentAmount(i) > 0.0 ) 
		{           
			if ((pH < proteinData->getpH1(i)) || (pH > proteinData->getpH2(i)))
				proteinData->setCurrentActivity(i, 0);

            double charge = proteinData->Charge( pH, i);
            
            if ((charge > 0.0) || (titratable && (pH >= 10.0))) 
			{
				// if the protein is positively charged
                // or if the medium has lost its charge
                // the protein will not be bound
                proteinData->setK1( i, 40.0 );
                proteinData->setK2( i, 5.0);

				Log(L"Protein %d is not bound\n",i);
            }
            else 
			{
				// molar is the salt concentration required to elute protein[i]
                double molar = -charge/44.0;
                if (molar <= startgrad) 
				{
					// immediately washed off by the start of the gradient
                    proteinData->setK1( i, 85.0 );
                    proteinData->setK2( i, 2.0);
                }
                else 
				{
                   // elution is a function of the salt concentration
                   if (startgrad >= endgrad) 
				   {
						// the gradient is inverted, so by now everything that
						// could be eluted has already been washed through
						// so keep everything else bound to the column
						proteinData->setK1( i, 1000.0 );
                        proteinData->setK2( i, 5.0);
                   }
                   else 
				   {
                       // gradient is not inverted so calculate the elution volume
                       proteinData->setK1( i, 85.0 + (165.0*((molar - startgrad)/grad)));
                       proteinData->setK2( i, sqrt(proteinData->getCurrentAmount(i)/grad/2.0));
                   }
				}
			}
            proteinData->setK3( i, 10.0 * proteinData->getCurrentAmount(i)/proteinData->getK2(i));
		}
        else
			proteinData->setK3( i, 0.0 );

    }
}

void Separation::DEAE_pH_elution(double startgrad, double endgrad, double pH, BOOL titratable) 
{

	double factor = 10.0;
    double grad = startgrad - endgrad; // decreasing pH for DEAE

    for (int i=1; i<=proteinData->noOfProteins; i++) 
	{
		if (proteinData->getCurrentAmount(i) != 0.0) 
		{        
			if ((pH < proteinData->getpH1(i)) || (pH > proteinData->getpH2(i)) ||
                (startgrad < proteinData->getpH1(i)) || (startgrad > proteinData->getpH2(i)))
				proteinData->setCurrentActivity( i, 0 );

            double isopoint = proteinData->getIsoPoint(i);

            if ((pH < isopoint) || (titratable && (pH >= 10.0))) 
			{
				// protein is positively charged or column is uncharged
                // so protein runs straight through
                proteinData->setK1( i, 40.0 );
                proteinData->setK2( i, 5.0 );
            }
            else 
			{
                if (isopoint >= startgrad) 
				{
					// immediately washed off by the start of the gradient
                    proteinData->setK1( i, 85.0 );
                    proteinData->setK2( i, 2.0 );
                }
                else 
				{
                    // elution is function of charge
                    if (endgrad >= startgrad) 
					{
						// if gradient is inverted then by this stage everything
                        // that is going to elute will have done so in one step
                        // so keep everything else on the column
                        proteinData->setK1( i, 1000.0 );
                        proteinData->setK2( i, 5.0 );
                    }
                    else 
					{
                       // gradient not inverted so calculate elution volume
                       proteinData->setK1( i, 85.0+(165.0*(startgrad-isopoint)/grad));
                       proteinData->setK2( i, factor*sqrt(proteinData->getCurrentAmount(i)/grad/2.0));
                    }
				}
			}
            proteinData->setK3( i, 10.0*proteinData->getCurrentAmount(i)/proteinData->getK2(i));
		}
        else
			proteinData->setK3(i, 0.0);
	}
}

void Separation::CM_salt_elution(double startgrad, double endgrad, double pH, BOOL titratable) {

	double grad = endgrad - startgrad;

	for (int i=1; i<=proteinData->noOfProteins; i++) 
	{


		if (proteinData->getCurrentAmount(i) > 0.0) 
		{

			if ((pH < proteinData->getpH1(i)) || (pH > proteinData->getpH2(i)))
				proteinData->setCurrentActivity(i, 0);

			double charge = proteinData->Charge( pH, i);

			if ((charge < 0.0) || (titratable && (pH <= 3.0))) 
			{
				// if the protein is negatively charged
				// or if the medium has lost its charge
				// the protein will not be bound
				proteinData->setK1( i, 40.0 );
				proteinData->setK2( i, 5.0);
			}
			else 
			{
				// molar is the salt concentration required to elute protein[i]
				double molar = charge/66.0;
				if (molar <= startgrad) 
				{
					// immediately washed off by the start of the gradient
					proteinData->setK1( i, 85.0 );
					proteinData->setK2( i, 2.0);
				}
				else 
				{
					// elution is a function of the salt concentration
					if (startgrad >= endgrad) 
					{
						// the gradient is inverted, so by now everything that
						// could be eluted has already been washed through
						// so keep everything else bound to the column
						proteinData->setK1( i, 1000.0 );
						proteinData->setK2( i, 5.0);
					}
					else 
					{
						// gradient is not inverted so calculate the elution volume
						proteinData->setK1( i, 85.0 + (165.0*((molar - startgrad)/grad)));
						proteinData->setK2( i, sqrt(proteinData->getCurrentAmount(i)/grad/2.0));
					}
				}
			}
			proteinData->setK3( i, 10.0 * proteinData->getCurrentAmount(i)/proteinData->getK2(i));
		}
		else
			proteinData->setK3( i, 0.0 );
	}
}

void Separation::CM_pH_elution(double startgrad, double endgrad, double pH, BOOL titratable) 
{

	double factor = 10.0;
	double grad = endgrad - startgrad; // increasing pH for CM

	for (int i=1; i<=proteinData->noOfProteins; i++) 
	{

		if (proteinData->getCurrentAmount(i) != 0.0) 
		{

			if ((pH < proteinData->getpH1(i)) ||
				(pH > proteinData->getpH2(i)) || 
				(startgrad < proteinData->getpH1(i)) ||
				(startgrad > proteinData->getpH2(i)))
				proteinData->setCurrentActivity( i, 0 );

			double isopoint = proteinData->getIsoPoint(i);


			if ((pH >= isopoint) || (titratable && (pH <= 3.0))) 
			{
				// protein is negatively charged or column is uncharged
				// so protein runs straight through
				proteinData->setK1( i, 40.0 );
				proteinData->setK2( i, 5.0 );
			}
			else 
			{
				if (isopoint <= startgrad) 
				{
					// immediately washed off by the start of the gradient
					proteinData->setK1( i, 85.0 );
					proteinData->setK2( i, 2.0 );
				}
				else 
				{
					// elution is function of charge
					if (endgrad <= startgrad) 
					{
						// if gradient is inverted then by this stage everything
						// that is going to elute will have done so in one step
						// so keep everything else on the column
						proteinData->setK1( i, 1000.0 );
						proteinData->setK2( i, 5.0 );
					}
					else 
					{
						// gradient not inverted so calculate elution volume
						proteinData->setK1( i, 85.0+(165.0*(isopoint-startgrad)/grad));
						proteinData->setK2( i, factor*sqrt(proteinData->getCurrentAmount(i)/grad/2.0));
					}
				}
			}
			proteinData->setK3( i, 10.0*proteinData->getCurrentAmount(i)/proteinData->getK2(i));
		}
		else
			proteinData->setK3(i, 0.0);
	}
}

// Works by working out the maximum salt concentration at which a protein is soluble.
// Assumes that the protein will be released from the matrix if the salt concentration is 
// less than or equal to this.  (Don't ask how an insoluble protein evaded centrifugation and 
// could be loaded onto the column in soluble form. That's why there is a fiddle in doPrecipitate().
// At least we have some measure of 'hydrophilicity' that we can use in the absence of any
// information on the hydrophobicity of the protein.
// We now no longer need the Sulphate entries in the data file.
void Separation::HIC_elution(double startgrad, double endgrad, int medium, double salt_concn) 
{
	// emerge earlier from phenyl-Sepharose
    double factor;
    if (medium == Phenyl_Sepharose) factor = 100.0;
    else factor = 125.0;
        
    double grad = startgrad - endgrad;
        
	for (int i=1; i<=proteinData->noOfProteins; i++) 
	{
    
		if (proteinData->getCurrentAmount(i) != 0.0) 
		{
			double salt = getSalt(i);

			// If salt < 0.0, the protein will bind to the column, even in the absence of salt and can't be washed off.
            // This is reasonable. Infinity chromatography happens.
            	
			if (salt > startgrad) 
			{
				// salt concn. is not high enough
				// for this protein to stick to column
				proteinData->setK1(i, 40.0);
                proteinData->setK2(i, 5.0);
            }
			else if (grad==0.0)
			{
				// obscure special case, 
				// with a flat gradient whose concentration
				// is suffiently high to prevent elution of the protein
				// - avoids a division by zero	
				proteinData->setK1( i, 1000.0 );
				proteinData->setK2( i, 5.0 );
			}
            else 
			{
                proteinData->setK1(i, 85.0+(factor*(startgrad-salt)/grad));
                proteinData->setK2(i, 2.0*sqrt(proteinData->getCurrentAmount(i))/grad);
            }
            proteinData->setK3(i,10.0*proteinData->getCurrentAmount(i)/proteinData->getK2(i));
        }
        else proteinData->setK3(i, 0.0);

		//Log(L"Protein %d, K1 is %f\n",i, proteinData->getK1(i));
		//Log(L"Protein %d, K2 is %f\n",i, proteinData->getK2(i));
		//Log(L"Protein %d, K3 is %f\n",i, proteinData->getK3(i));

    }
}


void Separation::PoolFractions(int start, int end) 
{
	const double PI = 4.0*atan(1.0);

	double thisarea;
	double totalarea;
    double current_amount;
	double total_amount = 0.0;

    for (int i=1; i<=proteinData->noOfProteins; i++) 
	{
		totalarea = (sqrt(PI*2.0)*proteinData->getK2(i)*proteinData->getK3(i));
        thisarea = 0.0;
        if (totalarea==0.0)
			proteinData->setCurrentAmount(i,0.0);
        else 
		{
			//totalarea[0] += totalarea[i];
            if (start==125) thisarea = GetPlotElement(249,i)+GetPlotElement(250,i);
            else 
			{
				if (start==end)
					thisarea = GetPlotElement(2*start-1,i)+GetPlotElement(2*start,i);
                else 
				{
					for (int k =start; k<end+1; k++)
						thisarea += GetPlotElement(2*k-1,i)+GetPlotElement(2*k,i);
                }
			}
           // thisarea[0] += thisarea[i];
            current_amount = proteinData->getCurrentAmount(i);
            current_amount *= thisarea/totalarea;
            proteinData->setCurrentAmount(i, current_amount);

			total_amount += current_amount;
		}
	}       
    
    proteinData->setCurrentAmount(0, total_amount);
    proteinData->incrementStep();
}

BOOL Separation::checkPrecipitate(double salt_conc) 
{
       
	proteinData->resetInsoluble();
	    
    for (int i=1; i<=proteinData->noOfProteins; i++) 
	{
            
		proteinData->Insoluble.push_back(0.0);
	        
		double current_amount = proteinData->getCurrentAmount(i);
            
        // Get the log of the solubility
	    double logSzero = getLogSzero(i);
	        
		// All our proteins must be fully soluble at 10mg/mL in the absence of AS
	    // So logSzero must never be less than log(10)
	    if (logSzero < 1.0) logSzero = 1.0;
	        
	    // Fiddle the beta to precipitate less than would be predicted.
	    // Doesn't affect the chromatography.
	    double beta = logSzero / 4.0;
	 	        
	    // Get molarity of salt
	    double molarity = salt_conc;
	        
	    // Calculate the solubility of the protein in mg/mL
	    double solubility = pow(10.0, logSzero - beta*molarity);
	        
	    // Assume our protein's concentration is 10mg/mL
	    // If this is greater than the solubility, we will get a precipitate
	    double precipitated = 10.0 - solubility;
	    if (precipitated < 0.0) precipitated = 0.0;
            
	    proteinData->setInsoluble(i, precipitated/10.0*proteinData->getCurrentAmount(i));
            
        if (proteinData->getInsoluble(i) > current_amount)
			proteinData->setInsoluble(i, current_amount);
            
		if (proteinData->getInsoluble(i) < 0.0) 
			proteinData->setInsoluble(i, 0.0);
                
        proteinData->setInsoluble(0, proteinData->getInsoluble(0)+proteinData->getInsoluble(i));
	}
        
	if ( (proteinData->getInsoluble(0)/proteinData->getCurrentAmount(0)) >= 0.001) 
	{
        
		if (proteinData->getInsoluble(proteinData->getEnzyme()) == 0.0) 
		{
			double prot_prec = proteinData->getInsoluble(0)/proteinData->getCurrentAmount(0)*100.0;
			LoadString( hInst, IDS_PRECIPITATE_WARNING_1, messageString, 499);
			swprintf(messageString,480,messageString,prot_prec);
        }
        else 
		{
            double enz_prec = proteinData->getInsoluble(proteinData->getEnzyme())/proteinData->getCurrentAmount(proteinData->getEnzyme())*100.0;
			double prot_prec = proteinData->getInsoluble(0)/proteinData->getCurrentAmount(0)*100.0;
			LoadString( hInst, IDS_PRECIPITATE_WARNING_2, messageString, 499);
            swprintf(messageString,480,messageString,enz_prec, prot_prec);
        }
        return TRUE;
	}           
    else // nothing precipitated out - just draw the profile
        return FALSE;
}           

void Separation::doPrecipitate()
{
	for (int i=0; i<proteinData->noOfProteins; i++) 
	{
		double current_amount = proteinData->getCurrentAmount(i);
        current_amount -= proteinData->getInsoluble(i);
        proteinData->setCurrentAmount(i, current_amount);
	} 
}

void Separation::Affinity_elution(int affinity_medium, int affinity_elution) 
{
         
	// get ligand affinities - scrambled for each enzyme.
    int affinity_ligand=0;
    int low_affinity=1;
    int medium_affinity = 2;
    int high_affinity = 3;
    int polyclonal = 4;
    int inhibitor = 5;
    int nickel = 6;
           
    int i = proteinData->enzyme % 6;
        
    switch (affinity_medium) 
	{
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
			affinity_ligand = nickel;break;
	}   
        
    for ( i=1; i<=proteinData->noOfProteins; i++) 
	{
		if (proteinData->getCurrentAmount(i) != 0.0) 
		{
			if (i==proteinData->enzyme) 
			{   
				// ideal situations
                if (((affinity_ligand==medium_affinity) && (affinity_elution == Tris)) ||
                    ((affinity_ligand==medium_affinity) && (affinity_elution == Acid)) ||
                    ((affinity_ligand==polyclonal) && (affinity_elution == Tris)) ||
                    ((affinity_ligand==polyclonal) && (affinity_elution == Acid)) ||
                    ((affinity_ligand==inhibitor) && (affinity_elution == Inhibitor)) ||
                    ((affinity_ligand==nickel) && (affinity_elution == Imidazole) && proteinData->getHisTag(i))) 
				{
                    
					proteinData->setK1(i, 100.0);
                    double gdFactor = proteinData->getK1(i)/100.0;
                    // losses due to failure to elute
                    if (affinity_ligand == medium_affinity) 
						proteinData->setCurrentAmount(i, proteinData->getCurrentAmount(i)*0.75);
                    if (affinity_ligand == polyclonal) 
						proteinData->setCurrentAmount(i, proteinData->getCurrentAmount(i)*0.3);
                    if (affinity_ligand == inhibitor) 
						proteinData->setCurrentAmount(i, proteinData->getCurrentAmount(i)*0.8);
                    // losses due to denaturation
                    if (affinity_elution == Acid) 
						proteinData->setCurrentActivity(i, proteinData->getCurrentActivity(i) / 2);
					proteinData->setK2(i, gdFactor * sqrt(proteinData->getCurrentAmount(i)));
                    if (proteinData->getK2(i)< 5.0)  
						proteinData->setK2(i, 5.0);
				}
                else if (affinity_ligand == high_affinity) 
				{
					// infinity chromatography
                    proteinData->setK1(i, 5000.0);
                    proteinData->setK2(i, 5.0);
                }
                else 
				{
					// default to running straight through
                    proteinData->setK1(i, 50.0);
                    proteinData->setK2(i, 5.0);
                    // losses due to denaturation
                    if (affinity_elution == Acid) proteinData->setCurrentActivity(i, proteinData->getCurrentActivity(i) / 2);
                }
			}
            else 
			{
				proteinData->setK1(i, 50.0);
                proteinData->setK2(i, 5.0);
            }
            proteinData->setK3(i, 10.0 * proteinData->getCurrentAmount(i)/proteinData->getK2(i));
        }
        else proteinData->setK3(i, 0.0);
    }
}