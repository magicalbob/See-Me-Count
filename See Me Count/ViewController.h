//
//  ViewController.h
//  See Me Count
//
//  Created by Ian on 30/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <sqlite3.h>
#import "playGame.h"
#import "setupGame.h"
#import "statDatabase.h"

@interface ViewController : UIViewController
							<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
	int currentTune;
	int viewGameOffset;
	NSInteger viewGameCount;
	NSInteger viewGameMaxY;
	NSString *dbFile;
	id gameSetup;
	
	AVAudioRecorder *recorder1;
    AVAudioPlayer *playerPersonal1;
	AVAudioPlayer *playerSuccess;
    AVAudioPlayer *playerIntro;
    AVAudioPlayer *playerWellDone;
	
	NSInteger lastNumber;
};

@property AVAudioPlayer *playerPersonal1;
@property AVAudioPlayer *playerSuccess;
@property AVAudioPlayer *playerIntro;
@property AVAudioPlayer *playerWellDone;
@property NSInteger currSessID;
@property NSInteger currGameID;
@property int currentTune;
@property ViewController *pGame;
@property NSString *dbFile;
@property NSInteger lastNumber;

- (void) newGame;
- (void) goButton;

@end
