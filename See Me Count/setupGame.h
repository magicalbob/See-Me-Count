//
//  setupGame.h
//  See Me Count
//
//  Created by Ian on 03/04/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "messageRecorder.h"

@interface setupGame : UIView <AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate> {
	id	owner;
	UIView *panelPane;
	UIButton *goButton;
}
- (id)initWithFrame:(CGRect)frame owner:(id)vOwner;
- (void) disableAllButtons;
@property NSMutableArray *numberSetup;
@end
