//
//  KHHVisualCardViewController.m
//  CardBook
//
//  Created by Sun Ming on 12-9-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHVisualCardViewController.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
static CGFloat const ratio = 300.f / 450.f;

@interface KHHVisualCardViewController ()

@end

@implementation KHHVisualCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    self.card = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Card
- (void)setCard:(Card *)card {
    _card = card;
    [self drawViewWithCard];
}

/*
 items to display:
 bgImage                 y    
 logo                    y
 name                    y
 title                   y
 mobile phone            y
 telephone               y
 fax                     y
 email                   y
 web                     n
 qq                      y
 msn                     y
 company logo            y
 company name            y
 company address         y
 company email           n
 department              y
 factory address         n
 custom service phone    n
 remarks                 n
 */
- (void)drawViewWithCard {
    NSDictionary * const prefixPair = @{
    kVisualCardItemKeyAddress:NSLocalizedString(@"地址：", nil),
    kVisualCardItemKeyCompanyEmail:NSLocalizedString(@"公司email：", nil),
    kVisualCardItemKeyEmail:NSLocalizedString(@"email：", nil),
    kVisualCardItemKeyFax:NSLocalizedString(@"传真：", nil),
    kVisualCardItemKeyMobilePhone:NSLocalizedString(@"手机：", nil),
    kVisualCardItemKeyMSN:NSLocalizedString(@"MSN：", nil),
    kVisualCardItemKeyQQ:NSLocalizedString(@"QQ：", nil),
    kVisualCardItemKeyTelephone:NSLocalizedString(@"固定电话：", nil),
    };
    NSArray * const labelItemNames = @[
    kVisualCardItemKeyAddress,
    kVisualCardItemKeyCompanyEmail,
    kVisualCardItemKeyCompanyName,
    kVisualCardItemKeyEmail,
    kVisualCardItemKeyFax,
    kVisualCardItemKeyMobilePhone,
    kVisualCardItemKeyMSN,
    kVisualCardItemKeyName,
    kVisualCardItemKeyQQ,
    kVisualCardItemKeyTelephone,
    kVisualCardItemKeyTitle,
    ];
    NSDictionary *itemValuePair = @{
    kVisualCardItemKeyCompanyEmail : kAttributeKeyPathCompanyEmail,
    kVisualCardItemKeyCompanyLogo : kAttributeKeyPathCompanyLogoURL,
    kVisualCardItemKeyCompanyName : kAttributeKeyPathCompanyName,
    kVisualCardItemKeyEmail : kAttributeKeyEmail,
    kVisualCardItemKeyFax : kAttributeKeyFax,
    kVisualCardItemKeyLogo : kAttributeKeyPathLogoURL,
    kVisualCardItemKeyMobilePhone : kAttributeKeyMobilePhone,
    kVisualCardItemKeyMSN : kAttributeKeyMSN,
    kVisualCardItemKeyName : kAttributeKeyName,
    kVisualCardItemKeyQQ : kAttributeKeyQQ,
    kVisualCardItemKeyTelephone : kAttributeKeyTelephone,
    kVisualCardItemKeyTitle : kAttributeKeyTitle,
    };
    
    // 删除背景,logo,公司logo和所有label
    // 即删除所有imageview和label
    NSArray *allSubviews = [self.view subviews];
    for (UIView *aView in allSubviews) {
        if ([aView isKindOfClass:[UILabel class]]
            || [aView isKindOfClass:[UIImageView class]]) {
            [aView removeFromSuperview];
        }
    }
    // 开始重建view
    Card *card = self.card;
    CardTemplate *tmpl = card.template;
    if (nil == tmpl) {
        // 模板为nil，直接返回。
        return;
    }
    // 新建背景
    if (tmpl.bgImage.url) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [imgView setImageWithURL:[NSURL URLWithString:tmpl.bgImage.url]];
        [self.view addSubview:imgView];
    }
    // 
    NSSet *itemsSet = tmpl.items;
    for (CardTemplateItem *anItem in itemsSet) {
        DLog(@"[II] item = %@", anItem);
        if ([labelItemNames containsObject:anItem.name]) {
            CGFloat originX = anItem.originXValue * ratio;
            CGFloat originY = anItem.originYValue * ratio;
            id valueOfCard;
            if ([anItem.name isEqualToString:kVisualCardItemKeyAddress]) {
                // 地址是多个字段组成的，单独处理
                Address *addr = card.address;
                valueOfCard = [NSString stringWithFormat:@"%@%@%@%@%@",
                               [NSString stringByFilterNilFromString:addr.province],
                               [NSString stringByFilterNilFromString:addr.city],
                               [NSString stringByFilterNilFromString:addr.district],
                               [NSString stringByFilterNilFromString:addr.street],
                               [NSString stringByFilterNilFromString:addr.other]
                               ];
            } else {
                // 其他
                valueOfCard = [card valueForKeyPath:itemValuePair[anItem.name]];
            }
            NSString *valueText = [NSString stringFromObject:valueOfCard];
            if (valueText.length) {
                NSString *labelText = [NSString stringWithFormat:@"%@%@",
                                       [NSString stringByFilterNilFromString:prefixPair[anItem.name]],
                                       [NSString stringByFilterNilFromString:valueText]
                                       ];
                NSString *fontName = [anItem.fontWeight isEqualToString:@"bold"]?@"Helvetica-Bold":@"Helvetica";
                CGFloat fontSize = anItem.fontSizeValue * ratio;
                UIFont *font = [UIFont fontWithName:fontName size:fontSize];
                CGSize textSize = [labelText sizeWithFont:font];
                UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, textSize.width, textSize.height)];
                aLabel.font = font;
                aLabel.text = labelText;
                aLabel.textColor = [UIColor colorWithHexString:anItem.fontColor];
                aLabel.backgroundColor = [UIColor clearColor];
                [self.view addSubview:aLabel];
                DLog(@"[II] 为 %@ 创建了 label", anItem.name);
            }
        }
        // 单独处理logo和公司logo
        else if ([anItem.name hasSuffix:@"logo"]) {
            CGFloat originX = anItem.originXValue * ratio;
            CGFloat originY = anItem.originYValue * ratio;
            CGFloat width = anItem.rectWidthValue * ratio;
            CGFloat height = anItem.rectHeightValue * ratio;
            NSString *valueText = [card valueForKeyPath:itemValuePair[anItem.name]];
            if (valueText.length) {
                UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
                logoView.contentMode = UIViewContentModeScaleAspectFill;
                [logoView setImageWithURL:[NSURL URLWithString:valueText]];
                [self.view addSubview:logoView];
            }
        }
    }
    
}
@end
