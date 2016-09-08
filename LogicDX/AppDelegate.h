//
//  AppDelegate.h
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LDXGridView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	IBOutlet NSScrollView* gridScroll;
	
	LDXGridView* gridView;
}

- (IBAction) gridSelectionRegular:(id)sender;
- (IBAction) gridSelectionElement:(id)sender;
- (IBAction) gridSelectionMove:(id)sender;

- (IBAction) viewZoomIn:(id)sender;
- (IBAction) viewZoomOut:(id)sender;


@end

