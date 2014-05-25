//
//  ChartView.m
//  ChartFW
//
//  Created by Ian on 08/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "ChartView.h"

@implementation ChartView

- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView rangeX:(NSMutableArray *)rangeX rangeY1:(NSMutableArray *)rangeY1 chartLabel:(NSString *)chartLabel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
	[containingView addSubview:self];
	
	[containingView bringSubviewToFront:self];
	
	self.rangeX = rangeX;
	self.rangeY1 = rangeY1;
	self.rangeY2 = nil;
	self.chartLabel=chartLabel;
	overideY=0;
	
    return self;
}

- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView rangeX:(NSMutableArray *)rangeX rangeY1:(NSMutableArray *)rangeY1 rangeY2:(NSMutableArray *)rangeY2 chartLabel:(NSString *)chartLabel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
	[containingView addSubview:self];
	
	[containingView bringSubviewToFront:self];
	
	self.rangeX = rangeX;
	self.rangeY1 = rangeY1;
	self.rangeY2 = rangeY2;
	self.chartLabel=chartLabel;
	overideY=0;
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView rangeX:(NSMutableArray *)rangeX rangeY1:(NSMutableArray *)rangeY1 yOveride:(NSInteger)yOveride chartLabel:(NSString *)chartLabel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
	[containingView addSubview:self];
	
	[containingView bringSubviewToFront:self];
	
	self.rangeX = rangeX;
	self.rangeY1 = rangeY1;
	self.rangeY2 = nil;
	self.chartLabel=chartLabel;
	overideY=yOveride;
	
    return self;
}

- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView rangeX:(NSMutableArray *)rangeX rangeY1:(NSMutableArray *)rangeY1 rangeY2:(NSMutableArray *)rangeY2 yOveride:(NSInteger)yOveride chartLabel:(NSString *)chartLabel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
	[containingView addSubview:self];
	
	[containingView bringSubviewToFront:self];
	
	self.rangeX = rangeX;
	self.rangeY1 = rangeY1;
	self.rangeY2 = rangeY2;
	self.chartLabel=chartLabel;
	overideY=yOveride;
	
    return self;
}


-(void) drawRect: (CGRect) rect
{
	const float axisBorder=0.055;
	const float axisPos=0.105;
	const float axisDiv=0.09;
	const float axisLabel=0.01;
	
	// Set context for core graphics
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Set up colours
	
    UIColor * darkGreyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
//	UIColor * lightGreyColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
	UIColor * blackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
	UIColor *darkRedColor = [UIColor colorWithRed:0.9 green:0.0 blue:0.0 alpha:1.0];
	UIColor *lightRedColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
	UIColor *darkGreenColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.0 alpha:1.0];
	UIColor *lightGreenColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
	
	// Draw the background for the chart
	
    CGContextSetFillColorWithColor(context, darkGreyColor.CGColor);
    CGContextFillRect(context, self.bounds);
	
	CGRect paperRect = self.bounds;
	
//	CGRect strokeRect = CGRectInset(paperRect, 5.0, 5.0);
//    CGContextSetStrokeColorWithColor(context, blackColor.CGColor);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextStrokeRect(context, strokeRect);

//	CGRect blockRect=CGRectMake((0.2*self.bounds.size.width)+self.bounds.origin.x, (0.2*self.bounds.size.height)+self.bounds.origin.y, (0.5*self.bounds.size.width), (0.5*self.bounds.size.height));
	
//	drawLinearGradient(context, blockRect, blackColor.CGColor, lightGreyColor.CGColor);

	// Draw x-axis
	
	CGPoint startPoint = CGPointMake(paperRect.origin.x + (paperRect.size.width * axisBorder), paperRect.origin.y + (paperRect.size.height * (1-axisPos)));
    CGPoint endPoint = CGPointMake(paperRect.origin.x + (paperRect.size.width * (1-axisBorder)), paperRect.origin.y + (paperRect.size.height * (1-axisPos)));
    draw1PxStroke(context, startPoint, endPoint, blackColor.CGColor);

	// Draw y-axis

	startPoint = CGPointMake(paperRect.origin.x + (paperRect.size.width * axisPos), paperRect.origin.y + (paperRect.size.height * axisBorder));
	endPoint = CGPointMake(paperRect.origin.x + (paperRect.size.width * axisPos), paperRect.origin.y + (paperRect.size.height * (1-axisBorder)));
    draw1PxStroke(context, startPoint, endPoint, blackColor.CGColor);

	
	// get the maximum Y value in the data range, to work out the Y scale
	
	__block long maxYValue=0;

	if (overideY>0) {
		maxYValue=overideY;
	} else {
		[self.rangeY1 enumerateObjectsUsingBlock:^(id obj,
											  NSUInteger idx,
											  BOOL *stop) {
			if (self.rangeY2) {
				if ([obj integerValue] + [self.rangeY2[idx] integerValue]> maxYValue) {
					maxYValue=[obj integerValue] + [self.rangeY2[idx] integerValue];
				}
			} else {
				if ([obj integerValue]> maxYValue) {
					maxYValue=[obj integerValue];
				}
			}
		}];
	}
	
	self.maximumY=maxYValue;
	
	// get the count of X values to work out the X scale
	
	long countX = [self.rangeX count];

	// work out width of each column, including padding, and height of each unit.
	
	float allWidth = (1 - axisPos - axisBorder) / countX;
	float colWidth=allWidth/3;
	
	float unitHeight= (1-axisPos - axisBorder) / maxYValue;

	// Draw X scale dividing marks
	
	for (int divCnt=1; divCnt < [self.rangeX count]; divCnt++) {
		startPoint = CGPointMake(((axisPos+(divCnt*allWidth)) * self.bounds.size.width) + self.bounds.origin.x, paperRect.origin.y + (paperRect.size.height * (1-axisPos)));
		endPoint = CGPointMake(((axisPos+(divCnt*allWidth)) * self.bounds.size.width) + self.bounds.origin.x, paperRect.origin.y + (paperRect.size.height * (1-axisDiv)));
		draw1PxStroke(context, startPoint, endPoint, blackColor.CGColor);
	}

	// Print the X scale labels
	// Flip the coordinate system
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	for (int divCnt=0; divCnt < [self.rangeX count]; divCnt++) {
		float fSize=((self.bounds.size.width * self.bounds.size.height) / (600 * 600)) * 20.0;
		
		CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fSize, NULL);
		NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef, (NSString *)kCTFontAttributeName, (id)[[UIColor blackColor] CGColor],  (NSString *) kCTStrokeColorAttributeName, (id)[NSNumber numberWithFloat:-3.0], (NSString *)kCTStrokeWidthAttributeName, nil];
		
		NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.rangeX[divCnt] attributes:attrDictionary];
		
		CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attString);
		
		// Set text position and draw the line into the graphic context
		CGContextSetTextPosition(context, ((axisPos+(divCnt*allWidth)) * self.bounds.size.width) + self.bounds.origin.x + (self.bounds.size.width * colWidth) , paperRect.origin.y + (paperRect.size.height * (axisBorder)));
		CTLineDraw(line, context);
		CFRelease(line);
	}
	
	// Print the Y scale labels

	for (int divCnt=0; divCnt < maxYValue; divCnt++) {
		// Reduce the number of labels printed if there's a lot of entries in the Y scale
		if (((maxYValue>19)&&(divCnt % 10 == 9))||(maxYValue<20)) {
			float fSize=((self.bounds.size.width * self.bounds.size.height) / (600 * 600)) * 20.0;
			
			CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fSize, NULL);
			NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef, (NSString *)kCTFontAttributeName, (id)[[UIColor blackColor] CGColor],  (NSString *) kCTStrokeColorAttributeName, (id)[NSNumber numberWithFloat:-3.0], (NSString *)kCTStrokeWidthAttributeName, nil];
			NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", divCnt+1] attributes:attrDictionary];
		
			CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attString);
		
			// Set text position and draw the line into the graphic context
			CGContextSetTextPosition(context, paperRect.origin.x + (paperRect.size.width * axisBorder) ,
								 paperRect.origin.y + ((unitHeight*(divCnt+1) + axisPos)*paperRect.size.height));
			CTLineDraw(line, context);
			CFRelease(line);
		}
		
	}
	
	// Print the chart's label
	float fSize=((self.bounds.size.width * self.bounds.size.height) / (600 * 600)) * 20.0;
	
	CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fSize, NULL);
	NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef, (NSString *)kCTFontAttributeName, (id)[[UIColor blackColor] CGColor],  (NSString *) kCTStrokeColorAttributeName, (id)[NSNumber numberWithFloat:-3.0], (NSString *)kCTStrokeWidthAttributeName, nil];
	NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.chartLabel attributes:attrDictionary];
	
	CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attString);
	
	// Set text position and draw the line into the graphic context
	CGContextSetTextPosition(context, paperRect.origin.x + (paperRect.size.width /2) ,
							 paperRect.origin.y + axisLabel*paperRect.size.height);
	CTLineDraw(line, context);
	CFRelease(line);
	
	// Flip the coordinate system
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Draw Y scale dividing lines
	
	for (int divCnt=1; divCnt <= maxYValue; divCnt++) {
		// Reduce the number of dividing lines drawn if there's a lot of entries in the Y scale
		if (((maxYValue>19)&&(divCnt % 10 == 9))||(maxYValue<20)) {
			startPoint = CGPointMake(paperRect.origin.x + (paperRect.size.width * axisDiv),
								 ((1-axisPos-(divCnt*unitHeight)) * self.bounds.size.height) + self.bounds.origin.y);
			endPoint = CGPointMake(paperRect.origin.x + (paperRect.size.width * (1-axisBorder)),
							   ((1-axisPos-(divCnt*unitHeight)) * self.bounds.size.height) + self.bounds.origin.y);
			draw1PxStroke(context, startPoint, endPoint, blackColor.CGColor);

		}
	}
	
	
	[self.rangeY1 enumerateObjectsUsingBlock:^(id obj,
											  NSUInteger idx,
											  BOOL *stop) {
			if ([obj integerValue]) {
				float blockX, blockY;
				blockX=((axisPos+(idx*allWidth)+colWidth) * self.bounds.size.width) + self.bounds.origin.x;
				blockY=((1-axisPos-([obj integerValue]*unitHeight)) * self.bounds.size.height) + self.bounds.origin.y;

				CGRect blockRect=CGRectMake(blockX, blockY, colWidth*self.bounds.size.width, (unitHeight*[obj integerValue]*self.bounds.size.height *0.50) + 1);
				if (self.rangeY2) {
					drawLinearGradient(context, blockRect, darkRedColor.CGColor, lightRedColor.CGColor);

					blockRect.origin.y += (unitHeight*[obj integerValue]*self.bounds.size.height *0.5) - 1 ;
				
					drawLinearGradient(context, blockRect, lightRedColor.CGColor, darkRedColor.CGColor);
				} else {
					drawLinearGradient(context, blockRect, darkGreenColor.CGColor, lightGreenColor.CGColor);
					
					blockRect.origin.y += (unitHeight*[obj integerValue]*self.bounds.size.height *0.5) - 1 ;
					
					drawLinearGradient(context, blockRect, lightGreenColor.CGColor, darkGreenColor.CGColor);
				}
			}
		}];
	
	if (self.rangeY2) {
		[self.rangeY2 enumerateObjectsUsingBlock:^(id obj,
												   NSUInteger idx,
												   BOOL *stop) {
			if ([obj integerValue]) {
				float blockX, blockY;
				blockX=((axisPos+(idx*allWidth)+colWidth) * self.bounds.size.width) + self.bounds.origin.x;
				blockY=((1-axisPos-(([obj integerValue] + [self.rangeY1[idx] integerValue])*unitHeight)) * self.bounds.size.height) + self.bounds.origin.y;
			
				CGRect blockRect=CGRectMake(blockX, blockY, colWidth*self.bounds.size.width, (unitHeight*[obj integerValue]*self.bounds.size.height * 0.50) + 1);
			
				drawLinearGradient(context, blockRect, darkGreenColor.CGColor, lightGreenColor.CGColor);

				blockRect.origin.y += (unitHeight*[obj integerValue]*self.bounds.size.height *0.5) - 1;
			
				drawLinearGradient(context, blockRect, lightGreenColor.CGColor, darkGreenColor.CGColor);
			}
		}];
	}
}

@end
