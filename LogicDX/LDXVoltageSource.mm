//
//  LDXVoltageSource.m
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import "LDXVoltageSource.h"

@implementation LDXVoltageSource

@synthesize voltage;
@synthesize internalResistance;

- (void) drawElement
{
	[ [ NSColor blackColor ] set ];
	
	NSPoint start = [ self.gridView convertGridPoint:self.startPoint ];
	NSPoint end = [ self.gridView convertGridPoint:LDXMakeGridPoint(self.startPoint.x + self.size.width, self.startPoint.y + self.size.height) ];
	
	NSPoint vector = NSMakePoint(end.x - start.x, end.y - start.y);
	
	NSBezierPath* path = [ NSBezierPath bezierPathWithOvalInRect:NSMakeRect(start.x - vector.x, start.y - vector.y, vector.x * 2, vector.y * 2) ];
	
	[ path setLineWidth:LINE_WIDTH ];
	[ path setLineCapStyle:NSRoundLineCapStyle ];
	[ path stroke ];
	
	// Draw +
	[ [ NSBezierPath bezierPathWithRect:NSMakeRect(start.x - vector.x / 40, start.y - vector.y * 5 / 8, vector.x / 20, vector.y / 2) ] fill ];
	[ [ NSBezierPath bezierPathWithRect:NSMakeRect(start.x - vector.x / 4, start.y - vector.y * (3 / 8.0 + 1 / 40.0), vector.x / 2, vector.y / 20) ] fill ];
	
	// Draw -
	[ [ NSBezierPath bezierPathWithRect:NSMakeRect(start.x - vector.x / 4, start.y + vector.y * (3 / 8.0 - 1 / 40.0), vector.x / 2, vector.y / 20) ] fill ];
}

@end
