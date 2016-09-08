//
//  LDXWire.h
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import "LDXElement.h"

@interface LDXWire : LDXElement
{
}

@property (assign) double resistivity;

- (double) length;
- (double) resistance;

@end
