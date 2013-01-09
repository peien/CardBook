//
//  KHHForWhereCell.m
//  CardBook
//
//  Created by CJK on 13-1-8.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHForWhereCell.h"
#import "KHHWhereUtil.h"
#import "KHHBMapLocationController.h"

@implementation KHHForWhereCell

{
    UIFont *font;
    UILabel *whereView;
    UILabel *whereView2;   
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.text = @"位置";
        
        whereView = [[UILabel alloc]init];        
        whereView.font = font;
        whereView.backgroundColor = [UIColor clearColor];
        
        whereView2 = [[UILabel alloc]init];
        whereView2.font = font;
        whereView2.backgroundColor = [UIColor clearColor];
        
        
        NSMutableArray *arrPro = [[NSMutableArray alloc]initWithCapacity:6];
        for (int i=0; i<5; i++) {            
            [arrPro addObject:[[KHHWhereUtil sharedInstance] imgForIndex:i]];
        }
        _rotaView = [[UIImageView alloc]init];
        _rotaView.image = [arrPro objectAtIndex:0];
        _rotaView.animationImages = arrPro;
        _rotaView.animationDuration = 0.3;
        _rotaView.userInteractionEnabled = YES;
        

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    if ([_locStrPro sizeWithFont:font].width>200) {
        whereView.text = [_locStrPro substringToIndex:16];
        whereView.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-40)/2-7.5, 200, 40);
        whereView2.text = [_locStrPro substringFromIndex:16];
        whereView2.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-40)/2+7.5, 200, 40);
        [self addSubview:whereView2];
    }else{
        whereView.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-40)/2, 200, 40);
        whereView.text = _locStrPro;
        
    }
    
    _rotaView.frame = CGRectMake(280, (r.size.height-35)/2, 35, 35);
    [self addSubview:_rotaView];
    [self addSubview:whereView];
}


@end
