// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Schedule.m instead.

#import "_Schedule.h"

const struct ScheduleAttributes ScheduleAttributes = {
	.companions = @"companions",
	.content = @"content",
	.date = @"date",
	.id = @"id",
};

const struct ScheduleRelationships ScheduleRelationships = {
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic companions;






@dynamic content;






@dynamic date;






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
