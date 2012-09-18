//
//  KHHData.h
//  CardBook
//
//  Created by 孙铭 on 12-9-17.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface KHHData : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
+ (id)sharedData;
- (void)saveContext;
@end
