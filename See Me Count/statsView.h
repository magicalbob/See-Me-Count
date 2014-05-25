//
//  statsView.h
//  See Me Count
//
//  Created by Ian on 25/05/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "digitalDisplay.h"
#import "ChartView.h"
#import "ViewController.h"

@interface statsView : UIView
{
	id	owner;
	id mySelf;
	NSMutableArray *myDigImages;
	NSMutableArray *sessGameDat;
	int viewGameOffset;
	NSInteger viewGameCount;
	NSInteger viewGameMaxY;
	UIButton *goLeft, *goRight;
}
@property UIView *panelPane;
- (id)initWithFrame:(CGRect)frame owner:(id)vOwner;
- (void) leftButtonPress;
@end
