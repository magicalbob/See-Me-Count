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
#import "digitalDisplay.h"
#import "ChartView.h"
#import "playGame.h"
#import "setupGame.h"

@interface ViewController : UIViewController
							<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
//	int correctNum;
	int currentTune;
	int viewGameOffset;
	NSInteger viewGameCount;
	NSInteger viewGameMaxY;
	NSMutableArray *sessGameDat;
	UIButton *goLeft, *goRight;
	NSInteger currSessID;
	NSInteger currGameID;
	NSString *dbFile;
	NSMutableArray *myDigImages;
	id gameSetup;
	
	AVAudioRecorder *recorder1;
    AVAudioPlayer *playerPersonal1;
	AVAudioPlayer *playerSuccess;
    AVAudioPlayer *playerIntro;
    AVAudioPlayer *playerWellDone;
};

@property AVAudioPlayer *playerPersonal1;
@property AVAudioPlayer *playerSuccess;
@property AVAudioPlayer *playerIntro;
@property AVAudioPlayer *playerWellDone;
@property int playIntro;
@property NSInteger currGameID;
@property int currentTune;
@property ViewController *pGame;

- (void) newGame;
- (void) logNumPress:(NSInteger)numPressed correctNum:(NSInteger)correctNum;

@property (weak, nonatomic) IBOutlet UIView *settingsView;

- (IBAction)showInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *infoView;

- (IBAction)closeInfo:(id)sender;

@end
