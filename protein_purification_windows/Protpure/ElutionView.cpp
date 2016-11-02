#include "StdAfx.h"
#include "ElutionView.h"
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

extern double xscale;
extern double yscale;
extern double xOffset;
extern double yOffset;
extern double labelXOffset;

extern int clientWidth;
extern int clientHeight;

void create_polyline(HDC hdc, std::vector<FPOINT> coords, int colour)
{
	SaveDC( hdc);
	HRGN hRgn = CreateRectRgn((int)xScale(0.0),(int)yScale(0.0),(int)xScale(500.0),(int)yScale(320.0));
	HPEN hPen = CreatePen(PS_SOLID, 2, colour);
	SelectObject(hdc, hPen);
	SelectClipRgn(hdc, hRgn);
	MoveToEx(hdc, (ULONG)xScale(coords[0].x), (ULONG)yScale(coords[0].y), NULL);

	for (int i=1; i<coords.size(); i++)
		LineTo(hdc, (ULONG)xScale(coords[i].x)+1, (ULONG)yScale(coords[i].y));

	DeleteObject(hPen);
	DeleteObject(hRgn);
	RestoreDC(hdc, -1);
}

void shade_selection(HDC hdc, std::vector<FPOINT> coords)
{
	POINT points[255];
	int size = coords.size();
	for (int i=0; i<size; i++)
	{
		points[i].x = (ULONG)xScale(coords[i].x);
		points[i].y = (ULONG)yScale(coords[i].y);
	}
	SaveDC( hdc);
	HRGN hRgn = CreateRectRgn((int)xScale(0.0),(int)yScale(0.0),(int)xScale(500.0),(int)yScale(320.0));
	HPEN hPen = CreatePen(PS_SOLID, 2, RGB(0x56,0x56,0x56));
	HBRUSH hBrush = CreateHatchBrush(HS_DIAGCROSS, RGB(0x56,0x56,0x56));
	SelectObject(hdc, hPen);
	SelectObject(hdc, hBrush);
	SelectClipRgn(hdc, hRgn);

	SetBkMode(hdc, TRANSPARENT);
	SetPolyFillMode( hdc, WINDING );

	Polygon( hdc, points, size);

	DeleteObject(hBrush);
	DeleteObject(hPen);
	DeleteObject(hRgn);
	RestoreDC(hdc, -1);
}

void drawFrame(HDC hdc, BOOL assayed, BOOL gradient)
{
	// Add the title
	WCHAR onString[50];
	WCHAR buffer[300];

	LoadString(hInst, IDS_ON, onString, 49);
	swprintf(buffer,299,onString,separation->sepString, separation->mediumString);

	create_text_at_point(hdc,
		buffer,
		250, -30,
		15,
		RGB(0,0,0),
		0.0,
		TRUE,
		t_centre);
	// Draw the frame
	create_line(hdc, 0.0, 324.0, 499.0, 324.0, RGB(64,64,64));
	create_line(hdc, 499.0, 324.0, 499.0, 0.0, RGB(64,64,64));
	create_line(hdc, 499.0, 0.0, 0.0, 0.0, RGB(255,255,255));
	create_line(hdc, 0.0, 0.0, 0.0, 324.0, RGB(255,255,255));

	// Add the fractions position marks
	for (int i=1; i<13; i++)
	{
		//create_line(hdc, -4.0+i*40.0, 324.0, -4.0+i*40.0, 319.0, RGB(255,255,255));
		create_line(hdc, -3.0+i*40.0, 324.0, -3.0+i*40.0, 319.0, RGB(64,64,64));
		//create_line(hdc, -24.0+i*40.0, 324.0, -24.0+i*40.0, 322.0, RGB(255,255,255));
		create_line(hdc, -23.0+i*40.0, 324.0, -23.0+i*40.0, 322.0, RGB(64,64,64));
	}

	// Draw the Absorbance axis tick marks

	create_line(hdc, 1.0, 316.0, 5.0, 316.0, RGB(64,64,64));
	create_line(hdc, 1.0, 162.0, 5.0, 162.0, RGB(64,64,64));
	create_line(hdc, 1.0, 8.0, 5.0, 8.0, RGB(64,64,64));

	// Draw the Absorbance title

	LoadString(hInst, IDS_ABSORBANCE_AT_280_NM,buffer, 250);
	create_text_at_point(hdc,
		buffer,
		-44,162,
		12,
		RGB(0,0,255),
		90.0,
		FALSE,
		t_centre);

	// Add the Absorbance labels

	swprintf(buffer,250,L"%.1f",commands->scale*4.0);
	create_text_at_point(hdc,
		buffer,
		-8.0, 12.0,
		10,
		RGB(0,0,0),
		0.0,
		FALSE,
		t_right);

	swprintf(buffer,250,L"%.1f",commands->scale*2.0);
	create_text_at_point(hdc,
		buffer,
		-8.0, 166.0,
		10,
		RGB(0,0,0),
		0.0,
		FALSE,
		t_right);

	swprintf(buffer,250,L"%d",0);
	create_text_at_point(hdc,
		buffer,
		-8.0, 320.0,
		10,
		RGB(0,0,0),
		0.0,
		FALSE,
		t_right);

	// Add the fraction numbers
	for(int i=1; i<13; i++)
	{
		double xpos = labelXOffset+i*40.0;
		swprintf(buffer,250,L"%d",i*10);
		create_text_at_point(hdc,
			buffer,
			xpos+20, 336.0,
			10,
			RGB(0,0,0),
			0.0,
			FALSE,
			t_centre);
	}

	// Add the fraction label
	LoadString( hInst, IDS_FRACTION_NUMBER, buffer, 250);
	create_text_at_point(hdc,
		buffer,
		250, 360,
		12,
		RGB(0,0,0),
		0.0,
		FALSE,
		t_centre);

	if (assayed)
	{
		LoadString(hInst, IDS_ENZYME_LABEL, buffer, 250);
		create_text_at_point(hdc,
			buffer,
			534, 162,
			12,
			RGB(255,0,0),
			-90.0,
			FALSE,
			t_centre);

		// Add the Enzyme labels
		swprintf(buffer,250,L"%d",0);
		create_text_at_point(hdc,
			buffer,
			508, 320,
			10,
			RGB(0,0,0),
			0.0,
			FALSE,
			t_left);

		swprintf(buffer,250,L"%d",(int)(proteinData->getCurrentActivity(proteinData->enzyme)*800.0*commands->scale/3.0));
		create_text_at_point(hdc,
			buffer,
			508, 12,
			10,
			RGB(0,0,0),
			0.0,
			FALSE,
			t_left);
	}
	if (gradient)
	{
		if (commands->startGrad > commands->endGrad)
		{
			create_line(hdc, 124.0, 8.0, 499.0, 316.0, RGB(255,0,255));
			create_line(hdc, 0.0, 8.0, 124.0, 8.0, RGB(255,0,255));
		}
		else
		{
			create_line(hdc, 124.0, 316.0, 499.0, 8.0, RGB(255,0,255));
			create_line(hdc, 0.0, 316.0, 124.0, 316.0, RGB(255,0,255));
		}

		if (!assayed)
		{
			WCHAR startString[10];
			WCHAR endString[10];

			if (commands->startGrad < 0.05) swprintf(startString,9,L"%d",0);
			else swprintf(startString,9,L"%.1f",commands->startGrad);

			if (commands->endGrad < 0.05) swprintf(endString,9,L"%d",0);
			else swprintf(endString,9,L"%.1f",commands->endGrad);

			if (commands->gradientIsSalt)
			{
				// Add the gradient title
				LoadString(hInst, IDS_SALT_LABEL, buffer, 250);        
				create_text_at_point(hdc,
					buffer,
					534, 162,
					12,
					RGB(255,0,255),
					-90.0,
					FALSE,
					t_centre);

				if (commands->endGrad > commands->startGrad)
				{
					// Add the gradient labels
					create_text_at_point(hdc,
						startString,
						508, 320,
						10,
						RGB(0,0,0),
						0.0,
						FALSE,
						t_left);

					create_text_at_point(hdc,
						endString,
						508, 12,
						10,
						RGB(0,0,0),
						0.0,
						FALSE,
						t_left);

				}
				else
				{
					create_text_at_point(hdc,
						endString,
						508, 320,
						10,
						RGB(0,0,0),
						0.0,
						FALSE,
						t_left);

					create_text_at_point(hdc,
						startString,
						508, 12,
						10,
						RGB(0,0,0),
						0.0,
						FALSE,
						t_left);
				}
			}
			else
			{
				// Add the gradient title
				LoadString(hInst, IDS_PH_LABEL, buffer, 250);        
				create_text_at_point(hdc,
					buffer,
					534, 162,
					12,
					RGB(255,0,255),
					-90.0,
					FALSE,
					t_centre);

				if (commands->endGrad > commands->startGrad)
				{
					// Add the gradient labels
					create_text_at_point(hdc,
						startString,
						508, 320,
						10,
						RGB(0,0,0),
						0.0,
						FALSE,
						t_left);

					create_text_at_point(hdc,
						endString,
						508, 12,
						10,
						RGB(0,0,0),
						0.0,
						FALSE,
						t_left);

				}
				else
				{
					create_text_at_point(hdc,
						endString,
						508, 320,
						10,
						RGB(0,0,0),
						0.0,
						FALSE,
						t_left);

					create_text_at_point(hdc,
						startString,
						508, 12,
						10,
						RGB(0,0,0),
						0.0,
						FALSE,
						t_left);
				}
			}
		}
	}
	if (commands->sepType == Affinity)  // Footer for Affinity chromatography
	{
		LoadString(hInst, IDS_AFFINITY_ELUTION_LABEL, buffer, 250);
		create_text_at_point(hdc,
			buffer,
			250, 380,
			10,
			RGB(0,0,0),
			0.0,
			FALSE,
			t_centre);

	}    

}


void drawElution( HDC hdc, BOOL assayed, BOOL gradient, BOOL pooled)
{
	drawFrame( hdc, assayed, gradient);

	std::vector<FPOINT> blue_coords;

	FPOINT point;

	double x;
	double y;

	for (int i=1; i<251; i++)
	{
		x = 2.0*((double)i - 1.0);
		y = 316.0 - separation->GetPlotElement(i,0)/commands->scale; 
		point.x = x; point.y = y;
		blue_coords.push_back(point);
	}

	create_polyline(hdc, blue_coords, RGB(0,0,255) );

	if (assayed)
    {
            
		std::vector<FPOINT> red_coords;
            
		x = 1.0;
        double origin = 315.0;
        y = origin;
            
		for (int i=1; i<251; i++)
        {
                
			double oldx = x;
            double oldy = y;
                
            x = 2.0*((double)i - 1.0);
            y = 316.0 - separation->GetPlotElement(i, proteinData->enzyme)*4.0*(double)(proteinData->getCurrentActivity(proteinData->enzyme))/commands->scale;
                
            if ((oldy==origin) && (y < origin)) 
			{
				point.x = oldx;
                point.y = oldy;
                red_coords.push_back(point);
            }
            if ((y < origin) || (oldy < origin)) 
			{
                    
                point.x = x;
                point.y = y;
                red_coords.push_back(point);
            }
                
		}
            
		if (red_coords.size() > 0 )
        {
                create_polyline(hdc, red_coords, RGB(255,0,0));
        }
	}


	if (pooled) 
	{           
		std::vector<FPOINT> black_coords;        
            
        int start_pool = 2 * commands->startOfPool;
        int end_pool = 2 * commands->endOfPool;
            
        float origin = 316.0;
            
        point.x = 2.0*((double)start_pool - 1.0);
        point.y = origin;
            
		black_coords.push_back(point);
            
		for (int i=start_pool; i<= end_pool; i++) 
		{
			x = 2.0*((double)i - 1.0);
			point.x = x;
			point.y = 316.0 - separation->GetPlotElement(i, 0)/commands->scale;
                
            black_coords.push_back(point);
		}
        
		point.x = x;
		point.y = origin;
		black_coords.push_back(point);
            
            
        point.x = 2.0*((double)start_pool - 1.0);
        point.y = origin;
        black_coords.push_back(point);  
            
        shade_selection(hdc, black_coords);
    }

}

void PaintElution(HWND hWnd)
{
	PAINTSTRUCT ps;
	HDC hdc = BeginPaint(hWnd, &ps);

	xscale = (double)clientWidth/640.0;
	yscale = (double)clientHeight/480.0;

	xOffset = 60.0;
	yOffset = 60.0;
	labelXOffset = -23.0;
/*
commands->assayed=TRUE;
commands->pooled=TRUE;
commands->hasGradient=TRUE;
commands->startOfPool = 50;
commands->endOfPool = 70;
*/
	drawElution( hdc, commands->assayed, commands->hasGradient, commands->pooled);


	EndPaint(hWnd, &ps);
}