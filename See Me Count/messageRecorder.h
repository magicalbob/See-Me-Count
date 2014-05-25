//
//  messageRecorder.h
//  See Me Choose
//
//  Created by Ian on 18/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "setupGame.h"

// Proportion of text for message, the buttons and padding, compared to the size of the rect of the message recorder
#define PROP_PADDING_X 0.01
#define PROP_PADDING_Y 0.1
#define PROP_MESSAGE_WIDTH 0.7
#define PROP_BUTTON_WIDTH 0.1

@interface messageRecorder : UIView {
	UIView *contView;
	NSString *labelDefault;
	NSString *messageName;
	UIView *panelRec;
	UITextField *uiMessage;
	NSString *labelName;
	AVAudioRecorder *avRec;
	AVAudioPlayer *avPlay;
	CGRect savePosition;
	UIView *maskView;
	int keyboardShowing;
	id mySelf;
	id owner;
}

- (id)initWithFrame:(CGRect)frame
			  owner:(id)vOwner
	  containerView:(UIView *)containerView
	   labelDefault:(NSString *)vLabelDefault
		  labelName:(NSString *)vLabelName
		messageName:(NSString *)vMessageName;
- (id)initWithFrame:(CGRect)frame
			  owner:(id)vOwner
	  containerView:(UIView *)containerView
	   labelDefault:(NSString *)vLabelDefault
		messageName:(NSString *)vMessageName;
- (void)disableButtons;
- (void)enableButtons;
- (void)textAlignment:(NSTextAlignment)centerText;
@property UIButton *uiRecord;
@property UIButton *uiPlay;
@property UIButton *uiDelete;
@end
