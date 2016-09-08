//
//  LDXGridView.m
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import "LDXGridView.h"
#import "LDXElements.h"

#define LDXGridSelect		0
#define LDXGridElement		1
#define LDXGridMove			2

LDXGridPoint LDXMakeGridPoint(long x, long y)
{
	LDXGridPoint ret;
	ret.x = x;
	ret.y = y;
	return ret;
}

LDXGridSize LDXMakeGridSize(long width, long height)
{
	LDXGridSize ret;
	ret.width = width;
	ret.height = height;
	return ret;
}

LDXGridRect LDXMakeGridRect(long x, long y, long width, long height)
{
	LDXGridRect ret;
	ret.x = x;
	ret.y = y;
	ret.width = width;
	ret.height = height;
	return ret;
}

LDXPolygon LDXMakePolygon(NSPoint p1, NSPoint p2, NSPoint p3, NSPoint p4)
{
	LDXPolygon ret;
	ret.points[0] = p1;
	ret.points[1] = p2;
	ret.points[2] = p3;
	ret.points[3] = p4;
	return ret;
}

@implementation LDXGridView

@synthesize gridBounds;
@synthesize gridSpacing;
@synthesize gridOffset;
@synthesize gridSelection;

- (id) init
{
	if ((self = [ super init ]))
	{
		elements = [ [ NSMutableArray alloc ] init ];
		[ self setGridBounds:NSMakeRect(-10, -10, 20, 20) ];
		addElementClass = [ LDXWire class ];
	}
	return self;
}

- (id) initWithCoder:(NSCoder *)coder
{
	if ((self = [ super initWithCoder:coder ]))
	{
		elements = [ [ NSMutableArray alloc ] init ];
		[ self setGridBounds:NSMakeRect(-10, -10, 20, 20) ];
		addElementClass = [ LDXWire class ];
	}
	return self;
}

- (id) initWithFrame:(NSRect)frameRect
{
	if ((self = [ super initWithFrame:frameRect ]))
	{
		elements = [ [ NSMutableArray alloc ] init ];
		[ self setGridBounds:NSMakeRect(-10, -10, 20, 20) ];
		addElementClass = [ LDXWire class ];
		
	}
	return self;
}

- (BOOL) acceptsFirstResponder
{
	return YES;
}

- (BOOL) becomeFirstResponder
{
	return YES;
}

- (void) setGridBounds:(NSRect)bounds
{
	gridBounds = bounds;
	float ratio = self.frame.size.width / self.frame.size.height;
	gridSpacing = NSMakeSize(self.frame.size.width / gridBounds.size.width, ratio * self.frame.size.height / gridBounds.size.height);
}

float MDTweenEaseInOutQuadratic(float time)
{
	if (time < 0.5)
		return 2 * time * time;
	return (-2 * time * time) + (4 * time) - 1;
}

- (void) updateGridBounds:(NSTimer*)timer
{
	animationTimer[0] += 1 / 60.0;
	float time = MDTweenEaseInOutQuadratic(animationTimer[0] / 0.3);
	if (animationTimer[0] >= 0.3)
	{
		[ self setGridBounds:targetGridBounds ];
		[ timer invalidate ];
	}
	else
	{
		[ self setGridBounds:NSMakeRect(originalGridBounds.origin.x + (time * (targetGridBounds.origin.x - originalGridBounds.origin.x)), originalGridBounds.origin.y + (time * (targetGridBounds.origin.y - originalGridBounds.origin.y)), originalGridBounds.size.width + (time * (targetGridBounds.size.width - originalGridBounds.size.width)), originalGridBounds.size.height + (time * (targetGridBounds.size.height - originalGridBounds.size.height))) ];
	}
	[ self setNeedsDisplay:YES ];
}

- (void) animateGridBounds:(NSRect)targetBounds
{
	animationTimer[0] = 0;
	originalGridBounds = gridBounds;
	targetGridBounds = targetBounds;
	[ NSTimer scheduledTimerWithTimeInterval:1 / 60.0 target:self selector:@selector(updateGridBounds:) userInfo:nil repeats:YES ];
}

- (void) updateGridOffset:(NSTimer*)timer
{
	animationTimer[1] += 1 / 60.0;
	float time = MDTweenEaseInOutQuadratic(animationTimer[1] / 0.3);
	if (animationTimer[1] >= 0.3)
	{
		gridOffset = targetGridOffset;
		[ timer invalidate ];
	}
	else
	{
		gridOffset.x = originalGridOffset.x + (time * (targetGridOffset.x - originalGridOffset.x));
		gridOffset.y = originalGridOffset.y + (time * (targetGridOffset.y - originalGridOffset.y));
	}
	[ self setNeedsDisplay:YES ];
}

- (void) animateGridOffset:(NSPoint)targetOffset
{
	animationTimer[1] = 0;
	originalGridOffset = gridOffset;
	targetGridOffset = targetOffset;
	[ NSTimer scheduledTimerWithTimeInterval:1 / 60.0 target:self selector:@selector(updateGridOffset:) userInfo:nil repeats:YES ];
}

- (void) zoomIn
{
	float gridRatio = 0.5;
	NSRect rect = NSMakeRect(gridRatio * gridBounds.origin.x, gridRatio * gridBounds.origin.y, gridRatio * gridBounds.size.width, gridRatio * gridBounds.size.height);
	[ self animateGridBounds:rect ];
	[ self animateGridOffset:NSMakePoint(gridOffset.x / gridRatio, gridOffset.y / gridRatio) ];
}

- (void) zoomOut
{
	float gridRatio = 2;
	NSRect rect = NSMakeRect(gridRatio * gridBounds.origin.x, gridRatio * gridBounds.origin.y, gridRatio * gridBounds.size.width, gridRatio * gridBounds.size.height);
	[ self animateGridBounds:rect ];
	[ self animateGridOffset:NSMakePoint(gridOffset.x / gridRatio, gridOffset.y / gridRatio) ];
}

- (void)drawRect:(NSRect)dirtyRect {
    [ super drawRect:dirtyRect ];
	
	NSRect bounds = self.bounds;
	[ [ NSColor whiteColor ] set ];
	NSRectFill(bounds);
	
	// Draw grid lines
#define LINEWIDTH	1.0
	NSPoint start = [ self convertGridPoint:[ self convertRealPoint:NSMakePoint(bounds.origin.x - gridSpacing.width - gridOffset.x, bounds.origin.y - gridSpacing.height - gridOffset.y) ] ];
	NSPoint end = [ self convertGridPoint:[ self convertRealPoint:NSMakePoint(bounds.origin.x + bounds.size.width + gridSpacing.width - gridOffset.x, bounds.origin.y + bounds.size.height + gridSpacing.height - gridOffset.y) ] ];
	[ [ NSColor colorWithCalibratedRed:0.0 green:204.0 / 255.0 blue:1.0 alpha:1.0 ] set ];
	for (double x = start.x; x <= end.x; x += gridSpacing.width)
		[ [ NSBezierPath bezierPathWithRect:NSMakeRect(x - LINEWIDTH / 2 + gridOffset.x, 0, LINEWIDTH, bounds.size.height) ] fill ];
	for (double y = start.y; y <= end.y; y += gridSpacing.height)
		[ [ NSBezierPath bezierPathWithRect:NSMakeRect(0, y - LINEWIDTH / 2 + gridOffset.y, bounds.size.width, LINEWIDTH) ] fill ];
	
	NSAffineTransform* trans = [ NSAffineTransform transform ];
	[ trans translateXBy:gridOffset.x yBy:gridOffset.y ];
	[ trans concat ];
		
	// Draw all the elements
	for (id element in elements)
		[ element drawElement ];
	for (id element in elements)
	{
		if ([ element selected ])
			[ element drawBoundingBox ];
	}
	
	// Draw tracking rectangle
	if (gridSelection == 0 && isTracking)
	{
		NSBezierPath* tPath = [ NSBezierPath bezierPathWithRect:trackingRect ];
		[ [ NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.7 alpha:0.5 ] set ];
		[ tPath fill ];
		[ [ NSColor lightGrayColor ] set ];
		[ tPath stroke ];
	}
	
	// Draw add element circle
	if (addElementMode == 1)
	{
		[ addElement drawElement ];
		NSPoint p = [ self convertGridPoint:[ addElement endPoint ] ];
		const float radius = 5;
		[ [ NSColor blackColor ] set ];
		[ [ NSBezierPath bezierPathWithOvalInRect:NSMakeRect(p.x - radius, p.y - radius, radius * 2, radius * 2) ] stroke ];
	}
}

- (NSPoint) convertGridPoint:(LDXGridPoint)point
{
	NSRect frame = self.frame;
	double perWidth = (point.x - gridBounds.origin.x) / ((double)(gridBounds.size.width));
	double perHeight = (point.y - gridBounds.origin.y) / ((double)(gridBounds.size.height));
	float ratio = self.frame.size.width / self.frame.size.height;
	return NSMakePoint(frame.origin.x + frame.size.width * perWidth - (LINE_WIDTH / 2.0), frame.origin.y + frame.size.height * perHeight * ratio - (LINE_WIDTH / 2.0));
}

- (LDXGridPoint) convertRealPoint:(NSPoint)point
{
	long x = (int)(point.x / gridSpacing.width);
	x += round((point.x - x * gridSpacing.width) / gridSpacing.width);
	long y = (int)(point.y / gridSpacing.height);
	y += round((point.y - y * gridSpacing.height) / gridSpacing.height);
	return LDXMakeGridPoint(x + gridBounds.origin.x, y + gridBounds.origin.y);
}

- (void) mouseDown:(NSEvent *)theEvent
{
	NSPoint p = [ self convertPoint:[ theEvent locationInWindow] fromView:[ [ self window ] contentView ] ];
	p.x -= gridOffset.x;
	p.y -= gridOffset.y;
	if (gridSelection == LDXGridSelect)
	{
		trackingRect = NSMakeRect(p.x, p.y, 0, 0);
	}
	else if (gridSelection == LDXGridElement)
	{
		if (addElementMode == 0)
		{
			addElement = [ [ addElementClass alloc ] init ];
			[ addElement setSelected:YES ];
			[ addElement setStartPoint:[ self convertRealPoint:p ] ];
			[ addElement setEndPoint:[ addElement startPoint ] ];
			[ addElement setGridView:self ];
			[ self setNeedsDisplay:YES ];
			addElementMode = 1;
		}
		else
		{
			[ elements addObject:addElement ];
			addElement = nil;
			addElementMode = 0;
			[ self setNeedsDisplay:YES ];
		}
	}
	else if (gridSelection == LDXGridMove)
	{
		[ [ NSCursor closedHandCursor ] set ];
	}
}

- (void) mouseDragged:(NSEvent*)theEvent
{
	NSPoint p = [ self convertPoint:[ theEvent locationInWindow] fromView:[ [ self window ] contentView ] ];
	p.x -= gridOffset.x;
	p.y -= gridOffset.y;
	if (gridSelection == LDXGridSelect)
	{
		isTracking = TRUE;
		trackingRect = NSMakeRect(trackingRect.origin.x, trackingRect.origin.y, p.x - trackingRect.origin.x, p.y - trackingRect.origin.y);
		[ self setNeedsDisplay:YES ];
	}
	else if (gridSelection == LDXGridElement)
	{
		if (addElementMode == 1)
		{
			[ self mouseMoved:theEvent ];
		}
	}
	else if (gridSelection == LDXGridMove)
	{
		gridOffset.x += [ theEvent deltaX ];
		gridOffset.y -= [ theEvent deltaY ];
		[ self setNeedsDisplay:YES ];
	}
}

- (void) mouseUp:(NSEvent *)theEvent
{
	if (gridSelection == LDXGridSelect)
	{
		isTracking = FALSE;
		[ self setNeedsDisplay:YES ];
	}
	else if (gridSelection == LDXGridElement)
	{
		if (addElementMode == 1)
		{
			if ([ (LDXElement*)addElement size ].width != 0 && [ (LDXElement*)addElement size ].height != 0)
			{
				[ elements addObject:addElement ];
				addElement = nil;
				addElementMode = 0;
				[ self setNeedsDisplay:YES ];
			}
		}
	}
	else if (gridSelection == LDXGridMove)
	{
		[ [ NSCursor openHandCursor ] set ];
	}
}

- (void) mouseMoved:(NSEvent *)theEvent
{
	NSPoint p = [ self convertPoint:[ theEvent locationInWindow] fromView:[ [ self window ] contentView ] ];
	p.x -= gridOffset.x;
	p.y -= gridOffset.y;
	if (gridSelection == 1)
	{
		if (addElementMode == LDXGridElement)
		{
			[ addElement setEndPoint:[ self convertRealPoint:p ] ];
			
			[ self setNeedsDisplay:YES ];
		}
	}
}

- (void) keyDown:(NSEvent *)theEvent
{
	unichar cmd = [ [ theEvent characters ] characterAtIndex:0 ];
	
	if (gridSelection == LDXGridElement)
	{
		if (cmd == '1')
		{
			addElementClass = [ LDXWire class ];
		}
		else if (cmd == '2')
		{
			addElementClass = [ LDXResistor class ];
		}
		else if (cmd == '3')
		{
			addElementClass = [ LDXVoltageSource class ];
		}
		else if (cmd == 0x1B) // Escape
		{
			addElement = nil;
			addElementMode = 0;
			[ self setNeedsDisplay:YES ];
		}
	}
}

@end
