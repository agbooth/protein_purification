#include "StdAfx.h"
#include "GelView.h"
#include "EZFont.h"
#include "Resource.h"
#include "ProteinData.h"
#include "Commands.h"
#include "Separation.h"
#include "StepRecord.h"
#include "Protpure.h"
#include "Logs.h"

#define t_centre	0
#define t_left	1
#define t_right	2

extern HINSTANCE hInst;
extern HBRUSH hDlgBkgBrush;
extern ProteinData *proteinData;
extern Commands *commands;
extern Separation *separation;

extern BOOL showBlot;
extern BOOL twoDGel;

double xscale;
double yscale;
double xOffset;
double yOffset;
double labelXOffset;

extern int clientWidth;
extern int clientHeight;

double Mobility(double MW)
{
	return 120.0*(11.5-log(MW));
}

double xScale(double x)
{
	return (x + xOffset)*xscale;
}

double yScale( double y)
{
	return (y + yOffset)*yscale;
}

void create_line(HDC hdc, double X1, double Y1, double X2, double Y2, int colour)
{
	double x1 = xScale(X1);
	double y1 = yScale(Y1);
	double x2 = xScale(X2);
	double y2 = yScale(Y2);

	SaveDC( hdc);
	HPEN hPen = CreatePen(PS_SOLID, 1, colour);
	SelectObject(hdc, hPen);
	MoveToEx(hdc, (ULONG)x1, (ULONG)y1, NULL);
	LineTo(hdc, (ULONG)x2, (ULONG)y2);

	DeleteObject(hPen);
	RestoreDC(hdc, -1);
}

void create_rhombus(HDC hdc, double X1, double Y1, double X2, double Y2, double X3, double Y3, double X4, double Y4, int fillColour, int strokeColour )
{
	POINT coords[4];
	coords[0].x = (ULONG)xScale(X1);
	coords[0].y = (ULONG)yScale(Y1);
	coords[1].x = (ULONG)xScale(X2);
	coords[1].y = (ULONG)yScale(Y2);
	coords[2].x = (ULONG)xScale(X3);
	coords[2].y = (ULONG)yScale(Y3);
	coords[3].x = (ULONG)xScale(X4);
	coords[3].y = (ULONG)yScale(Y4);

	SaveDC( hdc);
	HPEN hPen = CreatePen(PS_SOLID, 1, strokeColour);
	SelectObject(hdc, hPen);
	HBRUSH hBrush = CreateSolidBrush(fillColour);
	SelectObject(hdc, hBrush);

	SetPolyFillMode( hdc, WINDING );
	Polygon( hdc, coords, 4);
	DeleteObject( hBrush );
	DeleteObject(hPen);
	RestoreDC(hdc, -1);
}

void create_polygon(HDC hdc, FPOINT* coords, int no, int colour)
{

	POINT* new_coords = (LPPOINT)malloc(no*sizeof(POINT));

	for (int i=0; i<no; i++)
	{
		new_coords[i].x = (ULONG)xScale(coords[i].x);
		new_coords[i].y = (ULONG)yScale(coords[i].y);
	}

	SaveDC( hdc);
	HPEN hPen = CreatePen(PS_SOLID, 1, colour);
	SelectObject(hdc, hPen);
	HBRUSH hBrush = CreateSolidBrush(colour);
	SelectObject(hdc, hBrush);

	SetPolyFillMode( hdc, WINDING );
	Polygon( hdc, new_coords, no);
	DeleteObject( hBrush );
	DeleteObject(hPen);
	free(new_coords);
	RestoreDC(hdc, -1);

}


void create_text_at_point(HDC hdc, LPWSTR text, double X, double Y, double size, int colour, double angle, BOOL italic, int alignment)
{
	HFONT hFont;
	LOGFONT lf;
	TEXTMETRIC tm;

	double x = xScale(X);
	double y = yScale(Y);

	SaveDC( hdc);

	hFont = EzCreateFont( hdc, TEXT("Arial"), (int)size * 10, 0, italic?EZ_ATTR_ITALIC:0, TRUE);
	GetObject(hFont, sizeof(LOGFONT), &lf);
	if (angle==90.0)
	{
		lf.lfOrientation = 900;
		lf.lfEscapement = 900;
	}
	if (angle==-90.0)
	{
		lf.lfOrientation = 2700;
		lf.lfEscapement = 2700;
	}
	SelectObject( hdc, CreateFontIndirect(&lf));
	GetTextMetrics(hdc, &tm);
	switch (alignment)
	{
	case t_centre:
		SetTextAlign(hdc, TA_CENTER | TA_BASELINE);
		break;
	case t_right:
		SetTextAlign(hdc, TA_RIGHT | TA_BASELINE);
		break;
	default:
		SetTextAlign(hdc, TA_LEFT | TA_BASELINE);
		break;


	}
	SetBkMode(hdc, TRANSPARENT);
	SetTextColor(hdc, colour);
	TextOut(hdc, (ULONG)x,(ULONG)y, text, lstrlen(text));
	DeleteObject(SelectObject( hdc, GetStockObject(SYSTEM_FONT)));
	RestoreDC(hdc, -1);
}

void Band(HDC hdc, int no, double MW, double intensity)
{
	
	if ((MW > 80000) || (MW < 5000)) return;

	int colour;

	if (showBlot) colour=RGB(0,0,0);
	else colour = RGB(0,0,255);

	if (intensity < 0.001) return;

	double ypos = Mobility(MW);
	double xpos = 4.0+(30.0*no);

	FPOINT coords[4];
	int n;

	if ((intensity >=0.001) && (intensity < 0.05))
	{
		coords[0].x = xpos; coords[0].y = ypos;
		coords[1].x = xpos+24.0; coords[1].y = ypos;
		n = 2;
	}
	if ((intensity >=0.05) && (intensity < 0.2))
	{
		coords[0].x = xpos; coords[0].y = ypos;
		coords[1].x = xpos+24.0; coords[1].y = ypos;
		coords[2].x = xpos+24.0; coords[2].y = ypos+2.0;
		coords[3].x = xpos; coords[3].y = ypos+2.0;
		n = 4;
	}
	if ((intensity >=0.2) && (intensity < 0.5))
	{
		coords[0].x = xpos; coords[0].y = ypos;
		coords[1].x = xpos+24.0; coords[1].y = ypos;
		coords[2].x = xpos+24.0; coords[2].y = ypos+3.0;
		coords[3].x = xpos; coords[3].y = ypos+3.0;
		n = 4;
	}
	if (intensity >=0.5)
	{
		coords[0].x = xpos; coords[0].y = ypos;
		coords[1].x = xpos+24.0; coords[1].y = ypos;
		coords[2].x = xpos+24.0; coords[2].y = ypos+4.0;
		coords[3].x = xpos; coords[3].y = ypos+4.0;
		n = 4;
	}

	create_polygon(hdc, coords, n, colour);
}

void Spot(HDC hdc, double isopoint, double MW, double intensity)
{
	
	if ((MW > 80000) || (MW < 5000)) return;
	if ((isopoint < 4.3) || (isopoint > 8.7)) return;

	int colour;

	if (showBlot) colour=RGB(0,0,0);
	else colour = RGB(0,0,255);

	if (intensity < 0.0005) return;

	double ypos = Mobility(MW);
	double xpos = (isopoint-4.0)*100.0;

	FPOINT coords[16];
	int n;

	if ((intensity >=0.0005) && (intensity < 0.001))
	{
		coords[0].x = xpos-4; coords[0].y = ypos;
		coords[1].x = xpos+4.0; coords[1].y = ypos;
		n = 2;
	}
	if ((intensity >=0.001) && (intensity < 0.01))
	{
		coords[0].x = xpos-5; coords[0].y = ypos;
		coords[1].x = xpos-3; coords[1].y = ypos-1;
		coords[2].x = xpos+3; coords[2].y = ypos-1;
		coords[3].x = xpos+5; coords[3].y = ypos;
		coords[4].x = xpos+3; coords[4].y = ypos+2;
		coords[5].x = xpos-3; coords[5].y = ypos+2;
		n = 6;
	}
	if ((intensity >=0.01) && (intensity < 0.1))
	{
		coords[0].x = xpos-5; coords[0].y = ypos;
		coords[1].x = xpos-3; coords[1].y = ypos-1;
		coords[2].x = xpos+3; coords[2].y = ypos-1;
		coords[3].x = xpos+5; coords[3].y = ypos;
		coords[4].x = xpos+3; coords[4].y = ypos+3;
		coords[5].x = xpos-3; coords[5].y = ypos+3;
		n = 6;
	}
	if ((intensity >=0.1) && (intensity < 0.2))
	{
		coords[0].x = xpos-6; coords[0].y = ypos;
		coords[1].x = xpos-4; coords[1].y = ypos-3;
		coords[2].x = xpos+4; coords[2].y = ypos-3;
		coords[3].x = xpos+6; coords[3].y = ypos;
		coords[4].x = xpos+4; coords[4].y = ypos+3;
		coords[5].x = xpos+2; coords[5].y = ypos+6;
		coords[6].x = xpos-2; coords[6].y = ypos+6;
		coords[7].x = xpos-4; coords[7].y = ypos+3;
		n = 8;
	}
	if ((intensity >=0.2) && (intensity < 0.5))
	{
		coords[0].x = xpos-8; coords[0].y = ypos;
		coords[1].x = xpos-6; coords[1].y = ypos-3;
		coords[2].x = xpos+6; coords[2].y = ypos-3;
		coords[3].x = xpos+8; coords[3].y = ypos;
		coords[4].x = xpos+6; coords[4].y = ypos+3;
		coords[5].x = xpos+4; coords[5].y = ypos+6;
		coords[6].x = xpos+2; coords[6].y = ypos+9;
		coords[7].x = xpos-2; coords[7].y = ypos+9;
		coords[8].x = xpos-4; coords[8].y = ypos+6;
		coords[9].x = xpos-6; coords[9].y = ypos+3;
		n = 10;
	}
	if (intensity >=0.5)
	{
		coords[0].x = xpos-10; coords[0].y = ypos;
		coords[1].x = xpos-8; coords[1].y = ypos-3;
		coords[2].x = xpos-4; coords[2].y = ypos-6;
		coords[3].x = xpos+4; coords[3].y = ypos-6;
		coords[4].x = xpos+8; coords[4].y = ypos-3;
		coords[5].x = xpos+10; coords[5].y = ypos;
		coords[6].x = xpos+10; coords[6].y = ypos+3;
		coords[7].x = xpos+8; coords[7].y = ypos+6;
		coords[8].x = xpos+6; coords[8].y = ypos+9;
		coords[9].x = xpos+4; coords[9].y = ypos+12;
		coords[10].x = xpos+2; coords[10].y = ypos+15;
		coords[11].x = xpos-2; coords[11].y = ypos+15;
		coords[12].x = xpos-4; coords[12].y = ypos+12;
		coords[13].x = xpos-6; coords[13].y = ypos+9;
		coords[14].x = xpos-8; coords[14].y = ypos+6;
		coords[15].x = xpos-10; coords[15].y = ypos+3;
		n = 16;
	}

	create_polygon(hdc, coords, n, colour);
}


void Markers(HDC hdc)
{
	WCHAR numbers[10];
	double width;
	if (twoDGel)
		width = 500;
	else if (commands->pooled)
			width = 60.0;
	else
		width = 30.0 +(30.0*max(1,commands->frax.size()));

	double x = 0;
	double y = 0;

	int colour = RGB(208,208,224); 

	if (showBlot)
	{
		colour = RGB(255,255,255);
	    create_rhombus( hdc,
					   x,y,
					   x+width,y,
					   x+width,y+360,
					   x, y+360,
					   colour,
					   RGB(0,0,0));
	}
	else
	{
		create_rhombus( hdc,
					   x,y,
					   x+width,y,
					   x+width,y+360,
					   x, y+360,
					   colour,
					   RGB(127,127,127));

		colour = RGB(127,127,127);

		create_rhombus( hdc,
					   x+width,y,
					   x+width+4,y+2,
					   x+width+4,y+362,
					   x+width, y+360,
					   colour,
					   RGB(0,0,0));

		create_rhombus( hdc,
					   x,y+360,
					   x+4,y+362,
					   x+width+4,y+362,
					   x+width, y+360,
					   colour,
					   RGB(0,0,0));

		create_line( hdc, x, y+360, x, y, RGB(192,192,192));
		create_line( hdc, x, y, x+width, y, RGB(192,192,192));
	}
	if (twoDGel)
	{ 
		// Top labels
		create_text_at_point( hdc, L"pH", (double)width/2.0, -30.0, 12.0, RGB(0,0,0), 0, FALSE, t_centre);

		for (int i=4; i<=9; i++)
		{
			double j = x+100.0*(i-4);
			_itow_s(i,numbers,10);
			create_text_at_point(hdc,numbers , j+1, y-10.0, 10, RGB(0,0,0),0.0,FALSE,t_centre);
			create_line( hdc, j, y-8,j,y-3, RGB(0,0,0));

		}
	}
	else  // 1D PAGE
		if (!showBlot)  //Show the markers
		{
			Band(hdc, 0, 8E4, 0.01);
			Band(hdc, 0, 6.88E4, 0.01);
			Band(hdc, 0, 5E4, 0.01);
			Band(hdc, 0, 4.5E4, 0.01);
			Band(hdc, 0, 3.6E4, 0.01);
			Band(hdc, 0, 2.5E4, 0.01);
			Band(hdc, 0, 1.4E4, 0.01);
			Band(hdc, 0, 9E3, 0.01);
			Band(hdc, 0, 6E3, 0.01);
		}
	// Side labels - both 1D and 2D
	create_line(hdc,
		        x-12, y+Mobility(8E4),
				x-3,  y+Mobility(8E4),
				RGB(0,0,0));
	create_text_at_point(hdc,
				L"80K",
		        x-16, y+Mobility(8E4)+4,
				10,
				RGB(0,0,0),
				0.0,
				FALSE,
				t_right);
	create_line(hdc,
		        x-12, y+Mobility(6E4),
				x-3,  y+Mobility(6E4),
				RGB(0,0,0));
	create_text_at_point(hdc,
				L"60K",
		        x-16, y+Mobility(6E4)+4,
				10,
				RGB(0,0,0),
				0.0,
				FALSE,
				t_right);
	create_line(hdc,
		        x-12, y+Mobility(5E4),
				x-3,  y+Mobility(5E4),
				RGB(0,0,0));
	create_text_at_point(hdc,
				L"50K",
		        x-16, y+Mobility(5E4)+4,
				10,
				RGB(0,0,0),
				0.0,
				FALSE,
				t_right);
	create_line(hdc,
		        x-12, y+Mobility(4E4),
				x-3,  y+Mobility(4E4),
				RGB(0,0,0));
	create_text_at_point(hdc,
				L"40K",
		        x-16, y+Mobility(4E4)+4,
				10,
				RGB(0,0,0),
				0.0,
				FALSE,
				t_right);
	create_line(hdc,
		        x-12, y+Mobility(3E4),
				x-3,  y+Mobility(3E4),
				RGB(0,0,0));
	create_text_at_point(hdc,
				L"30K",
		        x-16, y+Mobility(3E4)+4,
				10,
				RGB(0,0,0),
				0.0,
				FALSE,
				t_right);
	create_line(hdc,
		        x-12, y+Mobility(2E4),
				x-3,  y+Mobility(2E4),
				RGB(0,0,0));
	create_text_at_point(hdc,
				L"20K",
		        x-16, y+Mobility(2E4)+4,
				10,
				RGB(0,0,0),
				0.0,
				FALSE,
				t_right);
	create_line(hdc,
		        x-12, y+Mobility(1E4),
				x-3,  y+Mobility(1E4),
				RGB(0,0,0));
	create_text_at_point(hdc,
				L"10K",
		        x-16, y+Mobility(1E4)+4,
				10,
				RGB(0,0,0),
				0.0,
				FALSE,
				t_right);
	create_line(hdc,
		        x-12, y+Mobility(5E3),
				x-3,  y+Mobility(5E3),
				RGB(0,0,0));
	create_text_at_point(hdc,
				L"5K",
		        x-16, y+Mobility(5E3)+4,
				10,
				RGB(0,0,0),
				0.0,
				FALSE,
				t_right);

	create_text_at_point( hdc,
						  L"M",
						  x-85.0+labelXOffset,y+Mobility(2.5E4),
						  12,
						  RGB(0,0,0),
						  0.0,
						  FALSE,
						  t_right);
	create_text_at_point( hdc,
						  L"r",
						  x-84.0+labelXOffset, y+Mobility(2.45E4),
						  10,
						  RGB(0,0,0),
						  0.0,
						  TRUE,
						  t_left);
	WCHAR label[200];

	if (twoDGel)
	{
		if (showBlot)
		{
			LoadString(hInst, IDS_USING_ANTIBODY,label, 199);
			swprintf(label,199,label,proteinData->enzyme);
		}
		else
		{
			if (commands->pooled)
			{
				if (proteinData->step == 0)
					LoadString(hInst, IDS_2D_INITIAL, label, 199);
				else
					LoadString(hInst, IDS_2D_POOLED, label, 199);
			}
			else
			{
				int fraction = commands->frax[0];
				LoadString(hInst, IDS_2D_FRACTION,label, 199);
				swprintf(label,199,label,fraction);
			}
		}

		create_text_at_point( hdc,
							  label,
							  width/2.0, 400,
							  15,
							  RGB(0,0,0),
							  0.0,
							  TRUE,
							  t_centre);

	}
	else // 1D gel
	{
		if (showBlot)
		{
			LoadString(hInst, IDS_USING_ANTIBODY,label, 199);
			swprintf(label,199,label,proteinData->enzyme);
		}
		else
		{
			if (commands->pooled)
			{
				if (proteinData->step == 0)
					LoadString(hInst, IDS_INITIAL_MIXTURE, label, 199);
				else
					LoadString(hInst, IDS_POOLED_FRACTIONS, label, 199);
			}
			else
			{
				if (commands->frax.size() == 1)
					LoadString(hInst, IDS_SELECTED_FRACTION,label, 199);
				else
					LoadString(hInst, IDS_SELECTED_FRACTIONS,label, 199);
			}
		}

		create_text_at_point( hdc,
							  label,
							  0, 400,
							  15,
							  RGB(0,0,0),
							  0.0,
							  TRUE,
							  t_left);

	}
				
}

void showBands( HDC hdc)
{
	double sensitivityCutoff = 1.5; //Deacrease this to make staining more sensitive

	int firstprotein;
	int lastprotein;

	double amount;
	double total;

	WCHAR label[200];

	double *aggregate = (double*)malloc(sizeof(double)*(proteinData->noOfProteins+1));
	aggregate[0] = 0.0;

	for (int i=1; i<=proteinData->noOfProteins; i++)
		aggregate[i] = proteinData->getNoOfSub1(i) * proteinData->getSubunit1(i)
					 + proteinData->getNoOfSub2(i) * proteinData->getSubunit2(i)
					 + proteinData->getNoOfSub3(i) * proteinData->getSubunit3(i);

	if (showBlot)
	{
		firstprotein = proteinData->enzyme;
		lastprotein = firstprotein + 1;
	}
	else
	{
		firstprotein = 1;
		lastprotein = proteinData->noOfProteins+1;
	}
	int noOfFractions = max(commands->frax.size(),1);
	if (commands->pooled) noOfFractions = 1;

	if (noOfFractions > 1)
	{
		// Draw fractions title
		LoadString(hInst,IDS_FRACTIONS,label, 199);
		create_text_at_point( hdc, label,
			                  15.0+(30.0*noOfFractions/2.0), -30.0,
							  12,
							  RGB(0,0,0),
							  0.0,
							  FALSE,
							  t_centre);
	}

	WCHAR numbers[10];

	for (int j=0; j<noOfFractions; j++)
	{
		if (!commands->pooled)
		{
			// Draw the fraction numbers
			_itow_s(commands->frax[j],numbers,10);
			double xpos = 16.0+(30.0*(j+1));
			create_text_at_point(hdc,numbers,
								 xpos, -8.0,
								 10,
								 RGB(0,0,0),
								 0.0,
								 FALSE,
								 t_centre);
		}
		for (int i = firstprotein; i<lastprotein; i++)
		{
			if (commands->pooled)  // show the total mixture
			{
				amount = proteinData->getCurrentAmount(i);
				total = proteinData->getCurrentAmount(0);
			}
			else  // show what is in the selected fraction
			{
				int fraction = commands->frax[j];

				amount = separation->GetPlotElement(2*fraction, i) +
						 separation->GetPlotElement(2*fraction-1, i);

				total = separation->GetPlotElement(2*fraction, 0) +
						separation->GetPlotElement(2*fraction-1, 0);
			}
			if (amount > sensitivityCutoff)
			{
				if (proteinData->getSubunit1(i) > 0.0)
				Band (hdc,
					  j+1,
					  proteinData->getSubunit1(i),
					  (double)(amount/total*proteinData->getSubunit1(i)*proteinData->getNoOfSub1(i)/aggregate[i]));

			if ((proteinData->getSubunit2(i) > 0.0) && !showBlot)
				Band (hdc,
					  j+1,
					  proteinData->getSubunit2(i),
					  (double)(amount/total*proteinData->getSubunit2(i)*proteinData->getNoOfSub2(i)/aggregate[i]));

			if ((proteinData->getSubunit3(i) > 0.0) && !showBlot)
				Band (hdc,
					  j+1,
					  proteinData->getSubunit3(i),
					  (double)(amount/total*proteinData->getSubunit3(i)*proteinData->getNoOfSub3(i)/aggregate[i]));


			}

		}

	}

	free(aggregate);
}

void showSpots( HDC hdc)
{

	double sensitivityCutoff = 1.5; //Deacrease this to make staining more sensitive

	double *aggregate = (double*)malloc(sizeof(double)*(proteinData->noOfProteins+1));
	aggregate[0] = 0.0;

	for (int i=1; i<=proteinData->noOfProteins; i++)
	{
		// This is not the blot spot you are looking for. Move on.
		if (showBlot && (i != proteinData->enzyme)) continue;

		aggregate[i] = proteinData->getNoOfSub1(i) * proteinData->getSubunit1(i)
					 + proteinData->getNoOfSub2(i) * proteinData->getSubunit2(i)
					 + proteinData->getNoOfSub3(i) * proteinData->getSubunit3(i);

		double amount;
		double total;
		if (commands->pooled)  // show the total mixture
		{
			amount = proteinData->getCurrentAmount(i);
			total = proteinData->getCurrentAmount(0);
		}
		else  // show what is in the selected fraction
		{
			int fraction = commands->frax[0];

			amount = separation->GetPlotElement(2*fraction, i) +
					 separation->GetPlotElement(2*fraction-1, i);

			total = separation->GetPlotElement(2*fraction, 0) +
					separation->GetPlotElement(2*fraction-1, 0);
		}


		if ((amount > sensitivityCutoff) &&
			(proteinData->getIsoPoint(i) <= 8.90) &&
			(proteinData->getIsoPoint(i) >= 4.10))
		{
			if (proteinData->getSubunit1(i) > 0.0)
				Spot (hdc,
					  proteinData->getIsoPoint(i),
					  proteinData->getSubunit1(i),
					  (double)(amount/total*proteinData->getSubunit1(i)*proteinData->getNoOfSub1(i)/aggregate[i]));

			if ((proteinData->getSubunit2(i) > 0.0) && !showBlot)
				Spot (hdc,
					  proteinData->getIsoPoint(i),
					  proteinData->getSubunit2(i),
					  (double)(amount/total*proteinData->getSubunit2(i)*proteinData->getNoOfSub2(i)/aggregate[i]));

			if ((proteinData->getSubunit3(i) > 0.0) && !showBlot)
				Spot (hdc,
					  proteinData->getIsoPoint(i),
					  proteinData->getSubunit3(i),
					  (double)(amount/total*proteinData->getSubunit3(i)*proteinData->getNoOfSub3(i)/aggregate[i]));

		}
	}
	free(aggregate);
}

void Run2DGel(HDC hdc)
{
	Markers(hdc);
	showSpots(hdc);
}

void Run1DGel(HDC hdc)
{
	Markers(hdc);
	showBands(hdc);
}

void PaintGel(HWND hWnd)
{
	PAINTSTRUCT ps;
    HDC hdc = BeginPaint(hWnd, &ps);

	xscale = (double)clientWidth/640.0;
	yscale = (double)clientHeight/480.0;

	xOffset = 100.0;
	yOffset = 60.0;
	labelXOffset = 20.0;

	if (twoDGel) Run2DGel(hdc);
	else Run1DGel(hdc);

	
	EndPaint(hWnd, &ps);
}
