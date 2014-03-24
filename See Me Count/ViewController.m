//
//  ViewController.m
//  See Me Count
//
//  Created by Ian on 30/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    AVAudioRecorder *recorder1;
    AVAudioPlayer *playerPersonal1;
	AVAudioPlayer *playerSuccess;
    AVAudioPlayer *playerIntro;
    AVAudioPlayer *playerWellDone;
}

@end

@implementation ViewController

@synthesize number1;
@synthesize number2;
@synthesize number3;
@synthesize number4;
@synthesize number5;
@synthesize number6;
@synthesize number7;
@synthesize number8;
@synthesize number9;

@synthesize picture1;
@synthesize picture2;
@synthesize picture3;
@synthesize picture4;
@synthesize picture5;
@synthesize picture6;
@synthesize picture7;
@synthesize picture8;
@synthesize picture9;

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

@synthesize infoViewSess;
@synthesize infoViewGame;
@synthesize infoViewSessByGames;
@synthesize infoViewRightWrong;

- (void) myInit {
    
    char randPicNameC[8];
    NSString *cPath;
    int lastPic;
    
    /* Randomise the timer, and select which of the buttons will have the correct picture */
    srand((unsigned int)time(NULL));
    
    
    
    lastPic=correctNum;
    do {
        correctNum=rand() % 9 + 1;
    } while (correctNum==lastPic);
    
    sprintf(randPicNameC,"Pic%01d",correctNum);
    NSString *randPicName = [NSString stringWithUTF8String:randPicNameC];
    
    cPath = [[NSBundle mainBundle] pathForResource:randPicName ofType:@"jpg"];
    
    picture1.image = [UIImage imageWithContentsOfFile:cPath];
    picture1.hidden=false;
    
    if (correctNum>1) {
        picture2.image = [UIImage imageWithContentsOfFile:cPath];
        picture2.hidden=false;
    } else {
        picture2.hidden=true;
    }
    
    if (correctNum>2) {
        picture3.image = [UIImage imageWithContentsOfFile:cPath];
        picture3.hidden=false;
    } else {
        picture3.hidden=true;
    }
    
    if (correctNum>3) {
        picture4.image = [UIImage imageWithContentsOfFile:cPath];
        picture4.hidden=false;
    } else {
        picture4.hidden=true;
    }
    
    if (correctNum>4) {
        picture5.image = [UIImage imageWithContentsOfFile:cPath];
        picture5.hidden=false;
    } else {
        picture5.hidden=true;
    }
    
    if (correctNum>5) {
        picture6.image = [UIImage imageWithContentsOfFile:cPath];
        picture6.hidden=false;
    } else {
        picture6.hidden=true;
    }
    
    if (correctNum>6) {
        picture7.image = [UIImage imageWithContentsOfFile:cPath];
        picture7.hidden=false;
    } else {
        picture7.hidden=true;
    }
    
    if (correctNum>7) {
        picture8.image = [UIImage imageWithContentsOfFile:cPath];
        picture8.hidden=false;
    } else {
        picture8.hidden=true;
    }
    
    if (correctNum>8) {
        picture9.image = [UIImage imageWithContentsOfFile:cPath];
        picture9.hidden=false;
    } else {
        picture9.hidden=true;
    }
    
    [number1 setEnabled:NO];
    [number2 setEnabled:NO];
    [number3 setEnabled:NO];
    [number4 setEnabled:NO];
    [number5 setEnabled:NO];
    [number6 setEnabled:NO];
    [number7 setEnabled:NO];
    [number8 setEnabled:NO];
    [number9 setEnabled:NO];
    
    NSString *pathIntro;
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *personalNumKey;
    
    switch (correctNum) {
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
    
    if ([prefs URLForKey:personalNumKey]!=NULL) {
        [self buttonPlayN:correctNum isPlaySetup:0];
    } else {
        char randIntroNameC[10];
        
        sprintf(randIntroNameC,"introP%01d",correctNum);
        
        NSString *randIntroName = [NSString stringWithUTF8String:randIntroNameC];
        
        pathIntro = [[NSBundle mainBundle] pathForResource:randIntroName ofType:@"mp3"];
        
        playerIntro = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathIntro] error:nil];
        
        [playerIntro setDelegate:self];
        [playerIntro play];
    }
    
    playIntro=1;

	// Get new game ID details for storing in database
	currGameID++;
}

- (void)mySuccess {
    /* Play the success tune */
    currentTune=1;
    [number1 setEnabled:NO];
    [number2 setEnabled:NO];
    [number3 setEnabled:NO];
    [number4 setEnabled:NO];
    [number5 setEnabled:NO];
    [number6 setEnabled:NO];
    [number7 setEnabled:NO];
    [number8 setEnabled:NO];
    [number9 setEnabled:NO];
	[self playSuccessTune];
    [self myAnimationOne];
}



- (void) myAnimationOne
{
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         if (correctNum!=1) {
             [number1 setAlpha:0.0f];
         }
         if (correctNum!=2) {
             [number2 setAlpha:0.0f];
         }
         if (correctNum!=3) {
             [number3 setAlpha:0.0f];
         }
         if (correctNum!=4) {
             [number4 setAlpha:0.0f];
         }
         if (correctNum!=5) {
             [number5 setAlpha:0.0f];
         }
         if (correctNum!=6) {
             [number6 setAlpha:0.0f];
         }
         if (correctNum!=7) {
             [number7 setAlpha:0.0f];
         }
         if (correctNum!=8) {
             [number8 setAlpha:0.0f];
         }
         if (correctNum!=9) {
             [number9 setAlpha:0.0f];
         }
         
         [picture1 setAlpha:0.5f];
         if (correctNum>1) {
             [picture2 setAlpha:0.5f];
         }
         if (correctNum>2) {
             [picture3 setAlpha:0.5f];
         }
         if (correctNum>3) {
             [picture4 setAlpha:0.5f];
         }
         if (correctNum>4) {
             [picture5 setAlpha:0.5f];
         }
         if (correctNum>5) {
             [picture6 setAlpha:0.5f];
         }
         if (correctNum>6) {
             [picture7 setAlpha:0.5f];
         }
         if (correctNum>7) {
             [picture8 setAlpha:0.5f];
         }
         if (correctNum>8) {
             [picture9 setAlpha:0.5f];
         }
     }
                     completion:^(BOOL finished)
     {
     }];
    
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         switch (correctNum) {
             case 1:
                 [number1 setFrame:CGRectMake(482, 354, 100, 100)];
                 number1.transform = CGAffineTransformScale(number1.transform,4,4);
                 break;
             case 2:
                 [number2 setFrame:CGRectMake(482, 354, 100, 100)];
                 number2.transform = CGAffineTransformScale(number2.transform,4,4);
                 break;
             case 3:
                 [number3 setFrame:CGRectMake(482, 354, 100, 100)];
                 number3.transform = CGAffineTransformScale(number3.transform,4,4);
                 break;
             case 4:
                 [number4 setFrame:CGRectMake(482, 354, 100, 100)];
                 number4.transform = CGAffineTransformScale(number4.transform,4,4);
                 break;
             case 5:
                 [number5 setFrame:CGRectMake(482, 354, 100, 100)];
                 number5.transform = CGAffineTransformScale(number5.transform,4,4);
                 break;
             case 6:
                 [number6 setFrame:CGRectMake(482, 354, 100, 100)];
                 number6.transform = CGAffineTransformScale(number6.transform,4,4);
                 break;
             case 7:
                 [number7 setFrame:CGRectMake(482, 354, 100, 100)];
                 number7.transform = CGAffineTransformScale(number7.transform,4,4);
                 break;
             case 8:
                 [number8 setFrame:CGRectMake(482, 354, 100, 100)];
                 number8.transform = CGAffineTransformScale(number8.transform,4,4);
                 break;
             case 9:
                 [number9 setFrame:CGRectMake(482, 354, 100, 100)];
                 number9.transform = CGAffineTransformScale(number9.transform,4,4);
                 break;
             default:
                 break;
         }
     }
                     completion:^(BOOL finished)
     {
     }];
}

- (void) myAnimationTwo
{
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
     }
                     completion:^(BOOL finished)
     {
     }];
}

- (void) myAnimationThree
{
    [UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         if (correctNum!=1) {
             [number1 setAlpha:1.0f];
         }
         if (correctNum!=2) {
             [number2 setAlpha:1.0f];
         }
         if (correctNum!=3) {
             [number3 setAlpha:1.0f];
         }
         if (correctNum!=4) {
             [number4 setAlpha:1.0f];
         }
         if (correctNum!=5) {
             [number5 setAlpha:1.0f];
         }
         if (correctNum!=6) {
             [number6 setAlpha:1.0f];
         }
         if (correctNum!=7) {
             [number7 setAlpha:1.0f];
         }
         if (correctNum!=8) {
             [number8 setAlpha:1.0f];
         }
         if (correctNum!=9) {
             [number9 setAlpha:1.0f];
         }
         
         switch (correctNum) {
             case 1:
                 [number1 setFrame:CGRectMake(475, 1, 100, 100)];
                 break;
             case 2:
                 [number2 setFrame:CGRectMake(720, 51, 100, 100)];
                 break;
             case 3:
                 [number3 setFrame:CGRectMake(933, 262, 100, 100)];
                 break;
             case 4:
                 [number4 setFrame:CGRectMake(848, 560, 100, 100)];
                 break;
             case 5:
                 [number5 setFrame:CGRectMake(597, 682, 100, 100)];
                 break;
             case 6:
                 [number6 setFrame:CGRectMake(352, 682, 100, 100)];
                 break;
             case 7:
                 [number7 setFrame:CGRectMake(99, 560, 100, 100)];
                 break;
             case 8:
                 [number8 setFrame:CGRectMake(14, 262, 100, 100)];
                 break;
             case 9:
                 [number9 setFrame:CGRectMake(228, 51, 100, 100)];
                 break;
             default:
                 break;
         }
         
         [picture1 setAlpha:1.0f];
         if (correctNum>1) {
             [picture2 setAlpha:1.0f];
         }
         if (correctNum>2) {
             [picture3 setAlpha:1.0f];
         }
         if (correctNum>3) {
             [picture4 setAlpha:1.0f];
         }
         if (correctNum>4) {
             [picture5 setAlpha:1.0f];
         }
         if (correctNum>5) {
             [picture6 setAlpha:1.0f];
         }
         if (correctNum>6) {
             [picture7 setAlpha:1.0f];
         }
         if (correctNum>7) {
             [picture8 setAlpha:1.0f];
         }
         if (correctNum>8) {
             [picture9 setAlpha:1.0f];
         }
     }
                     completion:^(BOOL finished)
     {
     }];
}

/*
- (void) stopAllTasks {
    if ([playerPersonal1 isPlaying]) {
        [playerPersonal1 stop];
    }
    if ([playerCongratulations isPlaying]) {
        [playerCongratulations stop];
    }
    if ([playerIntro isPlaying]){
        [playerIntro stop];
    }
    if ([playerWellDone isPlaying]) {
        [playerWellDone stop];
    }
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
         [settingsView setHidden:FALSE];
     }
                     completion:^(BOOL finished)
     {
     }];
    
}
*/

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
	
	// Set the path up for the player that's going to play the default Well Done message
    NSString *pathWellDone;
    pathWellDone = [[NSBundle mainBundle] pathForResource:@"WellDone" ofType:@"mp3"];
    playerWellDone = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathWellDone] error:nil];
    
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
	
	// Set up images
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
    [self enableSetupButtons];
    
    playSetup=0;
	currGameID=0;
}

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
/*
-(NSInteger) newGameID:(NSInteger)sessID {
	NSInteger oldSessID=[self singleNumQuery:[NSString stringWithFormat:@"select max(gameID) from useEvent where sessID=%ld",(long)sessID]];
	
	const char *insert_sql="insert into gameDetail (sessID,gameID,startDate,startTime) values (?,?,?,?)";
	sqlite3_stmt *statement;
	struct sqlite3 *sqlHandle = [self openDB];
	
	NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
	[DateFormatter setDateFormat:@"yyyyMMdd"];
	NSString *wDate=[DateFormatter stringFromDate:[NSDate date]];
	[DateFormatter setDateFormat:@"hhmmss"];
	NSString *wTime=[DateFormatter stringFromDate:[NSDate date]];
	
	if (sqlHandle!=NULL) {
		if (sqlite3_prepare_v2(sqlHandle, insert_sql, -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(statement,1,(int)currSessID);
			sqlite3_bind_int(statement,2,(int)currGameID);
			sqlite3_bind_text(statement,3,[wDate UTF8String],-1,SQLITE_TRANSIENT);
			sqlite3_bind_text(statement,4,[wTime UTF8String],-1,SQLITE_TRANSIENT);
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}
		sqlite3_close(sqlHandle);
	}

	return ++oldSessID;
}
*/
- (void) logNumPress:(NSInteger)numPressed {
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

- (struct sqlite3 *) openDB {
//	NSString *dbFile;
//	dbFile=[[NSBundle mainBundle] pathForResource:@"see.me.count" ofType:@"db" ];
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

- (int) numSessions {
	return [self singleNumQuery:@"select count(*) from (select sessID from useEvent group by sessID)"];
}

- (int) numGames {
	return [self singleNumQuery:@"select count(gameID) from useEvent"];
}
/*
- (NSMutableArray *) sessionsByGames {
	const char *query_sql="select eventDate, sessID, count(eventDate) from useEvent group by eventDate, sessID";
	sqlite3_stmt *statement;
	struct sqlite3 *sqlHandle = [self openDB];
	
	NSMutableArray *retDataX = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retDataY = [NSMutableArray arrayWithObjects:nil count:0];
	
	if (sqlHandle!=NULL) {
		if (sqlite3_prepare_v2(sqlHandle, query_sql, -1, &statement, NULL) == SQLITE_OK) {
				while  (sqlite3_step(statement)==SQLITE_ROW) {
					NSString *dateValue = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement,0)];
					NSString *monthNo = [dateValue substringWithRange:NSMakeRange(4, 2)];
					NSString *dayNo = [dateValue substringWithRange:NSMakeRange(6, 2)];
					NSString *axisYvalue;
					switch ([monthNo intValue]) {
						case 1:
							axisYvalue=[NSString stringWithFormat:@"%@-Jan / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 2:
							axisYvalue=[NSString stringWithFormat:@"%@-Feb / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 3:
							axisYvalue=[NSString stringWithFormat:@"%@-Mar / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 4:
							axisYvalue=[NSString stringWithFormat:@"%@-Apr / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 5:
							axisYvalue=[NSString stringWithFormat:@"%@-May / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 6:
							axisYvalue=[NSString stringWithFormat:@"%@-Jun / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 7:
							axisYvalue=[NSString stringWithFormat:@"%@-Jul / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 8:
							axisYvalue=[NSString stringWithFormat:@"%@-Aug / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 9:
							axisYvalue=[NSString stringWithFormat:@"%@-Sep / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 10:
							axisYvalue=[NSString stringWithFormat:@"%@-Oct / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 11:
							axisYvalue=[NSString stringWithFormat:@"%@-Nov / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						case 12:
							axisYvalue=[NSString stringWithFormat:@"%@-Dec / %@",dayNo,[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,1)]];
							break;
						default:
							NSLog(@"What month? %d", [monthNo intValue]);
					}
					[retDataX addObject:axisYvalue];
					[retDataY addObject:[NSString stringWithFormat:@"%d",sqlite3_column_int(statement,2)]];
				}
		}
		sqlite3_finalize(statement);
		sqlite3_close(sqlHandle);
	}
	
	NSMutableArray *retData = [NSMutableArray arrayWithObjects:nil count:0];
	[retData addObject:retDataX];
	[retData addObject:retDataY];
	
	return retData;
}
*/

- (NSMutableArray *) gamesInSession:(NSInteger)daysToDisplay offsetDay:(NSInteger)offsetDay {
	NSMutableArray *retDataX = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retDataY1 = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retDataY2 = [NSMutableArray arrayWithObjects:nil count:0];

	const char *query_sql="select sd.sessDate, (select count(*) from useevent ue where ue.eventDate = sd.sessDate and numPressed!=numCorrect), (select count(*) from useevent ue where ue.eventDate = sd.sessDate and numPressed=numCorrect)  from sessdetail sd group by sessdate";
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

//	if (daysToDisplay < [retDataX count]) {
//		retData=[self trimDataByDays:retData numItems:daysToDisplay offsetItem:offsetDay];
//	}
	
	return retData;
}

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

- (double) avgGoesToGetRight {
	int totalNumRight = [self singleNumQuery:@"select count(*) from useEvent where numPressed=numCorrect"];
	int totalNum = [self singleNumQuery:@"select count(sessID) from useEvent"];
		
	return totalNum / totalNumRight;
}

- (IBAction)showInfo:(id)sender {
	[infoView setHidden:NO];
	
	[self updateSessions];
	[self updateGames];
	[self showSessionsByGames];
	[self showGamesInSession];
}

- (IBAction)closeInfo:(id)sender {
	[infoView setHidden:YES];
}

- (void) updateSessions {
	digitalDisplay *myDig1 __attribute__((unused)) = [[digitalDisplay alloc] initWithFrame:CGRectMake(112, 20, 90, 112) containingView:infoView digitImages:myDigImages numberValue:[self numSessions] label:@"Number of times played"];
}

- (void) updateGames {
	digitalDisplay *myDig1 __attribute__((unused)) = [[digitalDisplay alloc] initWithFrame:CGRectMake(254, 20, 90, 112) containingView:infoView digitImages:myDigImages numberValue:[self numGames] label:@"Number of games played"];

}

- (void) writeHeading:(NSString *)text rect:(CGRect)rect containerView:(UIView *)containerView colour:(UIColor*)colour {
	UILabel *textLabel;
	
	textLabel = [[UILabel alloc] initWithFrame:rect];
	[textLabel setText:text];
	textLabel.textColor=colour;
	textLabel.font=[UIFont fontWithName:@"ArialMT" size:24];
	[containerView addSubview:textLabel];
	[containerView bringSubviewToFront:textLabel];

}

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
    [self enableSetupButtons];
    [number1 setAlpha:0.0f];
    [number2 setAlpha:0.0f];
    [number3 setAlpha:0.0f];
    [number4 setAlpha:0.0f];
    [number5 setAlpha:0.0f];
    [number6 setAlpha:0.0f];
    [number7 setAlpha:0.0f];
    [number8 setAlpha:0.0f];
    [number9 setAlpha:0.0f];
    [settingsView setHidden:FALSE];
	[infoView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)number1:(id)sender {
	[self logNumPress:1];
    if (correctNum==1) {
        [self mySuccess];
    }
}

- (IBAction)number2:(id)sender {
	[self logNumPress:2];
    if (correctNum==2) {
        [self mySuccess];
    }
}

- (IBAction)number3:(id)sender {
	[self logNumPress:3];
    if (correctNum==3) {
        [self mySuccess];
    }
}

- (IBAction)number4:(id)sender {
	[self logNumPress:4];
    if (correctNum==4) {
        [self mySuccess];
    }
}

- (IBAction)number5:(id)sender {
	[self logNumPress:5];
    if (correctNum==5) {
        [self mySuccess];
    }
}

- (IBAction)number6:(id)sender {
	[self logNumPress:6];
    if (correctNum==6) {
        [self mySuccess];
    }
}

- (IBAction)number7:(id)sender {
	[self logNumPress:7];
    if (correctNum==7) {
        [self mySuccess];
    }
}

- (IBAction)number8:(id)sender {
	[self logNumPress:8];
    if (correctNum==8) {
        [self mySuccess];
    }
}

- (IBAction)number9:(id)sender {
	[self logNumPress:9];
    if (correctNum==9) {
        [self mySuccess];
    }
}

- (IBAction)goButton:(id)sender {
    [settingsView setHidden:TRUE];
	[self newSessID];
    [self myInit];
}

- (IBAction)buttonRecord1:(id)sender {
    [self buttonRecordN:1];
}


- (IBAction)buttonPlay1:(id)sender {
    [self buttonPlayN:1 isPlaySetup:YES];
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
    [self buttonPlayN:2 isPlaySetup:YES];
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
    [self buttonPlayN:3 isPlaySetup:YES];
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
    [self buttonPlayN:4 isPlaySetup:YES];
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
    [self buttonPlayN:5 isPlaySetup:YES];
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
    [self buttonPlayN:6 isPlaySetup:YES];
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
    [self buttonPlayN:7 isPlaySetup:YES];
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
    [self buttonPlayN:8 isPlaySetup:YES];
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
    [self buttonPlayN:9 isPlaySetup:YES];
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

- (void) buttonPlayN:(NSInteger)recordNum isPlaySetup:(NSInteger)isPlaySetup{
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
    [recordLabel setBackgroundColor:[UIColor clearColor]];
    
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
    
    if (isPlaySetup) {
        [self disableSetupButtons];
        playIntro=0;
        playSetup=1;
    } else {
        playSetup=0;
        playIntro=1;
    }
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    [self enableSetupButtons];
    
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

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (playIntro) {
        playIntro=0;
        [number1 setEnabled:YES];
        [number2 setEnabled:YES];
        [number3 setEnabled:YES];
        [number4 setEnabled:YES];
        [number5 setEnabled:YES];
        [number6 setEnabled:YES];
        [number7 setEnabled:YES];
        [number8 setEnabled:YES];
        [number9 setEnabled:YES];
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void)
         {
             [number1 setAlpha:1.0f];
             [number2 setAlpha:1.0f];
             [number3 setAlpha:1.0f];
             [number4 setAlpha:1.0f];
             [number5 setAlpha:1.0f];
             [number6 setAlpha:1.0f];
             [number7 setAlpha:1.0f];
             [number8 setAlpha:1.0f];
             [number9 setAlpha:1.0f];
         }
                         completion:^(BOOL finished)
         {
         }];
        
    } else if (playSetup) {
        playSetup=0;
        [self enableSetupButtons];
        
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
    } else {
        switch (currentTune) {
            case 1:
            {
                currentTune=2;
                
                int countPersonal = 0;
                int itemsPersonal[5];
                NSURL *temporaryRecFile1, *temporaryRecFile2, *temporaryRecFile3, *temporaryRecFile4, *temporaryRecFile;
                //Load recording path from preferences
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                temporaryRecFile1 = [prefs URLForKey:@"personalMessage1"];
                if (temporaryRecFile1!=NULL) {
                    itemsPersonal[++countPersonal]=1;
                }
                
                temporaryRecFile2 = [prefs URLForKey:@"personalMessage2"];
                if (temporaryRecFile2!=NULL) {
                    itemsPersonal[++countPersonal]=2;
                }
                
                temporaryRecFile3 = [prefs URLForKey:@"personalMessage3"];
                if (temporaryRecFile3!=NULL) {
                    itemsPersonal[++countPersonal]=3;
                }
                
                temporaryRecFile4 = [prefs URLForKey:@"personalMessage4"];
                if (temporaryRecFile4!=NULL) {
                    itemsPersonal[++countPersonal]=4;
                }
                
                if (countPersonal) {
                    int randPersonal = rand() % countPersonal + 1;
                    switch (itemsPersonal[randPersonal]) {
                        case 1:
                            temporaryRecFile=temporaryRecFile1;
                            break;
                        case 2:
                            temporaryRecFile=temporaryRecFile2;
                            break;
                        case 3:
                            temporaryRecFile=temporaryRecFile3;
                            break;
                        case 4:
                            temporaryRecFile=temporaryRecFile4;
                            break;
                    }
                    playerPersonal1 = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
                    [playerPersonal1 setDelegate:self];
                    [playerPersonal1 play];
                } else {
                    [playerWellDone setDelegate:self];
                    [playerWellDone play];
                }
                [self myAnimationTwo];
            }
                break;
            case 2:
            {
                currentTune=3;
/*
 [playerCongratulations play];
 */
				[self playSuccessTune];
				[self myAnimationThree];
            }
                break;
            case 3:
            {
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^(void)
                 {
                     [number1 setAlpha:0.0f];
                     [number2 setAlpha:0.0f];
                     [number3 setAlpha:0.0f];
                     [number4 setAlpha:0.0f];
                     [number5 setAlpha:0.0f];
                     [number6 setAlpha:0.0f];
                     [number7 setAlpha:0.0f];
                     [number8 setAlpha:0.0f];
                     [number9 setAlpha:0.0f];
                 }
                                 completion:^(BOOL finished)
                 {
                 }];
                [self myInit];
            }
                break;
        }
    }
}

- (IBAction)recordWD1:(id)sender {
    [self buttonRecordWD:1];
}

- (IBAction)playWD1:(id)sender {
    [self buttonPlayWD:1 isPlaySetup:1];
}

- (IBAction)deleteWD1:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalMessage1"];
    [recordWD1  setEnabled:YES];
    [playWD1    setEnabled:NO];
    [deleteWD1 setEnabled:NO];
    [wd1Message setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)recordWD2:(id)sender {
    [self buttonRecordWD:2];
}

- (IBAction)playWD2:(id)sender {
    [self buttonPlayWD:2 isPlaySetup:2];
}

- (IBAction)deleteWD2:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalMessage2"];
    [recordWD2  setEnabled:YES];
    [playWD2    setEnabled:NO];
    [deleteWD2 setEnabled:NO];
    [wd2Message setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)recordWD3:(id)sender {
    [self buttonRecordWD:3];
}

- (IBAction)playWD3:(id)sender {
    [self buttonPlayWD:3 isPlaySetup:3];
}

- (IBAction)deleteWD3:(id)sender {
    //Load recording path from preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"personalMessage3"];
    [recordWD3  setEnabled:YES];
    [playWD3    setEnabled:NO];
    [deleteWD3 setEnabled:NO];
    [wd3Message setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)recordWD4:(id)sender {
    [self buttonRecordWD:4];
}

- (IBAction)playWD4:(id)sender {
    [self buttonPlayWD:4 isPlaySetup:4];
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

- (void) buttonPlayWD:(NSInteger)recordNum isPlaySetup:(NSInteger)isPlaySetup{
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
    
    if (isPlaySetup) {
        [self disableSetupButtons];
        playIntro=0;
        playSetup=1;
    } else {
        playSetup=0;
        playIntro=1;
    }
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
}

- (void) playSuccessTune {
	// Set the path up for the players that are  going to play the congratulations tunes
    NSString *pathSuccess;
	
	int randTune;
	randTune=rand() % 5 + 1;
	switch (randTune) {
		case 1:
			pathSuccess = [[NSBundle mainBundle] pathForResource:@"success01" ofType:@"mp3"];
			playerSuccess = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathSuccess] error:nil];

			break;
		case 2:
			pathSuccess = [[NSBundle mainBundle] pathForResource:@"success02" ofType:@"mp3"];
			playerSuccess = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathSuccess] error:nil];

			break;
		case 3:
			pathSuccess = [[NSBundle mainBundle] pathForResource:@"success03" ofType:@"mp3"];
			playerSuccess = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathSuccess] error:nil];

			break;
		case 4:
			pathSuccess = [[NSBundle mainBundle] pathForResource:@"success04" ofType:@"mp3"];
			playerSuccess = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathSuccess] error:nil];
			
			break;
		case 5:
			pathSuccess = [[NSBundle mainBundle] pathForResource:@"success05" ofType:@"mp3"];
			playerSuccess = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathSuccess] error:nil];
			
			break;
		default:
			NSLog(@"Unknown success tune chosen: %d",randTune);
	}
	[playerSuccess setDelegate:self];
	[playerSuccess play];
}
@end
