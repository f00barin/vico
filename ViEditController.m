//
//  ViEditController.m
//  vizard
//
//  Created by Martin Hedenfalk on 2008-03-21.
//  Copyright 2008 Martin Hedenfalk. All rights reserved.
//

#import "ViEditController.h"

@implementation ViEditController

- (id)initWithString:(NSString *)data
{
	self = [super init];
	if(self)
	{
		[NSBundle loadNibNamed:@"EditorView" owner:self];
		if(data)
			[[[textView textStorage] mutableString] setString:data];
		[textView initEditor];
		[textView setDelegate:self];
	}

	return self;
}

- (NSView *)view
{
	return view;
}

- (void)setString:(NSString *)aString
{
	[[[textView textStorage] mutableString] setString:aString];
}

- (void)setFilename:(NSURL *)aURL
{
	[textView setFilename:aURL];
	[textView highlightEverything];
}

- (void)changeTheme:(ViTheme *)theme
{
	[textView setTheme:theme];
}

- (void)message:(NSString *)fmt, ...
{
	va_list ap;
	va_start(ap, fmt);
	NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:ap];
	va_end(ap);
	
	[statusbar setStringValue:msg];
}

- (IBAction)finishedExCommand:(id)sender
{
	NSLog(@"got ex command? [%@]", [statusbar stringValue]);
	[textView performSelector:exCommandSelector withObject:[statusbar stringValue]];
	[statusbar setStringValue:@""];
	[statusbar setEditable:NO];
	// [editWindow makeFirstResponder:textView];
}

/* FIXME: should probably subclass NSTextField to disallow losing focus due to tabbing or clicking outside.
 * Should handle escape and ctrl-c.
 */
- (void)getExCommandForTextView:(ViTextView *)aTextView selector:(SEL)aSelector
{
	[statusbar setStringValue:@":"]; // FIXME: should not select the colon
	[statusbar setEditable:YES];
	[statusbar setDelegate:self];
	exCommandSelector = aSelector;
	// [editWindow makeFirstResponder:statusbar];
}

- (BOOL)tabView:(NSTabView *)tabView shouldCloseTabViewItem:(NSTabViewItem *)tabViewItem
{
	return NO;
}

@end
