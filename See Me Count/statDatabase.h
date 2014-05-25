//
//  statDatabase.h
//  See Me Count
//
//  Created by Ian on 25/05/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface statDatabase : NSObject
- (NSInteger) newSessID:(NSString *)dbFile;
- (void) logNumPress:(NSString *)dbFile
		  currSessID:(NSInteger)currSessID
		  currGameID:(NSInteger)currGameID
		  numPressed:(NSInteger)numPressed
		  correctNum:(NSInteger)correctNum;
- (NSMutableArray *) gamesInSession:(NSString *)dbFile
					  daysToDisplay:(NSInteger)daysToDisplay
						  offsetDay:(NSInteger)offsetDay;
- (int) numSessions:(NSString *)dbFile;
- (int) numGames:(NSString *)dbFile;
- (int) singleNumQuery:(NSString *)dbFile
			  sqlQuery:(NSString *)sqlQuery;
@end
