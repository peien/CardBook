//
//  XLPageControl.m
//  iMenu2
//
//  Created by codans2011 on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "XLPageControl.h"

@implementation XLPageControl

@synthesize activeImg = _activeImg;
@synthesize unActiveImg = _unActiveImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateDots
{
    if(!_activeImg || !_unActiveImg)
        return;
    
    for(int i = 0; i < [self.subviews count]; i++){
        UIImageView *dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage)
            dot.image = _activeImg;
        else
            dot.image = _unActiveImg;
    }
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)dealloc
{
    self.activeImg = nil;
    self.unActiveImg = nil;
    //[super dealloc];
}

@end
