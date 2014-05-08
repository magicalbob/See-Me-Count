//
//  setupGame.m
//  See Me Count
//
//  Created by Ian on 03/04/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "setupGame.h"

@implementation setupGame

@synthesize numberSetup;

- (id)initWithFrame:(CGRect)frame owner:(id)vOwner
{
    self = [super initWithFrame:frame];
    if (self) {
		owner = vOwner;
		numberSetup = [NSMutableArray arrayWithObjects:nil count:0];
		[self displaySetup];
    }
    return self;
}

- (void) displaySetup {
	ViewController *myView;
	myView = owner;
	
	panelPane = [[UIView alloc] initWithFrame:self.frame];
	panelPane.backgroundColor = [UIColor blackColor];
	[[myView view] addSubview:panelPane];
	[[myView view] bringSubviewToFront:panelPane];
	
	for (int dIdx=0; dIdx < 9; dIdx++) {
		[numberSetup addObject:[[messageRecorder alloc] initWithFrame:CGRectMake(256,(dIdx * 61) + 15,512,46) owner:self containerView:myView.view labelDefault:@"message" labelName:@"l1" messageName:@"m1"]];
	}
	
	goButton = [[UIButton alloc] initWithFrame:CGRectMake(475, 660, 75, 75)];
	[goButton addTarget:owner action:@selector(goButton:) forControlEvents:UIControlEventTouchDown];
	[goButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"go" ofType:@"png"]] forState:UIControlStateNormal];

	[panelPane addSubview:goButton];
}

- (void) disableAllButtons
{
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
