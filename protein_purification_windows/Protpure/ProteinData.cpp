#include "StdAfx.h"
#include <string>
#include <vector>
#include <cmath>
#include "Logs.h"
#include "Commands.h";
#include "Protein.h"
#include "Account.h"
#include "StepRecord.h"
#include "Protpure.h"
#include "ProteinData.h"

using namespace std;

extern Account *account;
extern Commands *commands;

ProteinData::ProteinData(void)
{

	Proteins.clear();
	Soluble.clear();
	Insoluble.clear();
	Soluble.push_back(0.0);
	Insoluble.push_back(0.0);
	hasScheme = FALSE;
	step = 0;
}


ProteinData::~ProteinData(void)
{
}

void ProteinData::resetSoluble()
{
	Soluble.clear();
	Soluble.push_back(0.0);
}

void ProteinData::resetInsoluble()
{
	Insoluble.clear();
	Insoluble.push_back(0.0);
}

void ProteinData:: appendSoluble(double amount)
{
	Soluble.push_back(amount);
}

void ProteinData:: appendInsoluble(double amount)
{
	Insoluble.push_back(amount);
}

double ProteinData::getSoluble(int protein_no)
{
	return Soluble.at(protein_no);
}

void ProteinData::setSoluble(int protein_no, double amount)
{
	Soluble[protein_no] = amount;
}

double ProteinData::getInsoluble(int protein_no)
{
	return Insoluble.at(protein_no);
}

void ProteinData::setInsoluble(int protein_no, double amount)
{
	Insoluble[protein_no] = amount;
}

void trim(char* line)
{
	int i = (int)strlen(line) - 1;
 
    while ( i > 0 )
    {
        if ( iscntrl(line[i]) )
        {
            line[i] = '\0';
        }
        else
        {
            break;
        }
        i--;
    }
}

int ProteinData::getEnzyme()
{
	return enzyme;
}

double ProteinData::getOriginalAmount(int protein_no)
{
	return Proteins.at(protein_no).original_amount;
}

double ProteinData::getCurrentAmount(int protein_no)
{
	return Proteins.at(protein_no).amount;
}

void ProteinData::setCurrentAmount(int protein_no, double amount )
{
	Proteins.at(protein_no).amount = amount;
}

int ProteinData::getOriginalActivity(int protein_no)
{
	return Proteins.at(protein_no).original_activity;
}

int ProteinData::getCurrentActivity(int protein_no)
{
	return Proteins.at(protein_no).activity;
}

void ProteinData::setCurrentActivity(int protein_no, int activity)
{
	Proteins.at(protein_no).activity = activity;
}

int ProteinData::getNoOfSub1(int protein_no)
{
	return Proteins.at(protein_no).NoOfSub1;
}

int ProteinData::getNoOfSub2(int protein_no)
{
	return Proteins.at(protein_no).NoOfSub2;
}

int ProteinData::getNoOfSub3(int protein_no)
{
	return Proteins.at(protein_no).NoOfSub3;
}

double ProteinData::getSubunit1(int protein_no)
{
	return Proteins.at(protein_no).subunit1;
}

double ProteinData::getSubunit2(int protein_no)
{
	return Proteins.at(protein_no).subunit2;
}

double ProteinData::getSubunit3(int protein_no)
{
	return Proteins.at(protein_no).subunit3;
}

double ProteinData::getMolWt(int protein_no)
{
	return Proteins.at(protein_no).MolWt;
}

double ProteinData::getTemp(int protein_no)
{
	return Proteins.at(protein_no).temp;
}

double ProteinData::getpH1(int protein_no)
{
	return Proteins.at(protein_no).pH1;
}

double ProteinData::getpH2(int protein_no)
{
	return Proteins.at(protein_no).pH2;
}

double ProteinData::getIsoPoint(int protein_no)
{
	return Proteins.at(protein_no).isopoint;
}

void ProteinData::setK1(int protein_no, double value)
{
	Proteins.at(protein_no).K1 = value;
}

double ProteinData::getK1(int protein_no)
{
	return Proteins.at(protein_no).K1;
}

void ProteinData::setK2(int protein_no, double value)
{
	Proteins.at(protein_no).K2 = value;
}

double ProteinData::getK2(int protein_no)
{
	return Proteins.at(protein_no).K2;
}

void ProteinData::setK3(int protein_no, double value)
{
	Proteins.at(protein_no).K3 = value;
}

double ProteinData::getK3(int protein_no)
{
	return Proteins.at(protein_no).K3;
}

BOOL ProteinData::getHisTag(int protein_no)
{
	return Proteins.at(protein_no).hisTag;
}

void ProteinData::incrementStep()
{
	step++;
}

int* ProteinData::charges(int asp,
			  int glu,
			  int his,
			  int lys,
			  int arg,
			  int tyr,
			  int cys)
{
	int charges[7]={asp,glu,his,lys,arg,tyr,cys};
	return charges;
}

double ProteinData::negCharge(double pH,double pK)
{
    double z = pow(10.0, pH - pK);
    return -z/(1.0+z);
}

double ProteinData::posCharge(double pH, double pK)
{
    double z = pow(10.0, pH - pK);
    return 1.0/(1.0 + z);
}

double ProteinData::Charge( double pH, int protein_no ) 
{
	// Calculate the total charge on one of the proteins at a particular pH value
    int chains = Proteins.at(protein_no).NoOfSub1+Proteins.at(protein_no).NoOfSub2+Proteins.at(protein_no).NoOfSub3;	
	int* charges = Proteins.at(protein_no).charges;

    double z = charges[0] * negCharge( pH, 4.6);
    z += charges[1] * negCharge( pH, 4.6);
    z += abs(charges[2]) * posCharge( pH, 6.65 );
    z += charges[3] * posCharge( pH, 10.2 );
    z += charges[4];
    z += charges[5] * negCharge( pH, 9.95 );
    z += charges[6] * negCharge( pH, 8.3 );
    z += chains * negCharge( pH, 3.75 );
    z += chains * posCharge( pH, 7.8 );
    return z;
}

double ProteinData::IsoelectricPoint( int protein_no ) 
{
    double pH = 7.0;
    double charge =  Charge( pH, protein_no);
    if (charge > 0.0) 
	{
		while (charge > 0.0) 
		{
			pH = pH + 1.0;
            charge = Charge( pH, protein_no );
        }
        while (charge < 0.0) 
		{
            pH = pH - 0.1;
            charge = Charge( pH, protein_no );
        }
        while (charge > 0.0) 
		{
            pH = pH + 0.01;
            charge = Charge( pH, protein_no );
        }
	}
    else 
	{
		while (charge < 0.0) 
		{
			pH = pH - 1.0;
            charge = Charge( pH, protein_no );
        }
        while (charge > 0.0) 
		{
			pH = pH + 0.1;
            charge = Charge( pH, protein_no );
        }
        while (charge < 0.0) 
		{
            pH = pH - 0.01;
            charge = Charge( pH, protein_no );
        }
	}
        return pH;
}
    

void ProteinData::parseData(char* text)
{
	hasScheme = FALSE;
	vector<char *> lines;

	// split the text into lines and store those that are not comments
	char* line = strtok(text,"\n");
	while (line != NULL)
	{
		if ((line[0] != '/') && (line[1] != '/'))
		{
			trim(line);
			lines.push_back(line);
		}
		line = strtok(NULL,"\n");
	}

	// Get the number of proteins in this mixture
	noOfProteins = atoi(lines.at(0));

	if (noOfProteins==0) return;

	// Clear the vector
	Proteins.clear();

	Protein* new_protein = new Protein(0,charges(0,0,0,0,0,0,0),0.0,0.0,0,0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,0);
	Proteins.push_back(*new_protein);

	int charges[7];
	float isopoint;
	float MolWt;
	int NoOfSub1;
	int NoOfSub2;
	int NoOfSub3;
	float subunit1;
	float subunit2;
	float subunit3;
	float original_amount;
	float amount;
	float temp;
	float pH1;
	float pH2;
	float sulphate;
	int original_activity;
	int activity;

	for (int protein=1; protein <= noOfProteins; protein++)
	{
		// Check that there are the correct number of elements (21) in the line
		char* s = lines.at(protein);
		int i;
		int count = 0;
		for (i=0; s[i]!='\0'; i++)
		{
			if (s[i]==',') count++;
		}

		if (count != 21)
		{
			noOfProteins = -1;  // flag a format error
			return;
		}
		
		char* element = strtok(lines.at(protein),",");

		charges[0] = atoi(element);
		for (int j=1; j<7; j++)
			charges[j] = atoi(strtok(NULL,","));

		isopoint = 0.0; // not in file - calculate it later
		MolWt = (float)atof(strtok(NULL,","));
		NoOfSub1 = atoi(strtok(NULL,","));
		NoOfSub2 = atoi(strtok(NULL,","));
		NoOfSub3 = atoi(strtok(NULL,","));
		subunit1 = (float)atof(strtok(NULL,","));
		subunit2 = (float)atof(strtok(NULL,","));
		subunit3 = (float)atof(strtok(NULL,","));
		original_amount = (float)atof(strtok(NULL,","));
        amount = (float)atof(strtok(NULL,","));
        temp = (float)atof(strtok(NULL,","));
        pH1 = (float)atof(strtok(NULL,","));
        pH2 = (float)atof(strtok(NULL,","));
        sulphate = (float)atof(strtok(NULL,","));
        original_activity = (float)atof(strtok(NULL,","));
        activity = (float)atof(strtok(NULL,","));

		new_protein = new Protein(protein,charges,isopoint,MolWt,NoOfSub1,NoOfSub2,NoOfSub3,subunit1,subunit2,subunit3,original_amount,amount,temp,pH1,pH2,sulphate,original_activity,activity);
		Proteins.push_back(*new_protein);
		
		// Calculate the missing values
		Proteins.at(protein).isopoint = IsoelectricPoint(protein);
		//LogA("Protein %d: isoelectric point: %f\n",protein,new_protein->isopoint);

		Proteins.at(0).amount += amount;
		Proteins.at(0).original_amount += original_amount;

	}

	// Check to see if there are any more data. If not, then return.
    if (noOfProteins == lines.size()-1) return;
    
    //if there are more data, there should be a history
    
    hasScheme = TRUE;

}

void ProteinData::parseScheme(char* text)
{
	vector<char *> lines;

	// split the text into lines and store those that are not comments
	char* line = strtok(text,"\n");
	while (line != NULL)
	{
		if ((line[0] != '/') && (line[1] != '/'))
		{
			trim(line);
			lines.push_back(line);
		}
		line = strtok(NULL,"\n");
	}

	// Get the number of proteins in this mixture
	noOfProteins = atoi(lines.at(0));

	// Now skip to the scheme data
    int i = noOfProteins+1;
    enzyme = atoi(lines.at(i));

	// Now that we know which enzyme is selected, we can (re)initialize the
    // Command variables and create new Account and Separation objects.
    commands->conditionStart(false);

	// Now set up the history
    i++;
    int history_steps = atoi(lines.at(i));
    step = history_steps;
    i+=2;
          
    double costing=0.0;
    double enzyme_units=0.0;

	for (int j=1; j<=history_steps; j++) 
	{
        StepRecord* record = new StepRecord();
		char* line = strtok(lines.at(i),",");
		int step_type = atoi(line);
        record->setStepType(step_type);
        
		line = strtok(NULL,",");
        double protein_amount = atof(line);
        record->setProteinAmount(protein_amount);

        line = strtok(NULL,",");               
        enzyme_units = atof(line);
        record->setEnzymeUnits(enzyme_units);
         
		line = strtok(NULL,",");  
        double enz_yield = atof(line);
        record->setEnzymeYield(enz_yield);
          
		line = strtok(NULL,","); 
        double enrich = atof(line);
        record->setEnrichment(enrich);  
        
		line = strtok(NULL,",");
        costing = atof(line);
        record->setCosting(costing);
                       
        account->appendRecord(*record);
                       
        i++;
	}
    // set the overall cost
    account->setCost(costing*enzyme_units/100.0);

}

void ProteinData::writeFile(WCHAR *path)
{
	string buf = "";
	buf += ("// The first non-comment line must contain the number of proteins in this mixture\r\n");
	buf += ("// and nothing else.\r\n");
	buf += ("//\r\n");
	buf += (""+to_string((long long)noOfProteins)+"\r\n");
	buf += ("//\r\n");
	buf += ("//\r\n");
	buf += ("// The subsequent lines contain the data for each protein in the mixture.\r\n");
	buf += ("// Each line must contain only comma-separated numbers with no white space or breaks.\r\n");
	buf += ("// On each line the fields are as follows:\r\n");
	buf += ("// Fields 1-7 contain the total numbers of ASP,GLU,HIS,LYS,ARG,TYR and CYS-SH\r\n");
	buf += ("// residues respectively in the whole protein molecule (i.e aggregated over\r\n");
	buf += ("// all polypeptide chains). These data are used to calculate the protein's charge\r\n");
	buf += ("// at any pH value, and hence also to calculate the isoelectric point.\r\n");
	buf += ("// Field 3 will be negative and less than -5 if a His tag is present.\r\n");
	buf += ("// Field 8 contains the overall native molecular weight of the protein.\r\n");
	buf += ("// Each protein can have up to three different types of polypeptide chain.\r\n");
	buf += ("// Field 9 contains the number of polypeptides of type 1. This must always be greater than zero.\r\n");
	buf += ("// Field 10 contains the number of polypeptides of type 2 if any or zero if not.\r\n");
	buf += ("// Field 11 contains the number of polypeptides of type 3 if any or zero if not.\r\n");
	buf += ("// Field 12 contains the molecular weight of polypeptide type 1. This cannot be zero.\r\n");
	buf += ("// Field 13 contains the molecular weight of polypeptide type 2\r\n");
	buf += ("//   or zero if there is only one type of polypeptide.\r\n");
	buf += ("// Field 14 contains the molecular weight of polypeptide type 3\r\n");
	buf += ("//   or zero if there is only one type of polypeptide.\r\n");
	buf += ("// Field 15 contains the amount (in mg) of this protein in the initial mixture\r\n");
	buf += ("// Field 16 contains the amount (in mg) of this protein in the mixture in its\r\n");
	buf += ("//   current state.  This is to allow partially purified mixtures to be saved and\r\n");
	buf += ("//   reloaded. When designing a mixture, set this field to the same value as field 15.\r\n");
	buf += ("// Field 17 contains the temperature below which the enzyme activity is stable.\r\n");
	buf += ("// Fields 18 and 19 contain the pH values between which the enzyme activity is stable\r\n");
	buf += ("// Field 20 is no longer used.\r\n");
	buf += ("// Field 21 contains an integer which represents the initial specific enzymic activity\r\n");
	buf += ("//   of the protein.\r\n");
	buf += ("// Field 22 contains an integer which represents the current specific activity.\r\n");
	buf += ("//   This will normally be the same as the value of field 21 unless denaturation has occurred.\r\n");
	buf += ("//\r\n");
	buf += ("// Comment lines must begin with //.\r\n");
	buf += ("// Blank lines are not allowed except at the end of the file.\r\n");
	buf += ("// Be careful - there is no value/error checking done on these values.\r\n");
	buf += ("// A bad file will probably crash the app. The usual disclaimers apply.\r\n");
	buf += ("//\r\n");
	buf += ("//                                                Andrew Booth 27th May 2013\r\n");
	buf += ("//\r\n");
	buf += ("// These are the data for this mixture:\r\n");
	buf += ("//\r\n");


	for (int p=1; p<Proteins.size(); p++)     //proteins[0] is not written to file  
	{
		for (int item=0; item<7; item++)
		{
			buf += to_string((long long)Proteins.at(p).charges[item])+",";
		}   
		// isoelectric point is not written to the file
		buf += to_string((long double)getMolWt(p))+",";
		buf += to_string((long long)getNoOfSub1(p))+",";
		buf += to_string((long long)getNoOfSub2(p))+",";
		buf += to_string((long long)getNoOfSub3(p))+",";    
		buf += to_string((long double)getSubunit1(p))+",";
		buf += to_string((long double)getSubunit2(p))+",";
		buf += to_string((long double)getSubunit3(p))+",";
		buf += to_string((long double)getOriginalAmount(p))+",";
		buf += to_string((long double)getCurrentAmount(p))+",";
		buf += to_string((long double)getTemp(p))+",";
		buf += to_string((long double)getpH1(p))+",";
		buf += to_string((long double)getpH2(p))+",";
		buf += "0,";
		buf += to_string((long long)getOriginalActivity(p))+",";
		buf += to_string((long long)getCurrentActivity(p));
		buf += "\r\n";

	}

    if (step > 0)  // save the history
	{        	
		buf += "// The scheme purification history follows:\r\n";
        buf += "// Enzyme\r\n";
        buf += to_string((long long)getEnzyme())+"\r\n";
        buf += "// Purification steps so far\r\n";
        buf += to_string((long long)step)+"\r\n";
        buf += ("// Method, Protein (mg), Enzyme (Units), Enzyme Yield, Enrichment, Cost\r\n");
        for (int i=0; i<=step; i++) 
		{
			StepRecord step = account->getStepRecord(i);
            buf += to_string((long long)step.getStepType())+",";
            buf += to_string((long double)step.getProteinAmount())+",";
            buf += to_string((long double)step.getEnzymeUnits())+",";
            buf += to_string((long double)step.getEnzymeYield())+",";
            buf += to_string((long double)step.getEnrichment())+",";
            buf += to_string((long double)step.getCosting());
            buf += ("\r\n");    
         
		}               
                
	}
    
	HANDLE out = CreateFile( path, FILE_WRITE_DATA, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	DWORD n;
	WriteFile( out, buf.c_str(), buf.length(), &n, NULL);
	CloseHandle( out);
}
