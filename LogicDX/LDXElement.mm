//
//  LDXElement.m
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import "LDXElement.h"

@implementation LDXElement

@synthesize startPoint;
@synthesize size;
@synthesize gridView;
@synthesize selected;

- (void) drawElement
{
}

- (LDXPolygon) boundingBox
{
	const float extra = 10;
	NSPoint start = [ self.gridView convertGridPoint:startPoint ];
	NSPoint end = [ self.gridView convertGridPoint:startPoint + (LDXGridPoint)size ];
	NSSize realSize = NSMakeSize(end.x - start.x, end.y - start.y);
	if (realSize.width < 0)
	{
		start.x += realSize.width;
		realSize.width *= -1;
	}
	if (realSize.height < 0)
	{
		start.y += realSize.height;
		realSize.height *= -1;
	}
	
	return LDXMakePolygon(NSMakePoint(start.x - extra, start.y - extra), NSMakePoint(start.x - extra, start.y + realSize.height + extra), NSMakePoint(start.x + realSize.width + extra, start.y + realSize.height + extra), NSMakePoint(start.x + realSize.width + extra, start.y - extra));
}

- (void) drawBoundingBox
{
	[ [ NSColor blackColor ] set ];
	NSBezierPath* path = [ NSBezierPath bezierPath ];
	
	LDXPolygon rect = [ self boundingBox ];
	[ path moveToPoint:rect.points[0] ];
	for (int z = 0; z < 4; z++)
		[ path lineToPoint:rect.points[(z + 1) % 4] ];
	[ path stroke ];
}

- (void) setEndPoint:(LDXGridPoint) endPoint
{
	size = LDXMakeGridSize(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
}

- (LDXGridPoint) endPoint
{
	return startPoint + (LDXGridPoint)size;
}

@end
