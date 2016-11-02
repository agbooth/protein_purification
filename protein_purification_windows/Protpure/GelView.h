#pragma once

void PaintGel(HWND);
void create_text_at_point(HDC hdc, LPWSTR text, double X, double Y, double size, int colour, double angle, BOOL italic, int alignment);
void create_line(HDC hdc, double X1, double Y1, double X2, double Y2, int colour);
double xScale(double);
double yScale(double);

typedef struct fPOINT
{
	double x;
	double y;

} FPOINT;

