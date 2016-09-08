//
//  LDXWire.m
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import "LDXWire.h"
#import <Cocoa/Cocoa.h>

@implementation LDXWire

@synthesize resistivity;

- (double) length
{
	long width = self.size.width;
	long height = self.size.height;
	return sqrt(width * width + height * height);
}

- (double) resistance
{
	return self.length * resistivity;
}

- (void) drawElement
{
	[ [ NSColor blackColor ] set ];
	
	NSPoint start = [ self.gridView convertGridPoint:self.startPoint ];
	NSPoint end = [ self.gridView convertGridPoint:LDXMakeGridPoint(self.startPoint.x + self.size.width, self.startPoint.y + self.size.height) ];
	
	NSBezierPath* path = [ NSBezierPath bezierPath ];
	[ path moveToPoint:start ];
	[ path lineToPoint:end ];
	[ path setLineWidth:LINE_WIDTH ];
	[ path setLineCapStyle:NSRoundLineCapStyle ];
	[ path stroke ];
}

@end
