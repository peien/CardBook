//
//  NetClient+PrivateCard.h
//  CardBook
//
//  Created by CJK on 13-1-9.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "NetClient.h"
#import "PrivateDelegates.h"

@interface NetClient (PrivateCard)

- (void)CreatePrivateCard:(InterCard *)iCard delegate:(id<delegateNewPrivateForEdit>)delegate;

@end
