//
//  KHHLocationController.h
//  CardBook
//
//  Created by Sun Ming on 12-10-10.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"
#import <CoreLocation/CoreLocation.h>

@interface KHHLocationController : SMObject
//怕多个地方调用时，发送广播与不发广播的搞混淆了
//+ (id)sharedController;

/*!
 更新当前位置信息: 
 更新成功与否通过 notification KHHLocationUpdateSucceeded 和 KHHLocationUpdateFailed 返回。
 调用前注册监听这两个notification。
 在notification的处理方法里取消监听。
 */
- (void)updateLocation;

/*
 主要用于 百度地图定位超时时，用系统自带的定位获取经纬度
 不发送定位成功广播
 */
-(void) updateLocation:(BOOL) notify;

/**
 获取用户当前经纬度
 用之前一定要调过updateLocation 或updateLocation:bool
 */
-(CLLocationCoordinate2D) userLocationCoordinate2D;

/*
 外面强制关闭定位
 */
-(void) stopUpdateLocation;
@end
