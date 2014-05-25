//
//  playGame.h
//  See Me Count
//
//  Created by Ian on 24/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface playGame : UIView <AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate> {
	UIButton *number[9];
	UIImageView *picture[9];
	UIView *panelPane;
	id owner;
	id mySelf;
	int correctNum;
	CGRect savedPosition;
	AVSpeechUtterance *vocaliseIntro;
	AVSpeechUtterance *vocaliseWellDone;
	AVAudioPlayer *playerSuccess;
	AVAudioPlayer *playerPersonal1;
    AVAudioPlayer *playerWellDone;
	NSTimer *aTimer;
	NSTimer *bTimer;
	id dataStat;
}
- (id)initWithFrame:(CGRect)frame owner:(id)vOwner;
@end
