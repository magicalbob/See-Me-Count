//
//  digitalDisplay.m
//  DigitalDisplay
//
//  Created by Ian on 10/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import "digitalDisplay.h"

@implementation digitalDisplay

- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView digitImages:(NSMutableArray *)digitImages numberValue:(NSInteger)numberValue;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[containingView addSubview:self];
		
		[containingView bringSubviewToFront:self];

		self.digitImages=digitImages;
		self.numberValue=numberValue;
		self.digLabel=nil;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView digitImages:(NSMutableArray *)digitImages numberValue:(NSInteger)numberValue label:(NSString *)digLabel;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[containingView addSubview:self];
		
		[containingView bringSubviewToFront:self];
		
		self.digitImages=digitImages;
		self.numberValue=numberValue;
		self.digLabel=digLabel;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Set up colours
	
//	UIColor * blackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
	
//	CGContextSetFillColorWithColor(context, blackColor.CGColor);
//	CGContextFillRect(context, self.bounds);
	
	float dWidth;
	float dHeight;
	float lHeight;

	dWidth=self.bounds.size.width/5;
	if (self.digLabel==nil) {
		lHeight=0;
		dHeight=self.bounds.size.height;
	} else {
		lHeight=0.5 * self.bounds.size.height;
		dHeight=self.bounds.size.height - lHeight;
	}
	
	CGRect dig1 = CGRectMake(self.bounds.origin.x,
							 self.bounds.origin.y,
							 dWidth+1,
							 dHeight);
	
	CGRect dig2 = CGRectMake(self.bounds.origin.x+dWidth,
							 self.bounds.origin.y,
							 dWidth+1,
							 dHeight);
	
	CGRect dig3 = CGRectMake(self.bounds.origin.x+2*dWidth,
							 self.bounds.origin.y,
							 dWidth+1,
							 dHeight);
	
	CGRect dig4 = CGRectMake(self.bounds.origin.x+3*dWidth,
							 self.bounds.origin.y,
							 dWidth+1,
							 dHeight);
	
	CGRect dig5 = CGRectMake(self.bounds.origin.x+4*dWidth,
							 self.bounds.origin.y,
							 dWidth+1,
							 dHeight);
	
	long digTK,digK, digH, digT, digU;
	digTK=(self.numberValue / 10000) % 10;
	digK=((self.numberValue-(10000*digTK)) / 1000) % 100;
	digH=((self.numberValue-(10000*digTK)-(1000*digK))/ 100) % 1000;
	digT=((self.numberValue-(10000*digTK)-(1000*digK)-(100*digH))/10) % 10000;
	digU=(self.numberValue-(10000*digTK)-(1000*digK)-(100*digH)-(10*digT)) % 100000;
	
	NSString *dPath;
	
	// Flip the coordinate system
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);

	UIImage *uiImage;
	
	if (digTK>0) {
		dPath = self.digitImages[digTK];
		
		uiImage = [UIImage imageWithContentsOfFile:dPath];
		
		CGContextDrawImage (
							context,
							dig1,
							uiImage.CGImage);
	}
	
	if (digK>0) {
		dPath = self.digitImages[digK];
		
		uiImage = [UIImage imageWithContentsOfFile:dPath];
		
		CGContextDrawImage (
							context,
							dig2,
							uiImage.CGImage);
	}
	
	if (digH>0) {
		dPath = self.digitImages[digH];

		uiImage = [UIImage imageWithContentsOfFile:dPath];
	
		CGContextDrawImage (
						context,
						dig3,
						uiImage.CGImage);
	}
	
	if (digT>0) {
		dPath = self.digitImages[digT];
	
		uiImage = [UIImage imageWithContentsOfFile:dPath];
	
		CGContextDrawImage (
						context,
						dig4,
						uiImage.CGImage);
	}
	
	dPath = self.digitImages[digU];
	
	uiImage = [UIImage imageWithContentsOfFile:dPath];

	CGContextDrawImage (
						context,
						dig5,
						uiImage.CGImage);

	if (self.digLabel!=nil) {
		CGContextSetTextMatrix(context, CGAffineTransformIdentity);
		CGContextTranslateCTM(context, 0, self.bounds.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		float fSize=((self.bounds.size.width * self.bounds.size.height) / (90 * 112)) * 14.0;
		UIColor *textColor = [UIColor whiteColor];
		CGColorRef color = textColor.CGColor;
		CTFontRef font = CTFontCreateWithName((CFStringRef)@"ArialMT", fSize, NULL);
		CTTextAlignment theAlignment = kCTCenterTextAlignment;
		CFIndex theNumberOfSettings = 1;
		CTParagraphStyleSetting theSettings[1] =
		{
			{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
				&theAlignment }
		};
		CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
		NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(font), (NSString *)kCTFontAttributeName,color, (NSString *)kCTForegroundColorAttributeName,paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,nil];
		NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:self.digLabel attributes:attributesDict];
		CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
		CGContextSetTextMatrix(context, CGAffineTransformIdentity);
		CGContextTranslateCTM(context, 0, ([self bounds]).size.height );
		CGContextScaleCTM(context, 1.0, -1.0);
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathAddRect(path, NULL, rect);
		CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
		CTFrameDraw(frame, context);
		CFRelease(path);
	}
}

@end
