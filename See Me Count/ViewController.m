//
//  ViewController.m
//  See Me Count
//
//  Created by Ian on 30/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {

}

@end

@implementation ViewController

@synthesize playerIntro;
@synthesize currGameID;
@synthesize playerSuccess;
@synthesize playerPersonal1;
@synthesize playerWellDone;
@synthesize currentTune;

@synthesize settingsView;

@synthesize infoView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set up event to trigger when the application becomes active again, to display the setup page.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(backToForeground)
                   name:UIApplicationWillEnterForegroundNotification
                 object:nil];
	
	// Set up event to trigger when the application will lose focus, to stop any players / recorders
	[center addObserver:self
			   selector:@selector(resignActive)
				   name:UIApplicationWillResignActiveNotification
				 object:nil];
	
	// Make sure that the database of sessions & games exists in the documents folder.
	// If it doesn't, copy from the app resources into the documents folder
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	dbFile = [documentsDirectory stringByAppendingPathComponent:@"see.me.count.db"];
	
	if ([fileManager fileExistsAtPath:dbFile] == NO) {
		NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"see.me.count" ofType:@"db"];
		[fileManager copyItemAtPath:resourcePath toPath:dbFile error:&error];
	}
	
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
	
	//  Set which buttons are available on the initial settings screen. The method that does this also sets
	//  the colours of the labels for each item, to show whether they have been already been recorded or not.
    // [self enableSetupButtons];
    
	//  Set the initial game ID to be zero
	currGameID=0;
	
	gameSetup = [[setupGame alloc] initWithFrame:CGRectMake(0,0,1024,768) owner:self];
}

// Create a new session ID. A session starts when the Go button is pressed.
// Retrieve the most recent session ID from the database, add one to it and insert the new session ID back in to the
// database with current date & time.
- (void) newSessID {
	NSInteger oldSessID=0;
	oldSessID=[self singleNumQuery:@"select max(sessID) from useEvent"];
	currSessID=++oldSessID;
	
	char *insert_sql="insert into sessDetail (sessID, sessDate, sessTime) values (?,?,?)";

	NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
	[DateFormatter setDateFormat:@"yyyyMMdd"];
	NSString *wDate=[DateFormatter stringFromDate:[NSDate date]];
	[DateFormatter setDateFormat:@"hhmmss"];
	NSString *wTime=[DateFormatter stringFromDate:[NSDate date]];

	sqlite3_stmt *statement=nil;

	struct sqlite3 *sqlHandle=[self openDB];
	
	if (sqlHandle!=NULL) {
		if (sqlite3_prepare_v2(sqlHandle, insert_sql, -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(statement,1,(int)currSessID);
			sqlite3_bind_text(statement,2,[wDate UTF8String],-1,SQLITE_TRANSIENT);
			sqlite3_bind_text(statement,3,[wTime UTF8String],-1,SQLITE_TRANSIENT);
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}
		sqlite3_close(sqlHandle);
	}
}


// Log the number pressed and the correct number to press in the database
- (void) logNumPress:(NSInteger)numPressed correctNum:(NSInteger)correctNum {
	NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
	[DateFormatter setDateFormat:@"yyyyMMdd"];
	NSString *wDate=[DateFormatter stringFromDate:[NSDate date]];
	[DateFormatter setDateFormat:@"hhmmss"];
	NSString *wTime=[DateFormatter stringFromDate:[NSDate date]];

	char *insert_sql="insert into useEvent (sessID,gameID,eventDate,eventTime,numPressed,numCorrect) values (?,?,?,?,?,?)";
	sqlite3_stmt *statement=nil;
	
	struct sqlite3 *sqlHandle=[self openDB];
	
	if (sqlHandle!=NULL) {
		if (sqlite3_prepare_v2(sqlHandle, insert_sql, -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(statement,1,(int)currSessID);
			sqlite3_bind_int(statement,2,(int)currGameID);
			sqlite3_bind_text(statement,3,[wDate UTF8String],-1,SQLITE_TRANSIENT);
			sqlite3_bind_text(statement,4,[wTime UTF8String],-1,SQLITE_TRANSIENT);
			sqlite3_bind_int(statement,5,(int)numPressed);
			sqlite3_bind_int(statement,6,correctNum);
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}
		sqlite3_close(sqlHandle);
	}
}

// Open the information database
- (struct sqlite3 *) openDB {
	const char *dbPath=[dbFile UTF8String];
	struct sqlite3 *sqlHandle;
	if(!(sqlite3_open(dbPath,&sqlHandle) == SQLITE_OK))
	{
		NSLog(@"An error has occured.");
		return NULL;
	} else {
		return sqlHandle;
	}
}

// Execute a supplied SQL statement that will return a numeric value
- (int) singleNumQuery:(NSString *)sqlQuery {
	const char *query_sql=[sqlQuery UTF8String];
	sqlite3_stmt *statement;
	int retValue=0;
	struct sqlite3 *sqlHandle = [self openDB];

	if (sqlHandle!=NULL) {
		if (sqlite3_prepare_v2(sqlHandle, query_sql, -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement)==SQLITE_ROW) {
				retValue=sqlite3_column_int(statement,0);
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(sqlHandle);
		return retValue;
	} else {
		return -1;
	}
}

// Count how many sessions are logged in the database.
- (int) numSessions {
	return [self singleNumQuery:@"select count(*) from (select sessID from useEvent group by sessID)"];
}

// Count the number of games logged in the database. A game is classed as being between the intro being played and the correct
// button being pressed.
- (int) numGames {
	return [self singleNumQuery:@"select count(gameID) from useEvent"];
}

// Query the datbase to get an array containing 3 arrays of the Dates for each session, the number of times the wrong button
// was pressed in each session and the number of times the right button was pressed in each session.
- (NSMutableArray *) gamesInSession:(NSInteger)daysToDisplay offsetDay:(NSInteger)offsetDay {
	NSMutableArray *retDataX = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retDataY1 = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retDataY2 = [NSMutableArray arrayWithObjects:nil count:0];

	const char *query_sql="select sd.sessDate, (select count(*) from useevent ue where ue.eventDate = sd.sessDate and numPressed!=numCorrect), (select count(*) from useevent ue where ue.eventDate = sd.sessDate and numPressed=numCorrect)  from sessdetail sd group by sessdate order by sessdate";
	sqlite3_stmt *statement;
	struct sqlite3 *sqlHandle = [self openDB];
	
	if (sqlHandle!=NULL) {
		if (sqlite3_prepare_v2(sqlHandle, query_sql, -1, &statement, NULL) == SQLITE_OK) {
			while  (sqlite3_step(statement)==SQLITE_ROW) {
				NSString *dateValue = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,0)];
				NSString *monthNo = [dateValue substringWithRange:NSMakeRange(4, 2)];
				NSString *dayNo = [dateValue substringWithRange:NSMakeRange(6, 2)];
				NSString *axisYvalue;
				switch ([monthNo intValue]) {
					case 1:
						axisYvalue=[NSString stringWithFormat:@"%@-Jan",dayNo];
						break;
					case 2:
						axisYvalue=[NSString stringWithFormat:@"%@-Feb",dayNo];
						break;
					case 3:
						axisYvalue=[NSString stringWithFormat:@"%@-Mar",dayNo];
						break;
					case 4:
						axisYvalue=[NSString stringWithFormat:@"%@-Apr",dayNo];
						break;
					case 5:
						axisYvalue=[NSString stringWithFormat:@"%@-May",dayNo];
						break;
					case 6:
						axisYvalue=[NSString stringWithFormat:@"%@-Jun",dayNo];
						break;
					case 7:
						axisYvalue=[NSString stringWithFormat:@"%@-Jul",dayNo];
						break;
					case 8:
						axisYvalue=[NSString stringWithFormat:@"%@-Aug",dayNo];
						break;
					case 9:
						axisYvalue=[NSString stringWithFormat:@"%@-Sep",dayNo];
						break;
					case 10:
						axisYvalue=[NSString stringWithFormat:@"%@-Oct",dayNo];
						break;
					case 11:
						axisYvalue=[NSString stringWithFormat:@"%@-Nov",dayNo];
						break;
					case 12:
						axisYvalue=[NSString stringWithFormat:@"%@-Dec",dayNo];
						break;
					default:
						NSLog(@"What month? %d", [monthNo intValue]);
				}
				[retDataX addObject:axisYvalue];
				[retDataY1 addObject:[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
				[retDataY2 addObject:[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,2)]];
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(sqlHandle);
	}
		
	NSMutableArray *retData = [NSMutableArray arrayWithObjects:nil count:0];
	[retData addObject:retDataX];
	[retData addObject:retDataY1];
	[retData addObject:retDataY2];
	
	return retData;
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

// Button to make the Information View visible.
// Calls methods to display the number of time that the game has been played (i.e. how many times the Go button of the settings
// page has actually been pressed), the total number of games that have been played (i.e. how many times the intro tune / words
// have been played / spoken, a Chart View of the dates on which the games has been played (with composite column of wrong answers
// and right answers) and a Chart View of how many times each of the numbers has been pressed wrongly or rightly.
- (IBAction)showInfo:(id)sender {
	[infoView setHidden:NO];
	[settingsView bringSubviewToFront:infoView];
	
	[self updateSessions];
	[self updateGames];
	[self showSessionsByGames];
	[self showGamesInSession];
}

// Hide the Information View
- (IBAction)closeInfo:(id)sender {
	setupGame *gSet = gameSetup;
	
	[infoView setHidden:YES];
	[gSet.panelPane setHidden:NO];
}

// Display a count, of up to 3 digits, of the number of times the game has been played
- (void) updateSessions {
	digitalDisplay *myDig1 __attribute__((unused)) = [[digitalDisplay alloc] initWithFrame:CGRectMake(112, 20, 90, 112) containingView:infoView digitImages:myDigImages numberValue:[self numSessions] label:@"Number of times played"];
}

// Display a count, of up to 3 digits, of the number of games that have been played
- (void) updateGames {
	digitalDisplay *myDig1 __attribute__((unused)) = [[digitalDisplay alloc] initWithFrame:CGRectMake(254, 20, 90, 112) containingView:infoView digitImages:myDigImages numberValue:[self numGames] label:@"Number of games played"];

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
	
	for (int dIdx=0;dIdx<9;dIdx++) {
		[setNumbs addObject:[NSString stringWithFormat:@"%d",dIdx+1]];
		
		[setWrong addObject:[NSString stringWithFormat:@"%d",[self singleNumQuery:[NSString stringWithFormat:@"select count(*) from useevent where numcorrect=%d and numpressed!=%d",dIdx+1,dIdx+1]]]];

		[setRight addObject:[NSString stringWithFormat:@"%d",[self singleNumQuery:[NSString stringWithFormat:@"select count(*) from useevent where numcorrect=%d and numpressed=%d",dIdx+1,dIdx+1]]]] ;

	}

	[returnSet addObject:setNumbs];
	[returnSet addObject:setWrong];
	[returnSet addObject:setRight];
	return returnSet;
}

- (void) showSessionsByGames {
	NSMutableArray *localGameDat;
	
	localGameDat=[self updateNumberCounts];
	
	ChartView *myChart;
	
	myChart	=[[ChartView alloc] initWithFrame:CGRectMake(12, 220, 1000, 240) containingView:infoView rangeX:localGameDat[0] rangeY1:localGameDat[1] rangeY2:localGameDat[2] chartLabel:@""];


	[self writeHeading:@"How many times was each number got or not?" rect:CGRectMake(12, 180, 600, 30) containerView:infoView colour:[UIColor whiteColor]];
}

- (void) showGamesInSession {
	sessGameDat = [self gamesInSession:7 offsetDay:0];

	[self writeHeading:@"Numbers Right and Wrong by Date" rect:CGRectMake(12, 472, 600, 30) containerView:infoView colour:[UIColor whiteColor]];
	
	goLeft=[[UIButton alloc] initWithFrame:CGRectMake(10, 617, 30, 30)];
	[goLeft setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrowLeft" ofType:@"png"]] forState:UIControlStateNormal];
	[goLeft addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
	[infoView addSubview:goLeft];
	[infoView bringSubviewToFront:goLeft];
	if ([sessGameDat[0]count] > 7) {
		goLeft.hidden=NO;
	} else {
		goLeft.hidden=YES;
	}

	goRight=[[UIButton alloc] initWithFrame:CGRectMake(984, 617, 30, 30)];
	[goRight setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrowRight" ofType:@"png"]] forState:UIControlStateNormal];
	[goRight addTarget:self action:@selector(rightButtonPress) forControlEvents:UIControlEventTouchUpInside];
	[infoView addSubview:goRight];
	[infoView bringSubviewToFront:goRight];
	goRight.hidden=YES;

	ChartView *myChart;
	
	NSMutableArray *restrictedData;
	if ([[sessGameDat objectAtIndex:0] count] > 7) {
		restrictedData=[self trimDataByDays:sessGameDat numItems:7 offsetItem:0];
	} else {
		restrictedData=sessGameDat;
	}
	
	myChart	=[[ChartView alloc] initWithFrame:CGRectMake(50, 512, 924, 240) containingView:infoView rangeX:restrictedData[0] rangeY1:restrictedData[1] rangeY2:restrictedData[2] chartLabel:@""];
	
	viewGameOffset=0;
	viewGameCount=[sessGameDat[0] count];
	viewGameMaxY = myChart.maximumY;
	NSLog(@"Max Y: %ld",(long)viewGameMaxY);
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

// Left arrow button to go back one session in time
// Hides the left arrow button if earliest session is being displayed
// All session details have already been retrieved. The trimDataByDays method cuts down the data to what will
// fit in to the chart display
- (void) leftButtonPress {
	viewGameOffset++;
	
	if (viewGameOffset + 7 >= viewGameCount) {
		goLeft.hidden=YES;
	}
	
	goRight.hidden=NO;
	
	ChartView *myChart;
	
	NSMutableArray *restrictedData;
	if ([[sessGameDat objectAtIndex:0] count]> 7) {
		restrictedData=[self trimDataByDays:sessGameDat numItems:7 offsetItem:viewGameOffset];
	} else {
		restrictedData=sessGameDat;
	}
	
	myChart	=[[ChartView alloc] initWithFrame:CGRectMake(50, 512, 924, 240) containingView:infoView rangeX:restrictedData[0] rangeY1:restrictedData[1] rangeY2:restrictedData[2] yOveride:[self theMaxY] chartLabel:@""];

}

// Right arrow button to go forward one session in time
// Hides the right arrow button if the latest session is being displayed
// All session details have already been retrieved. The trimDataByDays method cuts down the data to what will
// fit in to the chart display
- (void) rightButtonPress {
	viewGameOffset--;
	
	if (viewGameOffset<=0) {
		viewGameOffset=0;
		goRight.hidden=YES;
	}
	
	goLeft.hidden=NO;

	ChartView *myChart;
	
	NSMutableArray *restrictedData;
	if ([[sessGameDat objectAtIndex:0] count] > 7) {
		restrictedData=[self trimDataByDays:sessGameDat numItems:7 offsetItem:viewGameOffset];
	} else {
		restrictedData=sessGameDat;
	}
	
	myChart	=[[ChartView alloc] initWithFrame:CGRectMake(50, 512, 924, 240) containingView:infoView rangeX:restrictedData[0] rangeY1:restrictedData[1] rangeY2:restrictedData[2] yOveride:[self theMaxY] chartLabel:@""];
}

- (void) backToForeground
{
    /* If the application becomes active again, set the setup page to be the active view by unhiding it */
    //[self enableSetupButtons];
    [settingsView setHidden:FALSE];
	[infoView setHidden:YES];
}

- (void) resignActive
{
	if ([recorder1 isRecording]) {
		[recorder1 stop];
	}
    
	if ([playerPersonal1 isPlaying]) {
		[playerPersonal1 stop];
	}
	
	if ([playerSuccess isPlaying]) {
		[playerSuccess stop];
	}
	
	if ([playerWellDone isPlaying]) {
		[playerWellDone stop];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goButton:(id)sender {
    [settingsView setHidden:TRUE];
	[self newSessID];
	[self newGame];
}

- (void) newGame {
	playGame *pGame __unused = [[playGame alloc] initWithFrame:CGRectMake(0,0,1024,768) owner:self];
}


@end
