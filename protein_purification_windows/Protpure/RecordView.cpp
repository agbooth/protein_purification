#include "StdAfx.h"
#include "RecordView.h"
#include "EZFont.h"
#include "Resource.h"
#include "ProteinData.h"
#include "Account.h"
#include "StepRecord.h"
#include "Protpure.h"
#include "Logs.h"

extern HINSTANCE hInst;
extern HBRUSH hDlgBkgBrush;
extern ProteinData *proteinData;
extern Account *account;

int DrawText(HDC hdc, int x, int y, LPWSTR text, int pointsize, COLORREF colour)
{
	HFONT hFont;
	LOGFONT lf;
	TEXTMETRIC tm;

	hFont = EzCreateFont( hdc, TEXT("Arial"), pointsize * 10, 0, EZ_ATTR_BOLD, TRUE);
	GetObject(hFont, sizeof(LOGFONT), &lf);
	SelectObject (hdc, hFont);
	GetTextMetrics(hdc, &tm);
	SetBkMode(hdc, TRANSPARENT);
	SetTextColor(hdc, colour);
	TextOut(hdc, x,y, text, lstrlen(text));
	DeleteObject(SelectObject( hdc, GetStockObject(SYSTEM_FONT)));

	return tm.tmHeight+tm.tmExternalLeading;
}

TCHAR methodString[60];
LPWSTR getMethodString(int method)
{
	

	switch(method)
	{
		case None: LoadString(hInst, IDS_INITIAL, (LPWSTR)methodString, 50); break;
		case Ammonium_sulfate: LoadString(hInst, IDS_AMMONIUM_SULFATE, (LPWSTR)methodString, 50); break;
		case Heat_treatment: LoadString(hInst, IDS_HEAT_TREATMENT, (LPWSTR)methodString, 50); break;
		case Gel_filtration: LoadString(hInst, IDS_GEL_FILTRATION, (LPWSTR)methodString, 50); break;
		case Ion_exchange: LoadString(hInst, IDS_ION_EXCHANGE, (LPWSTR)methodString, 50); break;
		case Hydrophobic_interaction: LoadString(hInst, IDS_HYDROPHOBIC_INTERACTION, (LPWSTR)methodString, 50); break;
		case Affinity: LoadString(hInst, IDS_AFFINITY_CHROMATOGRAPHY, (LPWSTR)methodString, 50); break;
		default: LoadString(hInst, IDS_UNKNOWN, (LPWSTR)methodString, 50); break;
	}
	return (LPWSTR) methodString;
}

void PaintRecord(HWND hWnd)
{
	PAINTSTRUCT ps;
    HDC hdc = BeginPaint(hWnd, &ps);

	TCHAR title_raw[200];
	TCHAR szWording[200];
	
	//FillRect(hdc, &ps.rcPaint, hDlgBkgBrush);

	// Draw the title
	LoadString(hInst, IDS_RECORDTITLE, (LPWSTR)title_raw, 100 );
	swprintf((LPWSTR)szWording,199,(LPWSTR)title_raw, proteinData->enzyme, proteinData->mixtureName);
	DrawText( hdc, 25, 41, (LPWSTR)szWording, 15, RGB(255,255,255));
	DrawText( hdc, 25, 40, (LPWSTR)szWording, 15, RGB(76,86,108));

    // Method heading
	LoadString(hInst, IDS_METHOD, (LPWSTR)szWording, 100 );
	DrawText( hdc, 25, 101, (LPWSTR)szWording, 11, RGB(255,255,255));
	DrawText( hdc, 25, 100, (LPWSTR)szWording, 11, RGB(76,86,108));

	// Protein heading
	LoadString(hInst, IDS_PROTEIN, (LPWSTR)szWording, 100 );
	DrawText( hdc, 200, 101, (LPWSTR)szWording, 11, RGB(255,255,255));
	DrawText( hdc, 200, 100, (LPWSTR)szWording, 11, RGB(76,86,108));

	// Enzyme heading
	LoadString(hInst, IDS_ENZYME, (LPWSTR)szWording, 100 );
	DrawText( hdc, 310, 101, (LPWSTR)szWording, 11, RGB(255,255,255));
	DrawText( hdc, 310, 100, (LPWSTR)szWording, 11, RGB(76,86,108));

	// Yield heading
	LoadString(hInst, IDS_YIELD, (LPWSTR)szWording, 100 );
	DrawText( hdc, 440, 101, (LPWSTR)szWording, 11, RGB(255,255,255));
	DrawText( hdc, 440, 100, (LPWSTR)szWording, 11, RGB(76,86,108));

	// Enrichment heading
	LoadString(hInst, IDS_ENRICHMENT, (LPWSTR)szWording, 100 );
	DrawText( hdc, 520, 101, (LPWSTR)szWording, 11, RGB(255,255,255));
	DrawText( hdc, 520, 100, (LPWSTR)szWording, 11, RGB(76,86,108));

	// Cost heading
	LoadString(hInst, IDS_COST, (LPWSTR)szWording, 100 );
	DrawText( hdc, 620, 101, (LPWSTR)szWording, 11, RGB(255,255,255));
	DrawText( hdc, 620, 100, (LPWSTR)szWording, 11, RGB(76,86,108));

	int step = proteinData->step;
	int ypos = 130;
	int increment = 0;

	for (int i=0; i<=step; i++)
	{
		StepRecord record = account->getStepRecord(i);
		LPWSTR method = getMethodString(record.getStepType());
		increment = DrawText(hdc, 30, ypos, method, 10, RGB(0,0,0));

		swprintf((LPWSTR)szWording,199,(LPWSTR)L"%6.1f",record.getProteinAmount());
		DrawText(hdc, 215, ypos, (LPWSTR)szWording, 10, RGB(0,0,0));

		swprintf((LPWSTR)szWording,199,(LPWSTR)L"%6.1f",record.getEnzymeUnits());
		DrawText(hdc, 335, ypos, (LPWSTR)szWording, 10, RGB(0,0,0));

		swprintf((LPWSTR)szWording,199,(LPWSTR)L"%6.1f",record.getEnzymeYield());
		DrawText(hdc, 450, ypos, (LPWSTR)szWording, 10, RGB(0,0,0));

		swprintf((LPWSTR)szWording,199,(LPWSTR)L"%6.1f",record.getEnrichment());
		DrawText(hdc, 535, ypos, (LPWSTR)szWording, 10, RGB(0,0,0));

		double costing = record.getCosting();
		if (costing == 0.0)
			DrawText(hdc, 632, ypos, (LPWSTR)"0", 10, RGB(0,0,0));
		else
		{
			swprintf((LPWSTR)szWording,199,(LPWSTR)L"%6.3f",record.getCosting());
			DrawText(hdc, 617, ypos, (LPWSTR)szWording, 10, RGB(0,0,0));
		}

		ypos += 3*increment/2;
	}

	if (step==0)
	{
		LoadString (hInst, IDS_FURTHER_RECORDS, (LPWSTR)szWording, 100);
		DrawText(hdc, 25, ypos+1, (LPWSTR)szWording, 11, RGB(255,255,255));
		DrawText(hdc, 25, ypos, (LPWSTR)szWording, 11, RGB(76,86,108));
	}


    EndPaint(hWnd, &ps);
}