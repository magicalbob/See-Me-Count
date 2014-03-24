//
//  ChartView.h
//  ChartFW
//
//  Created by Ian on 08/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "Common.h"

@interface ChartView : UIView {
	NSInteger overideY;
}
- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView rangeX:(NSMutableArray *)rangeX rangeY1:(NSMutableArray *)rangeY1 chartLabel:(NSString *)chartLabel;
- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView rangeX:(NSMutableArray *)rangeX rangeY1:(NSMutableArray *)rangeY1 rangeY2:(NSMutableArray *)rangeY2 chartLabel:(NSString *)chartLabel;
- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView rangeX:(NSMutableArray *)rangeX rangeY1:(NSMutableArray *)rangeY1 yOveride:(NSInteger)yOveride chartLabel:(NSString *)chartLabel;
- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView rangeX:(NSMutableArray *)rangeX rangeY1:(NSMutableArray *)rangeY1 rangeY2:(NSMutableArray *)rangeY2 yOveride:(NSInteger)yOveride chartLabel:(NSString *)chartLabel;
@property NSMutableArray *rangeX;
@property NSMutableArray *rangeY1;
@property NSMutableArray *rangeY2;
@property NSString *chartLabel;
@property NSInteger maximumY;
@end
