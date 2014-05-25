//
//  statDatabase.m
//  See Me Count
//
//  Created by Ian on 25/05/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "statDatabase.h"

@implementation statDatabase


// Create a new session ID. A session starts when the Go button is pressed.
// Retrieve the most recent session ID from the database, add one to it and insert the new session ID back in to the
// database with current date & time.
- (NSInteger) newSessID:(NSString *)dbFile {
	NSInteger currSessID;
	NSInteger oldSessID=0;
	oldSessID=[self singleNumQuery:dbFile sqlQuery:@"select max(sessID) from useEvent"];
	currSessID=++oldSessID;
	
	char *insert_sql="insert into sessDetail (sessID, sessDate, sessTime) values (?,?,?)";
	
	NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
	[DateFormatter setDateFormat:@"yyyyMMdd"];
	NSString *wDate=[DateFormatter stringFromDate:[NSDate date]];
	[DateFormatter setDateFormat:@"hhmmss"];
	NSString *wTime=[DateFormatter stringFromDate:[NSDate date]];
	
	sqlite3_stmt *statement=nil;
	
	struct sqlite3 *sqlHandle=[self openDB:dbFile];
	
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
	
	return currSessID;
}

// Open the information database
- (struct sqlite3 *) openDB:(NSString *)dbFile {
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

// Log the number pressed and the correct number to press in the database
- (void) logNumPress:(NSString *)dbFile
		  currSessID:(NSInteger)currSessID
		  currGameID:(NSInteger)currGameID
		  numPressed:(NSInteger)numPressed
		  correctNum:(NSInteger)correctNum
{
	NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
	[DateFormatter setDateFormat:@"yyyyMMdd"];
	NSString *wDate=[DateFormatter stringFromDate:[NSDate date]];
	[DateFormatter setDateFormat:@"hhmmss"];
	NSString *wTime=[DateFormatter stringFromDate:[NSDate date]];
	
	char *insert_sql="insert into useEvent (sessID,gameID,eventDate,eventTime,numPressed,numCorrect) values (?,?,?,?,?,?)";
	sqlite3_stmt *statement=nil;
	
	struct sqlite3 *sqlHandle=[self openDB:dbFile];
	
	if (sqlHandle!=NULL) {
		if (sqlite3_prepare_v2(sqlHandle, insert_sql, -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(statement,1,(int)currSessID);
			sqlite3_bind_int(statement,2,(int)currGameID);
			sqlite3_bind_text(statement,3,[wDate UTF8String],-1,SQLITE_TRANSIENT);
			sqlite3_bind_text(statement,4,[wTime UTF8String],-1,SQLITE_TRANSIENT);
			sqlite3_bind_int(statement,5,(int)numPressed);
			sqlite3_bind_int(statement,6,(int)correctNum);
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}
		sqlite3_close(sqlHandle);
	}
}

// Query the datbase to get an array containing 3 arrays of the Dates for each session, the number of times the wrong button
// was pressed in each session and the number of times the right button was pressed in each session.
- (NSMutableArray *) gamesInSession:(NSString *)dbFile
					  daysToDisplay:(NSInteger)daysToDisplay
						  offsetDay:(NSInteger)offsetDay {
	NSMutableArray *retDataX = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retDataY1 = [NSMutableArray arrayWithObjects:nil count:0];
	NSMutableArray *retDataY2 = [NSMutableArray arrayWithObjects:nil count:0];
	
	const char *query_sql="select sd.sessDate, (select count(*) from useevent ue where ue.eventDate = sd.sessDate and numPressed!=numCorrect), (select count(*) from useevent ue where ue.eventDate = sd.sessDate and numPressed=numCorrect)  from sessdetail sd group by sessdate order by sessdate";
	sqlite3_stmt *statement;
	struct sqlite3 *sqlHandle = [self openDB:dbFile];
	
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

// Execute a supplied SQL statement that will return a numeric value
- (int) singleNumQuery:(NSString *)dbFile
			  sqlQuery:(NSString *)sqlQuery
{
	const char *query_sql=[sqlQuery UTF8String];
	sqlite3_stmt *statement;
	int retValue=0;
	struct sqlite3 *sqlHandle = [self openDB:dbFile];
	
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
- (int) numSessions:(NSString *)dbFile {
	return [self singleNumQuery:dbFile sqlQuery:@"select count(*) from (select sessID from useEvent group by sessID)"];
}

// Count the number of games logged in the database. A game is classed as being between the intro being played and the correct
// button being pressed.
- (int) numGames:(NSString *)dbFile {
	return [self singleNumQuery:dbFile sqlQuery:@"select count(gameID) from useEvent"];
}



@end
