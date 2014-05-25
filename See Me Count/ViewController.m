//
//  ViewController.m
//  See Me Count
//
//  Created by Ian on 30/12/2013.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {

}

@end

@implementation ViewController

@synthesize playerIntro;
@synthesize currGameID;
@synthesize currSessID;
@synthesize playerSuccess;
@synthesize playerPersonal1;
@synthesize playerWellDone;
@synthesize currentTune;
@synthesize dbFile;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set up event to trigger when the application becomes active again, to display the setup page.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

	// Set up event to trigger when the application will lose focus, to stop any players / recorders
	[center addObserver:self
			   selector:@selector(resignActive)
				   name:UIApplicationWillResignActiveNotification
				 object:nil];
	
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
	
	//  Set the initial game ID to be zero
	currGameID=0;
	
	gameSetup = [[setupGame alloc] initWithFrame:CGRectMake(0,0,1024,768) owner:self];
}

- (void) resignActive
{
	if ([recorder1 isRecording]) {
		[recorder1 stop];
	}
    
	if ([playerPersonal1 isPlaying]) {
		[playerPersonal1 stop];
	}
	
	if ([playerSuccess isPlaying]) {
		[playerSuccess stop];
	}
	
	if ([playerWellDone isPlaying]) {
		[playerWellDone stop];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goButton {
	statDatabase *dataStat = [statDatabase alloc];
	currSessID = [dataStat newSessID:dbFile];
	[self newGame];
}

- (void) newGame {
	playGame *pGame __unused = [[playGame alloc] initWithFrame:CGRectMake(0,0,1024,768) owner:self];
}


@end
