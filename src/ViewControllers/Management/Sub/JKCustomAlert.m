//
//  
//  JKCustomAlert.m
//  AlertTest
//
//  Created by  on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JKCustomAlert.h"

@interface JKCustomAlert ()
    @property(nonatomic, retain) NSMutableArray *_buttonArrays;
@end

@implementation JKCustomAlert

@synthesize backgroundImage,contentImage,_buttonArrays,JKdelegate;

- (id)initWithImage:(UIImage *)image contentImage:(UIImage *)content{
    if (self == [super init]) {
		
        self.backgroundImage = image;
        self.contentImage = content;
        self._buttonArrays = [NSMutableArray arrayWithCapacity:4];
	    }
    return self;
}

-(void) addButtonWithUIButton:(UIButton *) btn
{
    [_buttonArrays addObject:btn];
}


- (void)drawRect:(CGRect)rect {
	
	CGSize imageSize = self.backgroundImage.size;
	[self.backgroundImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
}

- (void) layoutSubviews {
    //屏蔽系统的ImageView 和 UIButton
    for (UIView *v in [self subviews]) {
        if ([v class] == [UIImageView class]){
            [v setHidden:YES];
        }
           
     
        if ([v isKindOfClass:[UIButton class]] ||
            [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            [v setHidden:YES];
        }
    }
    
    for (int i=0;i<[_buttonArrays count]; i++) {
        UIButton *btn = [_buttonArrays objectAtIndex:i];
        btn.tag = i;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
	
    if (contentImage) {
        UIImageView *contentview = [[UIImageView alloc] initWithImage:self.contentImage];
        contentview.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        [self addSubview:contentview];
    }
}

-(void) buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (JKdelegate) {
        if ([JKdelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [JKdelegate alertView:self clickedButtonAtIndex:btn.tag];
        }
    }
    
    [self dismissWithClickedButtonIndex:0 animated:YES];

}

- (void) show {
        [super show];
        CGSize imageSize = self.backgroundImage.size;
        self.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        

}


- (void)dealloc {
    [_buttonArrays removeAllObjects];
    [backgroundImage release];
    if (contentImage) {
        [contentImage release];
        contentImage = nil;
    }
   
    [super dealloc];
}


@end
