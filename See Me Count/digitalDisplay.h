//
//  digitalDisplay.h
//  DigitalDisplay
//
//  Created by Ian on 10/02/2014.
//  Copyright (c) 2014 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface digitalDisplay : UIView
- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containgView digitImages:(NSMutableArray *)digitImages numberValue:(NSInteger)numberValue;
- (id)initWithFrame:(CGRect)frame containingView:(UIView*)containingView digitImages:(NSMutableArray *)digitImages numberValue:(NSInteger)numberValue label:(NSString *)digLabel;
@property NSMutableArray *digitImages;
@property NSInteger numberValue;
@property NSString *digLabel;
@end
