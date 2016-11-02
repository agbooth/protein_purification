#include "StdAfx.h"
#include "StepRecord.h"

StepRecord::StepRecord(void)
{
	record.stepType = 0;
	record.proteinAmount = 0.0;
	record.enzymeUnits = 0.0;
	record.enzymeYield = 0.0;
	record.enrichment = 0.0;
	record.costing = 0.0;
}


StepRecord::~StepRecord(void)
{
}

void StepRecord::setStepType(int steptype) 
{
	record.stepType = steptype;
}

int StepRecord::getStepType() 
{
	return record.stepType;
}

void StepRecord::setProteinAmount(double amount) 
{
	record.proteinAmount = amount;
}

double StepRecord::getProteinAmount() 
{
	return record.proteinAmount;
}
        
void StepRecord::setEnzymeUnits(double units) 
{
	record.enzymeUnits = units;
}

double StepRecord::getEnzymeUnits() 
{
    return record.enzymeUnits;
}

void StepRecord::setEnzymeYield(double enzyield) 
{
    record.enzymeYield = enzyield;
}

double StepRecord::getEnzymeYield() 
{
    return record.enzymeYield;
}

void StepRecord::setEnrichment(double enrich) 
{
	record.enrichment = enrich; 
    }

double StepRecord::getEnrichment() 
{
	return record.enrichment;
}

void StepRecord::setCosting(double costing) 
{
	record.costing = costing;
}

double StepRecord::getCosting() 
{
	return record.costing;
}
    
void StepRecord::incrementCosting(double increment)
{
    	double costing = getCosting();
    	costing += increment;
    	setCosting(costing);
}
