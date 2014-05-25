//
//  statsView.m
//  See Me Count
//
//  Created by Ian on 25/05/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "statsView.h"

@implementation statsView

@synthesize panelPane;

- (id)initWithFrame:(CGRect)frame owner:(id)vOwner
{
    self = [super initWithFrame:frame];
    if (self) {
		mySelf = self;
		owner = vOwner;
		
		// Set up images for digits that will be used in the Information view
		myDigImages = [NSMutableArray arrayWithObjects:nil count:0];
		
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig0"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig1"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig2"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig3"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig4"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig5"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig6"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig7"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig8"] ofType:@"png"]];
		[myDigImages addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Dig9"] ofType:@"png"]];
		
		[self displayStats];
    }
    return self;
}

// Create a new view to hold the stats, a button to close it with and subviews for the stats.
// Calls methods to display the number of time that the game has been played (i.e. how many times the Go button of the settings
// page has actually been pressed), the total number of games that have been played (i.e. how many times the intro tune / words
// have been played / spoken, a Chart View of the dates on which the games has been played (with composite column of wrong answers
// and right answers) and a Chart View of how many times each of the numbers has been pressed wrongly or rightly.
- (void) displayStats
{
	ViewController *myView;
	myView = owner;
	
	// Create a black background view for the setup page
	panelPane = [[UIView alloc] initWithFrame:self.frame];
	panelPane.backgroundColor = [UIColor blackColor];
	[[myView view] addSubview:panelPane];
	[[myView view] bringSubviewToFront:panelPane];
	
	// Create a button to close the stats view.
	UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(12,20,50,50)];
	[closeButton addTarget:self action:@selector(closeInfo) forControlEvents:UIControlEventTouchDown];
	[closeButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"close" ofType:@"png"]] forState:UIControlStateNormal];
	[panelPane addSubview:closeButton];
	
	[self updateSessions];
	[self updateGames];
	[self showSessionsByGames];
	[self showGamesInSession];
}

- (void) closeInfo
{
	[panelPane removeFromSuperview];
}

// Display a count, of up to 3 digits, of the number of times the game has been played
- (void) updateSessions {
	ViewController *myView;
	myView = owner;
	
	statDatabase *dataStat = [statDatabase alloc];
	
	digitalDisplay *myDig1 __attribute__((unused)) = [[digitalDisplay alloc] initWithFrame:CGRectMake(112, 20, 90, 112)
																			containingView:panelPane
																			   digitImages:myDigImages
																			   numberValue:[dataStat numSessions:[myView dbFile]]
																					 label:@"Number of times played"];
}

// Display a count, of up to 3 digits, of the number of games that have been played
- (void) updateGames {
	ViewController *myView;
	myView = owner;
	
	statDatabase *dataStat = [statDatabase alloc];
	
	digitalDisplay *myDig1 __attribute__((unused)) = [[digitalDisplay alloc] initWithFrame:CGRectMake(254, 20, 90, 112)
																			containingView:panelPane
																			   digitImages:myDigImages
																			   numberValue:[dataStat numGames:[myView dbFile]]
																					 label:@"Number of games played"];
	
}

- (void) showSessionsByGames {
	NSMutableArray *localGameDat;
	
	localGameDat=[self updateNumberCounts];
	
	ChartView *myChart;
	
	myChart	=[[ChartView alloc] initWithFrame:CGRectMake(12, 220, 1000, 240)
							   containingView:panelPane
									   rangeX:localGameDat[0]
									  rangeY1:localGameDat[1]
									  rangeY2:localGameDat[2]
								   chartLabel:@""];
	
	[self writeHeading:@"How many times was each number got or not?"
				  rect:CGRectMake(12, 180, 600, 30)
		 containerView:panelPane
				colour:[UIColor whiteColor]];
}

// Display heading text for an information item
- (void) writeHeading:(NSString *)text rect:(CGRect)rect containerView:(UIView *)containerView colour:(UIColor*)colour {
	UILabel *textLabel;
	
	textLabel = [[UILabel alloc] initWithFrame:rect];
	[textLabel setText:text];
	textLabel.textColor=colour;
	textLabel.font=[UIFont fontWithName:@"ArialMT" size:24];
	[containerView addSubview:textLabel];
	[containerView bringSubviewToFront:textLabel];
	
}

// Query the database to find, for each digit 1 to 9, how many times a different digit was pressed instead of this digit, and how
// how many times the correct digit was pressed.
- (NSMutableArray *) updateNumberCounts {
	NSMutableArray *returnSet = [NSMutableArray arrayWithObjects:nil count:0];
    NSMutableArray *setNumbs = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *setRight = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *setWrong = [NSMutableArray arrayWithObjects:nil count:0];

	ViewController *myView;
	myView = owner;
	
	statDatabase *dataStat = [statDatabase alloc];
		
	for (int dIdx=0;dIdx<9;dIdx++) {
		[setNumbs addObject:[NSString stringWithFormat:@"%d",dIdx+1]];
		
		[setWrong addObject:[NSString stringWithFormat:@"%d",[dataStat singleNumQuery:[myView dbFile] sqlQuery:[NSString stringWithFormat:@"select count(*) from useevent where numcorrect=%d and numpressed!=%d",dIdx+1,dIdx+1]]]];
		
		[setRight addObject:[NSString stringWithFormat:@"%d",[dataStat singleNumQuery:[myView dbFile] sqlQuery:[NSString stringWithFormat:@"select count(*) from useevent where numcorrect=%d and numpressed=%d",dIdx+1,dIdx+1]]]] ;
		
	}
	
	[returnSet addObject:setNumbs];
	[returnSet addObject:setWrong];
	[returnSet addObject:setRight];
	return returnSet;
}

- (void) showGamesInSession {
	ViewController *myView;
	myView = owner;
	
	statDatabase *dataStat = [statDatabase alloc];
	
	sessGameDat = [dataStat gamesInSession:[myView dbFile] daysToDisplay:7 offsetDay:0];
	[self writeHeading:@"Numbers Right and Wrong by Date"
				  rect:CGRectMake(12, 472, 600, 30)
		 containerView:panelPane
				colour:[UIColor whiteColor]];
	
	goLeft=[[UIButton alloc] initWithFrame:CGRectMake(10, 617, 30, 30)];
	[goLeft setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrowLeft"
																					  ofType:@"png"]]
			forState:UIControlStateNormal];
	[goLeft addTarget:mySelf action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchDown];
	[panelPane addSubview:goLeft];
	[panelPane bringSubviewToFront:goLeft];
	if ([sessGameDat[0]count] > 7) {
		goLeft.hidden=NO;
	} else {
		goLeft.hidden=YES;
	}
	
	goRight=[[UIButton alloc] initWithFrame:CGRectMake(984, 617, 30, 30)];
	[goRight setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrowRight" ofType:@"png"]] forState:UIControlStateNormal];
	[goRight addTarget:mySelf action:@selector(rightButtonPress) forControlEvents:UIControlEventTouchUpInside];
	[panelPane addSubview:goRight];
	[panelPane bringSubviewToFront:goRight];
	goRight.hidden=YES;
	
	ChartView *myChart;
	
	NSMutableArray *restrictedData;
	if ([[sessGameDat objectAtIndex:0] count] > 7) {
		restrictedData=[self trimDataByDays:sessGameDat numItems:7 offsetItem:0];
	} else {
		restrictedData=sessGameDat;
	}
	
	myChart	=[[ChartView alloc] initWithFrame:CGRectMake(50, 512, 924, 240)
							   containingView:panelPane
									   rangeX:restrictedData[0]
									  rangeY1:restrictedData[1]
									  rangeY2:restrictedData[2]
								   chartLabel:@""];
	
	viewGameOffset=0;
	viewGameCount=[sessGameDat[0] count];
	viewGameMaxY = myChart.maximumY;
}

// Left arrow button to go back one session in time
// Hides the left arrow button if earliest session is being displayed
// All session details have already been retrieved. The trimDataByDays method cuts down the data to what will
// fit in to the chart display
- (void) leftButtonPress {
	ViewController *myView;
	myView = owner;
	
	viewGameOffset++;
	
	if (viewGameOffset + 7 >= viewGameCount) {
		goLeft.hidden=YES;
	}
	
	goRight.hidden=NO;
	
	ChartView *myChart;
	
	NSMutableArray *restrictedData;
	if ([[sessGameDat objectAtIndex:0] count]> 7) {
		restrictedData=[self trimDataByDays:sessGameDat
									 numItems:7
								   offsetItem:viewGameOffset];
	} else {
		restrictedData=sessGameDat;
	}
	
	myChart	=[[ChartView alloc] initWithFrame:CGRectMake(50, 512, 924, 240)
							   containingView:panelPane
									   rangeX:restrictedData[0]
									  rangeY1:restrictedData[1]
									  rangeY2:restrictedData[2]
									 yOveride:[self theMaxY]
								   chartLabel:@""];
	
}

// Right arrow button to go forward one session in time
// Hides the right arrow button if the latest session is being displayed
// All session details have already been retrieved. The trimDataByDays method cuts down the data to what will
// fit in to the chart display
- (void) rightButtonPress {
	ViewController *myView;
	myView = owner;
	
	viewGameOffset--;
	
	if (viewGameOffset<=0) {
		viewGameOffset=0;
		goRight.hidden=YES;
	}
	
	goLeft.hidden=NO;
	
	ChartView *myChart;
	
	NSMutableArray *restrictedData;
	if ([[sessGameDat objectAtIndex:0] count] > 7) {
		restrictedData=[self trimDataByDays:sessGameDat
									 numItems:7
								   offsetItem:viewGameOffset];
	} else {
		restrictedData=sessGameDat;
	}
	
	myChart	=[[ChartView alloc] initWithFrame:CGRectMake(50, 512, 924, 240)
							   containingView:panelPane
									   rangeX:restrictedData[0]
									  rangeY1:restrictedData[1]
									  rangeY2:restrictedData[2]
									 yOveride:[self theMaxY]
								   chartLabel:@""];
}

// Method to return a subset of a data set, so that it fits in to the space available in the Chart View that will display it.
// offsetItem being zero means that the right most elements of the data set will be displayed.
// As offsetItem increases by one, the right most element displayed moves to be one less in the arrays.
- (NSMutableArray *) trimDataByDays:(NSMutableArray *)theData numItems:(NSInteger)numItems offsetItem:(NSInteger)offsetItem {
	NSMutableArray *retData = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retRange1 = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retRange2 = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retRange3 = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *inputRange1 = [theData objectAtIndex:0];
	NSMutableArray *inputRange2 = [theData objectAtIndex:1];
	NSMutableArray *inputRange3 = [theData objectAtIndex:2];
	
	NSInteger startIdx = [inputRange1 count] - numItems - offsetItem;
	if (startIdx<0) {
		startIdx=0;
	}
	
	for (int newIdx=0;newIdx<numItems;newIdx++) {
		[retRange1 addObject:[inputRange1 objectAtIndex:(startIdx + newIdx)]];
		[retRange2 addObject:[inputRange2 objectAtIndex:(startIdx + newIdx)]];
		[retRange3 addObject:[inputRange3 objectAtIndex:(startIdx + newIdx)]];
	}
	
	[retData addObject:retRange1];
	[retData addObject:retRange2];
	[retData addObject:retRange3];
	
	return retData;
}

- (NSInteger) theMaxY {
	NSInteger myMax=0;
	NSMutableArray *range1;
    NSMutableArray *range2;
	
	range1=[sessGameDat objectAtIndex:1];
	range2=[sessGameDat objectAtIndex:2];
	
	for (int dIdx=0; dIdx<[[sessGameDat objectAtIndex:0] count]; dIdx++) {
		if ([[range1 objectAtIndex:dIdx] integerValue] + [[range2 objectAtIndex:dIdx] integerValue] > myMax) {
			myMax=[[range1 objectAtIndex:dIdx] integerValue] + [[range2 objectAtIndex:dIdx] integerValue];
		}
	}
	
	return myMax;
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
