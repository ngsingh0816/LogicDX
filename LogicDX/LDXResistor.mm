//
//  LDXResistor.m
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import "LDXResistor.h"

@implementation LDXResistor

@synthesize resistance;

- (void) drawElement
{
	[ [ NSColor blackColor ] set ];
	
	NSPoint start = [ self.gridView convertGridPoint:self.startPoint ];
	NSPoint end = [ self.gridView convertGridPoint:LDXMakeGridPoint(self.startPoint.x + self.size.width, self.startPoint.y + self.size.height) ];
	
	NSSize spacing = self.gridView.gridSpacing;
	
	NSPoint vector = NSMakePoint(end.x - start.x, end.y - start.y);
	double len = sqrt(vector.x * vector.x + vector.y * vector.y);
	NSPoint perp = NSMakePoint(-vector.y / len, vector.x / len);
	
	NSBezierPath* path = [ NSBezierPath bezierPath ];
	[ path moveToPoint:start ];
	
	double gridLen = sqrt((self.endPoint.x - self.startPoint.x) * (self.endPoint.x - self.startPoint.x) + (self.endPoint.y - self.startPoint.y) * (self.endPoint.y - self.startPoint.y)) * 2;
	for (int z = 1; z < gridLen; z++)
	{
		NSPoint next = NSMakePoint(start.x + vector.x * (z / gridLen), start.y + vector.y * (z / gridLen));
		int mult = ((z % 2) == 0) ? 1 : -1;
		if (z == 1 || (z + 1) >= gridLen)
			mult = 0;
		next.x += perp.x * spacing.width / 2 * mult;
		next.y += perp.y * spacing.height / 2 * mult;
		[ path lineToPoint:next ];
	}
	
	[ path lineToPoint:end ];
	
	[ path setLineWidth:LINE_WIDTH ];
	[ path setLineCapStyle:NSRoundLineCapStyle ];
	[ path stroke ];
}

- (LDXPolygon) boundingBox
{
	const float extra = (self.gridView.gridSpacing.width > self.gridView.gridSpacing.height) ? (self.gridView.gridSpacing.width / 2) : (self.gridView.gridSpacing.height / 2) + 10;
	
	NSPoint start = [ self.gridView convertGridPoint:self.startPoint ];
	NSPoint end = [ self.gridView convertGridPoint:self.startPoint + (LDXGridPoint)self.size ];
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

@end
