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
@synthesize welldoneSetup;
@synthesize panelPane;

- (id)initWithFrame:(CGRect)frame owner:(id)vOwner
{
    self = [super initWithFrame:frame];
    if (self) {
		owner = vOwner;
		numberSetup = [NSMutableArray arrayWithObjects:nil count:0];
		welldoneSetup = [NSMutableArray arrayWithObjects:nil count:0];
		[self displaySetup];
    }
    return self;
}

- (void) displaySetup {
	ViewController *myView;
	myView = owner;
	
	// Create a list of the labels to display in the set up page
	labNames = [NSMutableArray arrayWithObjects:nil count:0];
	[labNames addObject:@" Look! One tiger. Can you see the number one?"];
	[labNames addObject:@" Look! Two cats. Can you see the number two?"];
	[labNames addObject:@" Look! Three snakes. Can you see the number three?"];
	[labNames addObject:@" Look! Four mice. Can you see the number four?"];
	[labNames addObject:@" Look! Five cows. Can you see the number five?"];
	[labNames addObject:@" Look! Six chickens. Can you see the number six?"];
	[labNames addObject:@" Look! Seven ducks. Can you see the number seven?"];
	[labNames addObject:@" Look! Eight dogs. Can you see the number eight?"];
	[labNames addObject:@" Look! Nine elephants. Can you see the number nine?"];
	
	// Create a black background view for the setup page
	panelPane = [[UIView alloc] initWithFrame:self.frame];
	panelPane.backgroundColor = [UIColor blackColor];
	[[myView view] addSubview:panelPane];
	[[myView view] bringSubviewToFront:panelPane];
	
	// Create a label, record, play and delete button for the nine options
	for (int dIdx=0; dIdx < 9; dIdx++)
	{
		[numberSetup addObject:[[messageRecorder alloc] initWithFrame:CGRectMake(212,(dIdx * 61) + 15, 600 ,46)
																owner:self
														containerView: panelPane //myView.view
														 labelDefault:[labNames objectAtIndex:dIdx]
														  messageName:[NSString stringWithFormat:@"personalNumber%d%d",(dIdx+1),(dIdx+1)]]];
	}
	
	// Create a label, record, play and delete button for the 4 well done messages
	for (int dIdx= 0; dIdx < 4; dIdx++)
	{
		messageRecorder *mRec;
		mRec=[[messageRecorder alloc] initWithFrame:CGRectMake(45+(dIdx * 236), 564, 226, 46)
											  owner:self
									  containerView:panelPane
									   labelDefault:@"Well done"
										messageName:[NSString stringWithFormat:@"personalMessage%d",(dIdx+1)]];
		[mRec textAlignment:NSTextAlignmentCenter];
		[welldoneSetup addObject:mRec];
	}
	
	// Create an Info button to display stats on games played.
	infoButton = [[UIButton alloc] initWithFrame:CGRectMake(12,20,50,50)];
	[infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchDown];
	[infoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"png"]] forState:UIControlStateNormal];
	[panelPane addSubview:infoButton];
	
	// Create a Go button to start the game. Set the touch down event of the button to launch the game.
	goButton = [[UIButton alloc] initWithFrame:CGRectMake(475, 660, 75, 75)];
	[goButton addTarget:self action:@selector(goButton) forControlEvents:UIControlEventTouchDown];
	[goButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"go" ofType:@"png"]] forState:UIControlStateNormal];
	[panelPane addSubview:goButton];
}

- (void) goButton
{
	ViewController *vc = owner;
	
	[vc goButton];
}

- (void) showInfo
{
	statsView *myStats __unused = [[statsView alloc] initWithFrame:CGRectMake(0,0,1024,768) owner:owner];
}

- (void) enableAllButtons
{
	for (int dIdx=0; dIdx < [numberSetup count]; dIdx++)
	{
		[[numberSetup objectAtIndex:dIdx] enableButtons];
	}
	for (int dIdx=0; dIdx < [welldoneSetup count]; dIdx++)
	{
		[[welldoneSetup objectAtIndex:dIdx] enableButtons];
	}
}

- (void) disableAllButtons
{
	for (int dIdx=0; dIdx < [numberSetup count]; dIdx++)
	{
		[[numberSetup objectAtIndex:dIdx] disableButtons];
	}
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
