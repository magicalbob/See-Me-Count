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

- (IBAction)buttonRecord1:(id)sender;
- (IBAction)buttonPlay1:(id)sender;
- (IBAction)buttonDelete1:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord1;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay1;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete1;

- (IBAction)buttonRecord2:(id)sender;
- (IBAction)buttonPlay2:(id)sender;
- (IBAction)buttonDelete2:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord2;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay2;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete2;

- (IBAction)buttonRecord3:(id)sender;
- (IBAction)buttonPlay3:(id)sender;
- (IBAction)buttonDelete3:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord3;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay3;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete3;


- (IBAction)buttonRecord4:(id)sender;
- (IBAction)buttonPlay4:(id)sender;
- (IBAction)buttonDelete4:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord4;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay4;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete4;

- (IBAction)buttonRecord5:(id)sender;
- (IBAction)buttonPlay5:(id)sender;
- (IBAction)buttonDelete5:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord5;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay5;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete5;

- (IBAction)buttonRecord6:(id)sender;
- (IBAction)buttonPlay6:(id)sender;
- (IBAction)buttonDelete6:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord6;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay6;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete6;

- (IBAction)buttonRecord7:(id)sender;
- (IBAction)buttonPlay7:(id)sender;
- (IBAction)buttonDelete7:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord7;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay7;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete7;

- (IBAction)buttonRecord8:(id)sender;
- (IBAction)buttonPlay8:(id)sender;
- (IBAction)buttonDelete8:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord8;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay8;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete8;

- (IBAction)buttonRecord9:(id)sender;
- (IBAction)buttonPlay9:(id)sender;
- (IBAction)buttonDelete9:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord9;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay9;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete9;

- (IBAction)goButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIView *record1Main;
@property (weak, nonatomic) IBOutlet UIView *record1Progress;
@property (weak, nonatomic) IBOutlet UIView *record2Main;
@property (weak, nonatomic) IBOutlet UIView *record2Progress;
@property (weak, nonatomic) IBOutlet UIView *record3Main;
@property (weak, nonatomic) IBOutlet UIView *record3Progress;
@property (weak, nonatomic) IBOutlet UIView *record4Main;
@property (weak, nonatomic) IBOutlet UIView *record4Progress;
@property (weak, nonatomic) IBOutlet UIView *record5Main;
@property (weak, nonatomic) IBOutlet UIView *record5Progress;
@property (weak, nonatomic) IBOutlet UIView *record6Main;
@property (weak, nonatomic) IBOutlet UIView *record6Progress;
@property (weak, nonatomic) IBOutlet UIView *record7Main;
@property (weak, nonatomic) IBOutlet UIView *record7Progress;
@property (weak, nonatomic) IBOutlet UIView *record8Main;
@property (weak, nonatomic) IBOutlet UIView *record8Progress;
@property (weak, nonatomic) IBOutlet UIView *record9Main;
@property (weak, nonatomic) IBOutlet UIView *record9Progress;

@property (weak, nonatomic) IBOutlet UITextView *recordNumber1;
@property (weak, nonatomic) IBOutlet UITextView *recordNumber2;
@property (weak, nonatomic) IBOutlet UITextView *recordNumber3;
@property (weak, nonatomic) IBOutlet UITextView *recordNumber4;
@property (weak, nonatomic) IBOutlet UITextView *recordNumber5;
@property (weak, nonatomic) IBOutlet UITextView *recordNumber6;
@property (weak, nonatomic) IBOutlet UITextView *recordNumber7;
@property (weak, nonatomic) IBOutlet UITextView *recordNumber8;
@property (weak, nonatomic) IBOutlet UITextView *recordNumber9;



- (IBAction)recordWD1:(id)sender;
- (IBAction)playWD1:(id)sender;
- (IBAction)deleteWD1:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordWD1;
@property (weak, nonatomic) IBOutlet UIButton *playWD1;
@property (weak, nonatomic) IBOutlet UIButton *deleteWD1;
@property (weak, nonatomic) IBOutlet UIView *wd1Main;
@property (weak, nonatomic) IBOutlet UIView *wd1Progress;
@property (weak, nonatomic) IBOutlet UITextView *wd1Message;

- (IBAction)recordWD2:(id)sender;
- (IBAction)playWD2:(id)sender;
- (IBAction)deleteWD2:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordWD2;
@property (weak, nonatomic) IBOutlet UIButton *playWD2;
@property (weak, nonatomic) IBOutlet UIButton *deleteWD2;
@property (weak, nonatomic) IBOutlet UIView *wd2Main;
@property (weak, nonatomic) IBOutlet UIView *wd2Progress;
@property (weak, nonatomic) IBOutlet UITextView *wd2Message;

- (IBAction)recordWD3:(id)sender;
- (IBAction)playWD3:(id)sender;
- (IBAction)deleteWD3:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordWD3;
@property (weak, nonatomic) IBOutlet UIButton *playWD3;
@property (weak, nonatomic) IBOutlet UIButton *deleteWD3;
@property (weak, nonatomic) IBOutlet UIView *wd3Main;
@property (weak, nonatomic) IBOutlet UIView *wd3Progress;
@property (weak, nonatomic) IBOutlet UITextView *wd3Message;


- (IBAction)recordWD4:(id)sender;
- (IBAction)playWD4:(id)sender;
- (IBAction)deleteWD4:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordWD4;
@property (weak, nonatomic) IBOutlet UIButton *playWD4;
@property (weak, nonatomic) IBOutlet UIButton *deleteWD4;
@property (weak, nonatomic) IBOutlet UIView *wd4Main;
@property (weak, nonatomic) IBOutlet UIView *wd4Progress;
@property (weak, nonatomic) IBOutlet UITextView *wd4Message;

- (IBAction)showInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *infoView;

- (IBAction)closeInfo:(id)sender;

@end
