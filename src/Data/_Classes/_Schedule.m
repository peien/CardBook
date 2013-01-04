// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Schedule.m instead.

#import "_Schedule.h"

const struct ScheduleAttributes ScheduleAttributes = {
	.companions = @"companions",
	.content = @"content",
	.customer = @"customer",
	.id = @"id",
	.isFinished = @"isFinished",
	.minutesToRemind = @"minutesToRemind",
	.plannedDate = @"plannedDate",
	.remind = @"remind",
	.version = @"version",
};

const struct ScheduleRelationships ScheduleRelationships = {
	.address = @"address",
	.images = @"images",
	.targets = @"targets",
};

const struct ScheduleFetchedProperties ScheduleFetchedProperties = {
};

@implementation ScheduleID
@end

@implementation _Schedule

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Schedule";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:moc_];
}

- (ScheduleID*)objectID {
	return (ScheduleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isFinishedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFinished"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minutesToRemindValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"minutesToRemind"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"remindValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"remind"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"versionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"version"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic companions;






@dynamic content;






@dynamic customer;






@dynamic id;



- (int64_t)idValue {
	NSNumber *result = [self id];
	return [result longLongValue];
}

- (void)setIdValue:(int64_t)value_ {
	[self setId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result longLongValue];
}

- (void)setPrimitiveIdValue:(int64_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithLongLong:value_]];
}





@dynamic isFinished;



- (BOOL)isFinishedValue {
	NSNumber *result = [self isFinished];
	return [result boolValue];
}

- (void)setIsFinishedValue:(BOOL)value_ {
	[self setIsFinished:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsFinishedValue {
	NSNumber *result = [self primitiveIsFinished];
	return [result boolValue];
}

- (void)setPrimitiveIsFinishedValue:(BOOL)value_ {
	[self setPrimitiveIsFinished:[NSNumber numberWithBool:value_]];
}





@dynamic minutesToRemind;



- (int32_t)minutesToRemindValue {
	NSNumber *result = [self minutesToRemind];
	return [result intValue];
}

- (void)setMinutesToRemindValue:(int32_t)value_ {
	[self setMinutesToRemind:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMinutesToRemindValue {
	NSNumber *result = [self primitiveMinutesToRemind];
	return [result intValue];
}

- (void)setPrimitiveMinutesToRemindValue:(int32_t)value_ {
	[self setPrimitiveMinutesToRemind:[NSNumber numberWithInt:value_]];
}





@dynamic plannedDate;






@dynamic remind;



- (BOOL)remindValue {
	NSNumber *result = [self remind];
	return [result boolValue];
}

- (void)setRemindValue:(BOOL)value_ {
	[self setRemind:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRemindValue {
	NSNumber *result = [self primitiveRemind];
	return [result boolValue];
}

- (void)setPrimitiveRemindValue:(BOOL)value_ {
	[self setPrimitiveRemind:[NSNumber numberWithBool:value_]];
}





@dynamic version;



- (int64_t)versionValue {
	NSNumber *result = [self version];
	return [result longLongValue];
}

- (void)setVersionValue:(int64_t)value_ {
	[self setVersion:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveVersionValue {
	NSNumber *result = [self primitiveVersion];
	return [result longLongValue];
}

- (void)setPrimitiveVersionValue:(int64_t)value_ {
	[self setPrimitiveVersion:[NSNumber numberWithLongLong:value_]];
}





@dynamic address;

	

@dynamic images;

	
- (NSMutableSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	

@dynamic targets;

	
- (NSMutableSet*)targetsSet {
	[self willAccessValueForKey:@"targets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"targets"];
  
	[self didAccessValueForKey:@"targets"];
	return result;
}
	






@end
