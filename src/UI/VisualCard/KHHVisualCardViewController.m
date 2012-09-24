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
//- (void)setCardTemplate:(CardTemplate *)cardTemplate {
//    _cardTemplate = cardTemplate;
//    [self render]
//}
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
//kVisualCardItemKeyAddress:kAttributeKey
    kVisualCardItemKeyCompanyEmail : kAttributeKeyPathCompanyEmail,
    kVisualCardItemKeyCompanyName : kAttributeKeyPathCompanyName,
    kVisualCardItemKeyEmail : kAttributeKeyEmail,
    kVisualCardItemKeyFax : kAttributeKeyFax,
    kVisualCardItemKeyMobilePhone : kAttributeKeyMobilePhone,
    kVisualCardItemKeyMSN : kAttributeKeyMSN,
    kVisualCardItemKeyName : kAttributeKeyName,
    kVisualCardItemKeyQQ : kAttributeKeyQQ,
    kVisualCardItemKeyTelephone : kAttributeKeyTelephone,
    kVisualCardItemKeyTitle : kAttributeKeyTitle,
    };
    
    // 先删除所有的label
    NSArray *allSubviews = [self.view subviews];
    for (UIView *aView in allSubviews) {
        if ([aView isKindOfClass:[UILabel class]]) {
            [aView removeFromSuperview];
        }
    }
    
    // 取得新items
    if (self.card) {
        NSSet *itemsSet = self.card.template.items;
        // 新建需要显示label
        for (CardTemplateItem *anItem in itemsSet) {
            DLog(@"[II] item = %@", anItem);
#warning NEED REVIEW
            if ([labelItemNames containsObject:anItem.name]) {
                CGFloat originX = anItem.originXValue / 450.f * 300.f;
                CGFloat originY = anItem.originYValue / 270.f * 180.f;
                id valueOfCard;
                if ([anItem.name isEqualToString:kVisualCardItemKeyAddress]) {
                    // 地址是多个字段组成的
                    Address *addr = self.card.address;
                    valueOfCard = [NSString stringWithFormat:@"%@%@%@%@%@",
                                   addr.province,addr.city,addr.district,addr.street,addr.other];
                } else {
                    valueOfCard = [self.card valueForKeyPath:itemValuePair[anItem.name]];
                }
                NSString *valueText = [NSString stringFromObject:valueOfCard];
                if (valueText.length) {
                    NSString *labelText = [NSString stringWithFormat:@"%@%@",prefixPair[anItem.name], valueText];
                    NSString *fontName = [anItem.fontWeight isEqualToString:@"bold"]?@"Helvetica-Bold":@"Helvetica";
                    CGFloat fontSize = anItem.fontSizeValue /450 *300;
                    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
                    CGSize textSize = [labelText sizeWithFont:font];
                    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, textSize.width, textSize.height)];
                    aLabel.font = font;
                    aLabel.text = labelText;
                    aLabel.textColor = [UIColor blackColor];
//                    aLabel.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:aLabel];
                    DLog(@"[II] 为 %@ 创建了 label", anItem.name);
                }
            }
        }
#warning TODO
        
    }
}
@end
