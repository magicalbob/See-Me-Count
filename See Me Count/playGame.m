//
//  playGame.m
//  See Me Count
//
//  Created by Ian on 24/03/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "playGame.h"

@implementation playGame

- (id)initWithFrame:(CGRect)frame owner:(id)vOwner
{
    self = [super initWithFrame:frame];
    if (self) {
		owner = vOwner;
		mySelf = self;
		aTimer = nil;
		bTimer = nil;
		
		[self displayGame];
		
		dataStat = [statDatabase alloc];
		
		// Set up event to trigger when the application will lose focus, to display get rid of the game's view
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self
				   selector:@selector(resignActive)
					   name:UIApplicationWillResignActiveNotification
					 object:nil];
    }
    return self;
}

- (void) resignActive {
	[panelPane removeFromSuperview];
	if (aTimer) {
		if ([aTimer isValid]) {
			[aTimer invalidate];
		}
	}
	if (bTimer) {
		if ([bTimer isValid]) {
			[bTimer invalidate];
		}
	}
	
	if (playerWellDone) {
		if ([playerWellDone isPlaying]) {
			[playerWellDone stop];
		}
	}
	if (playerSuccess) {
		if ([playerSuccess isPlaying]) {
			[playerSuccess stop];
		}
	}
	if (playerPersonal1) {
		if ([playerPersonal1 isPlaying]) {
			[playerPersonal1 stop];
		}
	}
}

- (void) displayGame
{
	// Create a panel to mask the whole screen.
	// Create an image view for each of the 9 digits and place them in an oval.
	// Create 9 image views for the pictures that will be set in the initialisation method
	
	ViewController *myView;
	myView = owner;
	
	panelPane = [[UIView alloc] initWithFrame:self.frame];
	panelPane.backgroundColor = [UIColor blackColor];
	[[myView view] addSubview:panelPane];
	[[myView view] bringSubviewToFront:panelPane];
	
	number[0] = [[UIButton alloc] initWithFrame:CGRectMake(461,1,100,100)];
	[number[0] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No1" ofType:@"png"]] forState:UIControlStateNormal];
	
	number[1] = [[UIButton alloc] initWithFrame:CGRectMake(710,51,100,100)];
	[number[1] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No2" ofType:@"png"]] forState:UIControlStateNormal];
	
	number[2] = [[UIButton alloc] initWithFrame:CGRectMake(923,262,100,100)];
	[number[2] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No3" ofType:@"png"]] forState:UIControlStateNormal];
	
	number[3] = [[UIButton alloc] initWithFrame:CGRectMake(838,545,100,100)];
	[number[3] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No4" ofType:@"png"]] forState:UIControlStateNormal];
	
	number[4] = [[UIButton alloc] initWithFrame:CGRectMake(587,667,100,100)];
	[number[4] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No5" ofType:@"png"]] forState:UIControlStateNormal];
	
	number[5] = [[UIButton alloc] initWithFrame:CGRectMake(342,667,100,100)];
	[number[5] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No6" ofType:@"png"]] forState:UIControlStateNormal];
	
	number[6] = [[UIButton alloc] initWithFrame:CGRectMake(89,545,100,100)];
	[number[6] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No7" ofType:@"png"]] forState:UIControlStateNormal];
	
	number[7] = [[UIButton alloc] initWithFrame:CGRectMake(4,262,100,100)];
	[number[7] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No8" ofType:@"png"]] forState:UIControlStateNormal];
	
	number[8] = [[UIButton alloc] initWithFrame:CGRectMake(218,51,100,100)];
	[number[8] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No9" ofType:@"png"]] forState:UIControlStateNormal];

	picture[0] = [[UIImageView alloc] initWithFrame:CGRectMake(453, 312, 144, 144)];
	picture[1] = [[UIImageView alloc] initWithFrame:CGRectMake(248, 312, 144, 144)];
	picture[2] = [[UIImageView alloc] initWithFrame:CGRectMake(656, 312, 144, 144)];
	picture[3] = [[UIImageView alloc] initWithFrame:CGRectMake(248, 151, 144, 144)];
	picture[4] = [[UIImageView alloc] initWithFrame:CGRectMake(656, 476, 144, 144)];
	picture[5] = [[UIImageView alloc] initWithFrame:CGRectMake(656, 151, 144, 144)];
	picture[6] = [[UIImageView alloc] initWithFrame:CGRectMake(248, 476, 144, 144)];
	picture[7] = [[UIImageView alloc] initWithFrame:CGRectMake(453, 476, 144, 144)];
	picture[8] = [[UIImageView alloc] initWithFrame:CGRectMake(453, 151, 144, 144)];
	
	for (int nIdx = 0; nIdx < 9; nIdx++) {
		[panelPane addSubview:picture[nIdx]];
		[panelPane bringSubviewToFront:picture[nIdx]];
		[picture[nIdx] setAlpha:0];
		
		[panelPane addSubview:number[nIdx]];
		[panelPane bringSubviewToFront:number[nIdx]];
		[number[nIdx] addTarget:mySelf action:@selector(numberPressed:) forControlEvents:UIControlEventTouchDown];
		[number[nIdx] setEnabled:NO];
		number[nIdx].adjustsImageWhenDisabled = NO;
		[number[nIdx] setAlpha:0];
	}
	
	[self myInit];
}

- (void) numberPressed:(UIButton *)numPressed;
{
	// Work out which number has been pressed and log it in the database
	for (int nIdx = 0; nIdx < 9; nIdx++) {
		if (numPressed == number[nIdx]) {
			ViewController *myView;
			myView = owner;
			[dataStat logNumPress:[myView dbFile]
					   currSessID:[myView currSessID]
					   currGameID:[myView currGameID]
					   numPressed:(nIdx+1)
					   correctNum:correctNum];
			break;
		}
	}
	// If the correct number has been pressed play the success sequence
	if (numPressed == number[correctNum - 1]) {
		[self mySuccess];
	}
}

- (void) myInit {
    
    char randPicNameC[8];
    NSString *cPath;
    int lastPic;
    
    // Randomise the timer, and select which of the buttons will have the correct picture
	// Make sure that the number of items isn't the same as the last game
    srand((unsigned int)time(NULL));
    
    lastPic=correctNum;
    do {
        correctNum=rand() % 9 + 1;
    } while (correctNum==lastPic);
    
    sprintf(randPicNameC,"Pic%01d",correctNum);
    NSString *randPicName = [NSString stringWithUTF8String:randPicNameC];
    
    cPath = [[NSBundle mainBundle] pathForResource:randPicName ofType:@"jpg"];
    
	for (int nIdx = 0; nIdx < 9; nIdx++) {
		if (correctNum > nIdx) {
			picture[nIdx].image = [UIImage imageWithData:[NSData dataWithContentsOfFile:cPath]];
			picture[nIdx].hidden=false;
		}
	}

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
		playerPersonal1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[prefs URLForKey:personalNumKey] error:nil];
		[playerPersonal1 play];
		aTimer = [NSTimer scheduledTimerWithTimeInterval:4
												  target:self
												selector:@selector(enableAllButtons)
												userInfo:nil
												 repeats:NO];
    } else {
		[self sayTheIntro];
    }
    
	// Get new game ID details for storing in database
	ViewController *myView;
	myView = owner;
	
	myView.currGameID++;
	
	[UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
		 for (int nIdx = 0; nIdx < 9; nIdx++) {
			 [picture[nIdx] setAlpha:1];
		 }
	 }
					 completion:^(BOOL finished)
	 {
		 
	 }];

}

- (void)mySuccess {
	ViewController *myView;
	myView = owner;
	
    /* Play the success tune */
    myView.currentTune=0;
	[self playSuccessTune];
    [self myAnimationOne];
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
	//	[playerSuccess setDelegate:self];
	[playerSuccess play];
}

- (void) myAnimationOne
{
	[UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
		 for (int nIdx = 0; nIdx < 9; nIdx++) {
			 [number[nIdx] setEnabled:NO];
			 number[nIdx].adjustsImageWhenDisabled = NO;
			 
			 if (nIdx != correctNum - 1) {
				 number[nIdx].alpha = 0;
			 }
		 }
	 }
					 completion:^(BOOL finished)
     {
     }];

	aTimer = [NSTimer scheduledTimerWithTimeInterval:4
											  target:self
											selector:@selector(handleWellDone)
											userInfo:nil
											 repeats:NO];
	
	savedPosition = number[correctNum - 1].frame;
	[UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
		 [number[correctNum - 1] setFrame:CGRectMake(482, 354, 100, 100)];
		 number[correctNum - 1].transform = CGAffineTransformScale(number[correctNum - 1].transform,4,4);
	 }
					 completion:^(BOOL finished)
     {

     }];
}

- (void) handleWellDone
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	if (([prefs URLForKey:@"personalMessage1"])||
		([prefs URLForKey:@"personalMessage2"])||
		([prefs URLForKey:@"personalMessage3"])||
		([prefs URLForKey:@"personalMessage4"])) {
		[self playWellDone];
		bTimer = [NSTimer scheduledTimerWithTimeInterval:4
												  target:self
												selector:@selector(myAnimationTwo)
												userInfo:nil
												 repeats:NO];
	} else {
		[self sayWellDone];
	}
}

- (void) playWellDone {
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
		[playerPersonal1 play];
	} else {
		[playerWellDone play];
	}
}

- (void) myAnimationTwo
{
	[self playSuccessTune];
	
	aTimer = [NSTimer scheduledTimerWithTimeInterval:4.5
											  target:self
											selector:@selector(letsStartAgain)
											userInfo:nil repeats:NO];
	
	// Move the correct number back to where it started
	[UIView animateWithDuration:4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
		 [number[correctNum - 1] setFrame:savedPosition];
		 number[correctNum - 1].transform = CGAffineTransformScale(number[correctNum - 1].transform,1,1);
	 }
					 completion:^(BOOL finished)
     {
		 [UIView animateWithDuration:0.5
							   delay:0
							 options:UIViewAnimationOptionCurveEaseIn
						  animations:^(void)
		  {
			  for (int nIdx = 0; nIdx < 9; nIdx++) {
				  [number[nIdx] setAlpha:0];
				  [picture[nIdx] setAlpha:0];
			  }
		  }
			completion:^(BOOL finished)
		  {
		  }];
     }];
}

- (void) letsStartAgain
{
	// Once number is back where it started, start a new game
	ViewController *myView = owner;
	[panelPane removeFromSuperview];
	[myView newGame];
}

- (void) sayTheIntro {
	AVSpeechSynthesizer *theSynth;
	NSString *introText;
	
	switch (correctNum) {
		case 1:
			introText = @"Look! One tiger. Can you see the number one?";
			break;
		case 2:
			introText = @"Look! Two cats. Can you see the number two?";
			break;
		case 3:
			introText = @"Look! Three snakes. Can you see the number three?";
			break;
		case 4:
			introText = @"Look! Four mice. Can you see the number four?";
			break;
		case 5:
			introText = @"Look! Five cows. Can you see the number five?";
			break;
		case 6:
			introText = @"Look! Six chickens. Can you see the number six?";
			break;
		case 7:
			introText = @"Look! Seven ducks. Can you see the number seven?";
			break;
		case 8:
			introText = @"Look! Eight ducks. Can you see the number eight?";
			break;
		case 9:
			introText = @"Look! Nine elephants. Can you see the number nine?";
			break;
	}
	
	theSynth = [[AVSpeechSynthesizer alloc] init];
	vocaliseIntro = [[AVSpeechUtterance alloc] initWithString:introText];
	vocaliseIntro.rate = 0.4;
	vocaliseIntro.pitchMultiplier = 1.5;
	vocaliseIntro.preUtteranceDelay = 0.5;
	[theSynth speakUtterance:vocaliseIntro];
	[theSynth setDelegate:mySelf];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
	if (utterance == vocaliseIntro) {
		[self enableAllButtons];
	} else {
		[self myAnimationTwo];
	}
}

- (void) sayWellDone {
	AVSpeechSynthesizer *theSynth;
	NSString *successText;
	
	successText = @"Well done! That's right!";
	
	theSynth = [[AVSpeechSynthesizer alloc] init];
	vocaliseWellDone = [[AVSpeechUtterance alloc] initWithString:successText];
	vocaliseWellDone.rate = 0.4;
	vocaliseWellDone.pitchMultiplier = 1.5;
	vocaliseWellDone.preUtteranceDelay = 0.5;
	[theSynth speakUtterance:vocaliseWellDone];
	[theSynth setDelegate:mySelf];
}


- (void) enableAllButtons
{
	[UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void)
     {
		 for (int nIdx = 0; nIdx < 9; nIdx++) {
			 [number[nIdx] setAlpha:1];
			 [number[nIdx] setEnabled:YES];
		 }
	 }
					 completion:^(BOOL finished)
	 {
		 
	 }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
