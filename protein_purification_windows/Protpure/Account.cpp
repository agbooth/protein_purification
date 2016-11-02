#include "StdAfx.h"
#include "Account.h"
#include "ProteinData.h"
#include "Logs.h"
#include "Commands.h"

extern ProteinData* proteinData;
extern Commands* commands;

Account::Account(void)
{
	account.clear();
	costing = 0.0;

	// Add the data for the initial mixture
	record = new StepRecord();
	record->setStepType(0);

	record->setProteinAmount(proteinData->getOriginalAmount(0));

	enzyme = proteinData->getEnzyme();
	enz = proteinData->getOriginalAmount(enzyme)*proteinData->getOriginalActivity(enzyme)*100.0;
	record->setEnzymeUnits(enz);

	record->setEnzymeYield(100.0);
	record->setEnrichment(1.0);
	record->setCosting(costing);

	account.push_back(*record);
}


Account::~Account(void)
{
}

void Account::addCost(double cost)
{
	costing += cost;
}

double Account::getCost()
{
	return costing;
}

void Account::setCost(double cost)
{
	costing = cost;
}

void Account::appendRecord(StepRecord record)
{
	account.push_back(record);
}

void Account::addStepRecord()
{
	enzyme = proteinData->getEnzyme();
	double ActivityFactor = (double)proteinData->getCurrentActivity(enzyme)/(double)proteinData->getOriginalActivity(enzyme);
    enz = proteinData->getCurrentAmount(enzyme)*proteinData->getOriginalActivity(enzyme)*100.0;
     
    double enzyield;
    if (proteinData->getCurrentAmount(enzyme)==0.0)
		enzyield = 0.0;
    else
        enzyield = proteinData->getCurrentAmount(enzyme)/proteinData->getOriginalAmount(enzyme)*100.0*ActivityFactor;
           
    double enrich;
    if (enzyield < 0.01)
		enrich = 0.0;
    else
		enrich = (proteinData->getCurrentAmount(enzyme)/proteinData->getCurrentAmount(0))/(proteinData->getOriginalAmount(enzyme)/proteinData->getOriginalAmount(0))*ActivityFactor;
            
    double cost;
    if (enz > 0.01)
		cost = costing*100.0/enz;
    else
        cost = 0.0;
        
    record = new StepRecord();
    record->setStepType(commands->sepType);
    record->setProteinAmount(proteinData->getCurrentAmount(0));
    record->setEnzymeUnits(enz);
    record->setEnzymeYield(enzyield);
    record->setEnrichment(enrich);
    record->setCosting(cost);
        
    account.push_back(*record);
}

StepRecord Account::getStepRecord(int i)
{
	return account.at(i);
}
