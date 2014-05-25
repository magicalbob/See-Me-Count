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
@synthesize buttonRecord1;
@synthesize buttonPlay1;
@synthesize buttonDelete1;
@synthesize buttonRecord2;
@synthesize buttonPlay2;
@synthesize buttonDelete2;
@synthesize buttonRecord3;
@synthesize buttonPlay3;
@synthesize buttonDelete3;
@synthesize buttonRecord4;
@synthesize buttonPlay4;
@synthesize buttonDelete4;
@synthesize buttonRecord5;
@synthesize buttonPlay5;
@synthesize buttonDelete5;
@synthesize buttonRecord6;
@synthesize buttonPlay6;
@synthesize buttonDelete6;
@synthesize buttonRecord7;
@synthesize buttonPlay7;
@synthesize buttonDelete7;
@synthesize buttonRecord8;
@synthesize buttonPlay8;
@synthesize buttonDelete8;
@synthesize buttonRecord9;
@synthesize buttonPlay9;
@synthesize buttonDelete9;
@synthesize goButton;

@synthesize record1Main;
@synthesize record1Progress;
@synthesize record2Main;
@synthesize record2Progress;
@synthesize record3Main;
@synthesize record3Progress;
@synthesize record4Main;
@synthesize record4Progress;
@synthesize record5Main;
@synthesize record5Progress;
@synthesize record6Main;
@synthesize record6Progress;
@synthesize record7Main;
@synthesize record7Progress;
@synthesize record8Main;
@synthesize record8Progress;
@synthesize record9Main;
@synthesize record9Progress;

@synthesize recordNumber1;
@synthesize recordNumber2;
@synthesize recordNumber3;
@synthesize recordNumber4;
@synthesize recordNumber5;
@synthesize recordNumber6;
@synthesize recordNumber7;
@synthesize recordNumber8;
@synthesize recordNumber9;

@synthesize wd1Main;
@synthesize wd1Progress;
@synthesize wd1Message;
@synthesize recordWD1;
@synthesize playWD1;
@synthesize deleteWD1;

@synthesize wd2Main;
@synthesize wd2Progress;
@synthesize wd2Message;
@synthesize recordWD2;
@synthesize playWD2;
@synthesize deleteWD2;

@synthesize wd3Main;
@synthesize wd3Progress;
@synthesize wd3Message;
@synthesize recordWD3;
@synthesize playWD3;
@synthesize deleteWD3;

@synthesize wd4Main;
@synthesize wd4Progress;
@synthesize wd4Message;
@synthesize recordWD4;
@synthesize playWD4;
@synthesize deleteWD4;

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

- (IBAction)buttonRecord1:(id)sender {
    [self buttonRecordN:1];
}


- (IBAction)buttonPlay1:(id)sender {
    [self buttonPlayN:1];
}

- (IBAction)buttonDelete1:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber11"];
    [buttonRecord1 setEnabled:YES];
    [buttonPlay1  setEnabled:NO];
    [buttonDelete1 setEnabled:NO];
    [recordNumber1 setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)buttonRecord2:(id)sender {
    [self buttonRecordN:2];
}

- (IBAction)buttonPlay2:(id)sender {
    [self buttonPlayN:2];
}

- (IBAction)buttonDelete2:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber22"];
    [buttonRecord2 setEnabled:YES];
    [buttonPlay2  setEnabled:NO];
    [buttonDelete2 setEnabled:NO];
    [recordNumber2 setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)buttonRecord3:(id)sender {
    [self buttonRecordN:3];
}

- (IBAction)buttonPlay3:(id)sender {
    [self buttonPlayN:3];
}

- (IBAction)buttonDelete3:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber33"];
    [buttonRecord3 setEnabled:YES];
    [buttonPlay3  setEnabled:NO];
    [buttonDelete3 setEnabled:NO];
    [recordNumber3 setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)buttonRecord4:(id)sender {
    [self buttonRecordN:4];
}

- (IBAction)buttonPlay4:(id)sender {
    [self buttonPlayN:4];
}

- (IBAction)buttonDelete4:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber44"];
    [buttonRecord4 setEnabled:YES];
    [buttonPlay4  setEnabled:NO];
    [buttonDelete4 setEnabled:NO];
    [recordNumber4 setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)buttonRecord5:(id)sender {
    [self buttonRecordN:5];
}

- (IBAction)buttonPlay5:(id)sender {
    [self buttonPlayN:5];
}

- (IBAction)buttonDelete5:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber55"];
    [buttonRecord5 setEnabled:YES];
    [buttonPlay5  setEnabled:NO];
    [buttonDelete5 setEnabled:NO];
    [recordNumber5 setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)buttonRecord6:(id)sender {
    [self buttonRecordN:6];
}

- (IBAction)buttonPlay6:(id)sender {
    [self buttonPlayN:6];
}

- (IBAction)buttonDelete6:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber22"];
    [buttonRecord6 setEnabled:YES];
    [buttonPlay6  setEnabled:NO];
    [buttonDelete6 setEnabled:NO];
    [recordNumber6 setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)buttonRecord7:(id)sender {
    [self buttonRecordN:7];
}

- (IBAction)buttonPlay7:(id)sender {
    [self buttonPlayN:7];
}

- (IBAction)buttonDelete7:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber77"];
    [buttonRecord7 setEnabled:YES];
    [buttonPlay7  setEnabled:NO];
    [buttonDelete7 setEnabled:NO];
    [recordNumber7 setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)buttonRecord8:(id)sender {
    [self buttonRecordN:8];
}

- (IBAction)buttonPlay8:(id)sender {
    [self buttonPlayN:8];
}

- (IBAction)buttonDelete8:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber88"];
    [buttonRecord8 setEnabled:YES];
    [buttonPlay8  setEnabled:NO];
    [buttonDelete8 setEnabled:NO];
    [recordNumber8 setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)buttonRecord9:(id)sender {
    [self buttonRecordN:9];
}

- (IBAction)buttonPlay9:(id)sender {
    [self buttonPlayN:9];
}

- (IBAction)buttonDelete9:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalNumber99"];
    [buttonRecord9 setEnabled:YES];
    [buttonPlay9  setEnabled:NO];
    [buttonDelete9 setEnabled:NO];
    [recordNumber9 setBackgroundColor:[UIColor clearColor]];
}

- (void)buttonRecordN:(NSInteger)recordNum {
    //Save recording path to preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *personalNumber, *personalNumKey;
    switch (recordNum) {
        case 1:
            personalNumber=@"personalNumber11.m4a";
            personalNumKey=@"personalNumber11";
            break;
        case 2:
            personalNumber=@"personalNumber22.m4a";
            personalNumKey=@"personalNumber22";
            break;
        case 3:
            personalNumber=@"personalNumber33.m4a";
            personalNumKey=@"personalNumber33";
            break;
        case 4:
            personalNumber=@"personalNumber44.m4a";
            personalNumKey=@"personalNumber44";
            break;
        case 5:
            personalNumber=@"personalNumber55.m4a";
            personalNumKey=@"personalNumber55";
            break;
        case 6:
            personalNumber=@"personalNumber66.m4a";
            personalNumKey=@"personalNumber66";
            break;
        case 7:
            personalNumber=@"personalNumber77.m4a";
            personalNumKey=@"personalNumber77";
            break;
        case 8:
            personalNumber=@"personalNumber88.m4a";
            personalNumKey=@"personalNumber88";
            break;
        case 9:
            personalNumber=@"personalNumber99.m4a";
            personalNumKey=@"personalNumber99";
            break;
    }
    
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               personalNumber,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    [prefs setURL:outputFileURL forKey:personalNumKey];
    [prefs synchronize];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder1 = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder1.delegate = self;
    recorder1.meteringEnabled = YES;
    [recorder1 prepareToRecord];
    
    [session setActive:YES error:nil];
    
    // Set that a personal message has been recorded, and its message 1
    // Disable buttons so that recording can finish uninterrupted
    [self disableSetupButtons];
    
    // Animation to give feedback on how long the recorder has got to run
    UITextView *recordLabel;
    UIView *recordProgress;
    switch (recordNum) {
        case 1:
            recordLabel=recordNumber1;
            recordProgress=record1Progress;
            break;
        case 2:
            recordLabel=recordNumber2;
            recordProgress=record2Progress;
            break;
        case 3:
            recordLabel=recordNumber3;
            recordProgress=record3Progress;
            break;
        case 4:
            recordLabel=recordNumber4;
            recordProgress=record4Progress;
            break;
        case 5:
            recordLabel=recordNumber5;
            recordProgress=record5Progress;
            break;
        case 6:
            recordLabel=recordNumber6;
            recordProgress=record6Progress;
            break;
        case 7:
            recordLabel=recordNumber7;
            recordProgress=record7Progress;
            break;
        case 8:
            recordLabel=recordNumber8;
            recordProgress=record8Progress;
            break;
        case 9:
            recordLabel=recordNumber9;
            recordProgress=record9Progress;
            break;
        default:
            break;
    }
    [recordLabel setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         [recordProgress setFrame:CGRectMake(386, 0, 0, 36)];
     }
                     completion:^(BOOL finished)
     {
         [recordProgress setFrame:CGRectMake(0, 0, 386, 36)];
     }];
    
    // Start recording
    [recorder1 recordForDuration:4];
}

- (void) buttonPlayN:(NSInteger)recordNum {
    // Animation to give feedback on how long the recorder has got to run
	//
    UITextView *recordLabel;
    UIView *recordProgress;
    switch (recordNum) {
        case 1:
            recordLabel=recordNumber1;
            recordProgress=record1Progress;
            break;
        case 2:
            recordLabel=recordNumber2;
            recordProgress=record2Progress;
            break;
        case 3:
            recordLabel=recordNumber3;
            recordProgress=record3Progress;
            break;
        case 4:
            recordLabel=recordNumber4;
            recordProgress=record4Progress;
            break;
        case 5:
            recordLabel=recordNumber5;
            recordProgress=record5Progress;
            break;
        case 6:
            recordLabel=recordNumber6;
            recordProgress=record6Progress;
            break;
        case 7:
            recordLabel=recordNumber7;
            recordProgress=record7Progress;
            break;
        case 8:
            recordLabel=recordNumber8;
            recordProgress=record8Progress;
            break;
        case 9:
            recordLabel=recordNumber9;
            recordProgress=record9Progress;
            break;
        default:
            break;
    }
    [recordLabel setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         [recordProgress setFrame:CGRectMake(386, 0, 0, 36)];
     }
                     completion:^(BOOL finished)
     {
         [recordProgress setFrame:CGRectMake(0, 0, 386, 36)];
     }];
    
    NSURL *temporaryRecFile;
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *personalNumKey;
    switch (recordNum) {
        case 1:
            personalNumKey=@"personalNumber11";
            break;
        case 2:
            personalNumKey=@"personalNumber22";
            break;
        case 3:
            personalNumKey=@"personalNumber33";
            break;
        case 4:
            personalNumKey=@"personalNumber44";
            break;
        case 5:
            personalNumKey=@"personalNumber55";
            break;
        case 6:
            personalNumKey=@"personalNumber66";
            break;
        case 7:
            personalNumKey=@"personalNumber77";
            break;
        case 8:
            personalNumKey=@"personalNumber88";
            break;
        case 9:
            personalNumKey=@"personalNumber99";
            break;
    }
    
    temporaryRecFile = [prefs URLForKey:personalNumKey];
    playerPersonal1 = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
    [playerPersonal1 setDelegate:self];
    [playerPersonal1 play];
    
	[self disableSetupButtons];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    [self enableSetupButtons];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	[self enableSetupButtons];
}

- (IBAction)recordWD1:(id)sender {
    [self buttonRecordWD:1];
}

- (IBAction)playWD1:(id)sender {
    [self buttonPlayWD:1];
}

- (IBAction)deleteWD1:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalMessage1"];
    [recordWD1  setEnabled:YES];
    [playWD1    setEnabled:NO];
    [deleteWD1  setEnabled:NO];
    [wd1Message setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)recordWD2:(id)sender {
    [self buttonRecordWD:2];
}

- (IBAction)playWD2:(id)sender {
    [self buttonPlayWD:2];
}

- (IBAction)deleteWD2:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalMessage2"];
    [recordWD2  setEnabled:YES];
    [playWD2    setEnabled:NO];
    [deleteWD2  setEnabled:NO];
    [wd2Message setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)recordWD3:(id)sender {
    [self buttonRecordWD:3];
}

- (IBAction)playWD3:(id)sender {
    [self buttonPlayWD:3];
}

- (IBAction)deleteWD3:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalMessage3"];
    [recordWD3  setEnabled:YES];
    [playWD3    setEnabled:NO];
    [deleteWD3  setEnabled:NO];
    [wd3Message setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)recordWD4:(id)sender {
    [self buttonRecordWD:4];
}

- (IBAction)playWD4:(id)sender {
    [self buttonPlayWD:4];
}

- (IBAction)deleteWD4:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalMessage4"];
    [recordWD4  setEnabled:YES];
    [playWD4    setEnabled:NO];
    [deleteWD4 setEnabled:NO];
    [wd4Message setBackgroundColor:[UIColor clearColor]];
}

- (void)buttonRecordWD:(NSInteger)recordNum {
    //Save recording path to preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *personalNumber, *personalNumKey;
    switch (recordNum) {
        case 1:
            personalNumber=@"personalMessage1.m4a";
            personalNumKey=@"personalMessage1";
            break;
        case 2:
            personalNumber=@"personalMessage2.m4a";
            personalNumKey=@"personalMessage2";
            break;
        case 3:
            personalNumber=@"personalMessage3.m4a";
            personalNumKey=@"personalMessage3";
            break;
        case 4:
            personalNumber=@"personalMessage4.m4a";
            personalNumKey=@"personalMessage4";
            break;
    }
    
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               personalNumber,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    [prefs setURL:outputFileURL forKey:personalNumKey];
    [prefs synchronize];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder1 = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder1.delegate = self;
    recorder1.meteringEnabled = YES;
    [recorder1 prepareToRecord];
    
    [session setActive:YES error:nil];
    
    // Set that a personal message has been recorded, and its message 1
    // Disable buttons so that recording can finish uninterrupted
    [self disableSetupButtons];
    
    // Animation to give feedback on how long the recorder has got to run
    UITextView *recordLabel;
    UIView *recordProgress;
    switch (recordNum) {
        case 1:
            recordLabel=wd1Message;
            recordProgress=wd1Progress;
            break;
        case 2:
            recordLabel=wd2Message;
            recordProgress=wd2Progress;
            break;
        case 3:
            recordLabel=wd3Message;
            recordProgress=wd3Progress;
            break;
        case 4:
            recordLabel=wd4Message;
            recordProgress=wd4Progress;
            break;
    }
    
    [recordLabel setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         [recordProgress setFrame:CGRectMake(100, 0, 0, 36)];
     }
                     completion:^(BOOL finished)
     {
         [recordProgress setFrame:CGRectMake(0, 0, 100, 36)];
     }];
    
    // Start recording
    [recorder1 recordForDuration:4];
}

- (void) buttonPlayWD:(NSInteger)recordNum {
    // Animation to give feedback on how long the recorder has got to run
    UITextView *recordLabel;
    UIView *recordProgress;
    switch (recordNum) {
        case 1:
            recordLabel=wd1Message;
            recordProgress=wd1Progress;
            break;
        case 2:
            recordLabel=wd2Message;
            recordProgress=wd2Progress;
            break;
        case 3:
            recordLabel=wd3Message;
            recordProgress=wd3Progress;
            break;
        case 4:
            recordLabel=wd4Message;
            recordProgress=wd4Progress;
            break;
        default:
            break;
    }
    [recordLabel setBackgroundColor:[UIColor clearColor]];
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         [recordProgress setFrame:CGRectMake(100, 0, 0, 36)];
     }
                     completion:^(BOOL finished)
     {
         [recordProgress setFrame:CGRectMake(0, 0, 100, 36)];
     }];
    [recordLabel setBackgroundColor:[UIColor clearColor]];
    
    NSURL *temporaryRecFile;
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *personalNumKey;
    switch (recordNum) {
        case 1:
            personalNumKey=@"personalMessage1";
            break;
        case 2:
            personalNumKey=@"personalMessage2";
            break;
        case 3:
            personalNumKey=@"personalMessage3";
            break;
        case 4:
            personalNumKey=@"personalMessage4";
            break;
    }
    
    temporaryRecFile = [prefs URLForKey:personalNumKey];
    playerPersonal1 = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
    [playerPersonal1 setDelegate:self];
    [playerPersonal1 play];
    
	[self disableSetupButtons];
}

- (void) disableSetupButtons {
    [buttonRecord1 setEnabled:NO];
    [buttonPlay1 setEnabled:NO];
    [buttonDelete1 setEnabled:NO];
    [buttonRecord2 setEnabled:NO];
    [buttonPlay2 setEnabled:NO];
    [buttonDelete2 setEnabled:NO];
    [buttonRecord3 setEnabled:NO];
    [buttonPlay3 setEnabled:NO];
    [buttonDelete3 setEnabled:NO];
    [buttonRecord4 setEnabled:NO];
    [buttonPlay4 setEnabled:NO];
    [buttonDelete4 setEnabled:NO];
    [buttonRecord5 setEnabled:NO];
    [buttonPlay5 setEnabled:NO];
    [buttonDelete5 setEnabled:NO];
    [buttonRecord6 setEnabled:NO];
    [buttonPlay6 setEnabled:NO];
    [buttonDelete6 setEnabled:NO];
    [buttonRecord7 setEnabled:NO];
    [buttonPlay7 setEnabled:NO];
    [buttonDelete7 setEnabled:NO];
    [buttonRecord8 setEnabled:NO];
    [buttonPlay8 setEnabled:NO];
    [buttonDelete8 setEnabled:NO];
    [buttonRecord9 setEnabled:NO];
    [buttonPlay9 setEnabled:NO];
    [buttonDelete9 setEnabled:NO];
    [recordWD1 setEnabled:NO];
    [playWD1 setEnabled:NO];
    [deleteWD1 setEnabled:NO];
    [recordWD2 setEnabled:NO];
    [playWD2 setEnabled:NO];
    [deleteWD2 setEnabled:NO];
    [recordWD3 setEnabled:NO];
    [playWD3 setEnabled:NO];
    [deleteWD3 setEnabled:NO];
    [recordWD4 setEnabled:NO];
    [playWD4 setEnabled:NO];
    [deleteWD4 setEnabled:NO];
    [goButton setEnabled:NO];
}

- (void) enableSetupButtons {
    NSURL *temporaryRecFile;
    
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    temporaryRecFile = [prefs URLForKey:@"personalNumber11"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay1 setEnabled:YES];
        [buttonDelete1 setEnabled:YES];
        [recordNumber1 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay1 setEnabled:NO];
        [buttonDelete1 setEnabled:NO];
        [recordNumber1 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalNumber22"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay2 setEnabled:YES];
        [buttonDelete2 setEnabled:YES];
        [recordNumber2 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay2 setEnabled:NO];
        [buttonDelete2 setEnabled:NO];
        [recordNumber2 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalNumber33"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay3 setEnabled:YES];
        [buttonDelete3 setEnabled:YES];
        [recordNumber3 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay3 setEnabled:NO];
        [buttonDelete3 setEnabled:NO];
        [recordNumber3 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalNumber44"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay4 setEnabled:YES];
        [buttonDelete4 setEnabled:YES];
        [recordNumber4 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay4 setEnabled:NO];
        [buttonDelete4 setEnabled:NO];
        [recordNumber4 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalNumber55"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay5 setEnabled:YES];
        [buttonDelete5 setEnabled:YES];
        [recordNumber5 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay5 setEnabled:NO];
        [buttonDelete5 setEnabled:NO];
        [recordNumber5 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalNumber66"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay6 setEnabled:YES];
        [buttonDelete6 setEnabled:YES];
        [recordNumber6 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay6 setEnabled:NO];
        [buttonDelete6 setEnabled:NO];
        [recordNumber6 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalNumber77"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay7 setEnabled:YES];
        [buttonDelete7 setEnabled:YES];
        [recordNumber7 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay7 setEnabled:NO];
        [buttonDelete7 setEnabled:NO];
        [recordNumber7 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalNumber88"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay8 setEnabled:YES];
        [buttonDelete8 setEnabled:YES];
        [recordNumber8 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay8 setEnabled:NO];
        [buttonDelete8 setEnabled:NO];
        [recordNumber8 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalNumber99"];
    if (temporaryRecFile!=NULL) {
        [buttonPlay9 setEnabled:YES];
        [buttonDelete9 setEnabled:YES];
        [recordNumber9 setBackgroundColor:[UIColor greenColor]];
    } else {
        [buttonPlay9 setEnabled:NO];
        [buttonDelete9 setEnabled:NO];
        [recordNumber9 setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalMessage1"];
    if (temporaryRecFile!=NULL) {
        [playWD1 setEnabled:YES];
        [deleteWD1 setEnabled:YES];
        [wd1Message setBackgroundColor:[UIColor greenColor]];
    } else {
        [playWD1 setEnabled:NO];
        [deleteWD1 setEnabled:NO];
        [wd1Message setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalMessage2"];
    if (temporaryRecFile!=NULL) {
        [playWD2 setEnabled:YES];
        [deleteWD2 setEnabled:YES];
        [wd2Message setBackgroundColor:[UIColor greenColor]];
    } else {
        [playWD2 setEnabled:NO];
        [deleteWD2 setEnabled:NO];
        [wd2Message setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalMessage3"];
    if (temporaryRecFile!=NULL) {
        [playWD3 setEnabled:YES];
        [deleteWD3 setEnabled:YES];
        [wd3Message setBackgroundColor:[UIColor greenColor]];
    } else {
        [playWD3 setEnabled:NO];
        [deleteWD3 setEnabled:NO];
        [wd3Message setBackgroundColor:[UIColor clearColor]];
    }
    
    //Load recording path from preferences
    temporaryRecFile = [prefs URLForKey:@"personalMessage4"];
    if (temporaryRecFile!=NULL) {
        [playWD4 setEnabled:YES];
        [deleteWD4 setEnabled:YES];
        [wd4Message setBackgroundColor:[UIColor greenColor]];
    } else {
        [playWD4 setEnabled:NO];
        [deleteWD4 setEnabled:NO];
        [wd4Message setBackgroundColor:[UIColor clearColor]];
    }
	
	[buttonRecord1 setEnabled:YES];
    [buttonRecord2 setEnabled:YES];
    [buttonRecord3 setEnabled:YES];
    [buttonRecord4 setEnabled:YES];
    [buttonRecord5 setEnabled:YES];
    [buttonRecord6 setEnabled:YES];
    [buttonRecord7 setEnabled:YES];
    [buttonRecord8 setEnabled:YES];
    [buttonRecord9 setEnabled:YES];
    [recordWD1 setEnabled:YES];
    [recordWD2 setEnabled:YES];
    [recordWD3 setEnabled:YES];
    [recordWD4 setEnabled:YES];
	
	[goButton setEnabled:YES];
}

@end
