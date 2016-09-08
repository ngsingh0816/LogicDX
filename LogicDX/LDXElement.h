//
//  LDXElement.h
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDXGridView.h"

#define LINE_WIDTH	2.0

@interface LDXElement : NSObject
{
}

@property (assign) LDXGridPoint startPoint;
@property (assign) LDXGridSize size;
@property (assign) LDXGridView* gridView;
@property (assign) BOOL selected;

- (void) drawElement;
- (void) drawBoundingBox;

- (LDXPolygon) boundingBox;

- (void) setEndPoint:(LDXGridPoint) endPoint;
- (LDXGridPoint) endPoint;

@end
