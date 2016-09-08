//
//  LDXGridView.h
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct LDXGridPoint
{
	long x;
	long y;
	friend LDXGridPoint operator+ (LDXGridPoint point1, LDXGridPoint point2)
	{
		LDXGridPoint ret;
		ret.x = point1.x + point2.x;
		ret.y = point1.y + point2.y;
		return ret;
	};
};

LDXGridPoint LDXMakeGridPoint(long x, long y);

struct LDXGridSize
{
	long width;
	long height;
	
	operator LDXGridPoint()
	{
		return LDXMakeGridPoint(this->width, this->height);
	}
};

LDXGridSize LDXMakeGridSize(long width, long height);

struct LDXGridRect
{
	long x;
	long y;
	long width;
	long height;
};

LDXGridRect LDXMakeGridRect(long x, long y, long width, long height);

struct LDXPolygon
{
	NSPoint points[4];
};

// Counterclockwise
LDXPolygon LDXMakePolygon(NSPoint p1, NSPoint p2, NSPoint p3, NSPoint p4);

@interface LDXGridView : NSView
{
	NSMutableArray* elements;
	
	float animationTimer[2];
	NSRect targetGridBounds;
	NSRect originalGridBounds;
	NSPoint targetGridOffset;
	NSPoint originalGridOffset;
	
	NSRect trackingRect;
	BOOL isTracking;
	
	int addElementMode;
	Class addElementClass;
	id addElement;
}

@property (assign, nonatomic) NSRect gridBounds;
@property (readonly) NSSize gridSpacing;
@property (assign) NSPoint gridOffset;
@property (assign) int gridSelection;

- (NSPoint) convertGridPoint:(LDXGridPoint)point;
- (LDXGridPoint) convertRealPoint:(NSPoint)point;

- (void) zoomIn;
- (void) zoomOut;

@end
