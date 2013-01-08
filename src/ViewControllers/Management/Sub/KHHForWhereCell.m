//
//  KHHForWhereCell.m
//  CardBook
//
//  Created by CJK on 13-1-8.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHForWhereCell.h"
#import "KHHWhereUtil.h"

@implementation KHHForWhereCell

{
    UIFont *font;
    UITextView *whereView;
    UIImageView *rotaView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.text = @"位置";
        
       
        NSMutableArray *arrPro = [[NSMutableArray alloc]initWithCapacity:6];
        for (int i=0; i<5; i++) {            
            [arrPro addObject:[[KHHWhereUtil sharedInstance] imgForIndex:i]];
        }
        rotaView = [[UIImageView alloc]init];
        rotaView.image = [arrPro objectAtIndex:0];
        rotaView.animationImages = arrPro;
        rotaView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateLocation:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [rotaView addGestureRecognizer:tap];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    whereView.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-40)/2, 160, 40);
    rotaView.frame = CGRectMake(280, (r.size.height-35)/2, 35, 35);
    [self addSubview:rotaView];
    [self addSubview:whereView];
}

- (void)updateLocation:(UITapGestureRecognizer *)sender
{
   
}
@end
