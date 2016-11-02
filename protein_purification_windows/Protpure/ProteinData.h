#include "StdAfx.h"
#include <string>
#include <vector>
#include "Protein.h"

class ProteinData
{
public:
	ProteinData(void);
	~ProteinData(void);
	double Charge( double pH, int protein_no );
	double IsoelectricPoint( int protein_no );
	void parseData(char*);
	void parseScheme(char*);
	double getOriginalAmount(int);
	double getCurrentAmount(int);
	void setCurrentAmount(int, double);
	int getOriginalActivity(int);
	void setCurrentActivity(int, int);
	int getCurrentActivity(int);
	int getEnzyme(void);
	double getMolWt(int);
	int getNoOfSub1(int);
	int getNoOfSub2(int);
	int getNoOfSub3(int);
	double getSubunit1(int);
	double getSubunit2(int);
	double getSubunit3(int);
	double getTemp(int);
	double getpH1(int);
	double getpH2(int);
	double getIsoPoint(int);
	void setK1(int, double);
	double getK1(int);
	void setK2(int, double);
	double getK2(int);
	void setK3(int, double);
	double getK3(int);
	BOOL getHisTag(int);

	void resetSoluble();
	void resetInsoluble();
	void appendSoluble(double);
	void appendInsoluble(double);
	double getSoluble(int);
	void setSoluble(int, double);
	double getInsoluble(int);
	void setInsoluble(int, double);

	void incrementStep();

	void writeFile(WCHAR*);

	LPWSTR mixtureName;
	WCHAR fileName[MAX_PATH];
	int noOfProteins;
	int enzyme;
	int step;
	BOOL hasScheme;
	std::vector<Protein> Proteins;
	std::vector<double> Soluble;
	std::vector<double> Insoluble;

private:
	int* charges(int asp,
			  int glu,
			  int his,
			  int lys,
			  int arg,
			  int tyr,
			  int cys);
	double negCharge(double pH,double pK);
	double posCharge(double pH,double pK);
};

