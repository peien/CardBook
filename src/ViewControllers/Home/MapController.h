//
//  MapController.h
//  eCard
//
//  Created by 小龙 李 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "SuperViewController.h"


@interface MapController : SuperViewController <MKMapViewDelegate>
{
    MKMapView *_mapView;
    
}

@property (nonatomic, retain) NSString *companyName;
@property (nonatomic, retain) NSString *companyAddr;

@end

