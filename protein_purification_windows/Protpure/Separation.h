#pragma once
#include <vector>
class Separation
{
public:
	Separation(void);
	~Separation(void);

	void AS(double);
	void HeatTreatment(double, double);
	void GelFiltrationElution(double, double, BOOL);
	void DEAE_salt_elution(double, double, double, BOOL);
	void DEAE_pH_elution(double, double, double, BOOL);
	void CM_salt_elution(double, double, double, BOOL);
	void CM_pH_elution(double, double, double, BOOL);
	void HIC_elution(double, double, int, double );
	void Affinity_elution(int, int);

	void SetPlotArray(void);
	double GetPlotElement(int, int);

	void PoolFractions(int, int);

	BOOL checkPrecipitate(double);
	void doPrecipitate();

	WCHAR mediumString[300];
	WCHAR sepString[300];
	WCHAR messageString[500];

private:
	double getLogSzero(int);
	double getSalt(int);
	double Gauss(int, int);
	std::vector<std::vector<double> > fractions;  // a vector of vectors
};



