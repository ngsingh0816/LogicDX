//
//  AppDelegate.m
//  LogicDX
//
//  Created by Neil Singh on 4/23/15.
//  Copyright (c) 2015 Neil Singh. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow* window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	gridView = [ [ LDXGridView alloc ] initWithFrame:[ [ gridScroll contentView ] frame ] ];
	[ gridScroll setDocumentView:gridView ];
	[ _window setAcceptsMouseMovedEvents:YES ];
	[ _window makeFirstResponder:gridView ];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (IBAction) gridSelectionRegular:(id)sender
{
	for (NSMenuItem* item in [ [ sender menu ] itemArray ])
	{
		[ item setState:NSOffState ];
	}
	[ sender setState:NSOnState ];
	[ gridView setGridSelection:0 ];
	[ [ NSCursor arrowCursor ] set ];
}

- (IBAction) gridSelectionElement:(id)sender
{
	for (NSMenuItem* item in [ [ sender menu ] itemArray ])
	{
		[ item setState:NSOffState ];
	}
	[ sender setState:NSOnState ];
	[ gridView setGridSelection:1 ];
	[ [ NSCursor arrowCursor ] set ];
}

- (IBAction) gridSelectionMove:(id)sender
{
	for (NSMenuItem* item in [ [ sender menu ] itemArray ])
	{
		[ item setState:NSOffState ];
	}
	[ sender setState:NSOnState ];
	[ gridView setGridSelection:2 ];
	[ [ NSCursor openHandCursor ] set ];
}

- (IBAction) viewZoomIn:(id)sender
{
	[ gridView zoomIn ];
}

- (IBAction) viewZoomOut:(id)sender
{
	[ gridView zoomOut ];
}

@end
