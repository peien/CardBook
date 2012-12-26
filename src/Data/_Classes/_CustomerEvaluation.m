// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CustomerEvaluation.m instead.

#import "_CustomerEvaluation.h"

const struct CustomerEvaluationAttributes CustomerEvaluationAttributes = {
	.degree = @"degree",
	.firstMeetAddress = @"firstMeetAddress",
	.firstMeetDate = @"firstMeetDate",
	.id = @"id",
	.remarks = @"remarks",
	.value = @"value",
	.version = @"version",
};

const struct CustomerEvaluationRelationships CustomerEvaluationRelationships = {
	.customerCard = @"customerCard",
};

const struct CustomerEvaluationFetchedProperties CustomerEvaluationFetchedProperties = {
};

@implementation CustomerEvaluationID
@end

@implementation _CustomerEvaluation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CustomerEvaluation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CustomerEvaluation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CustomerEvaluation" inManagedObjectContext:moc_];
}

- (CustomerEvaluationID*)objectID {
	return (CustomerEvaluationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"degreeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"degree"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
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




@dynamic degree;



- (float)degreeValue {
	NSNumber *result = [self degree];
	return [result floatValue];
}

- (void)setDegreeValue:(float)value_ {
	[self setDegree:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDegreeValue {
	NSNumber *result = [self primitiveDegree];
	return [result floatValue];
}

- (void)setPrimitiveDegreeValue:(float)value_ {
	[self setPrimitiveDegree:[NSNumber numberWithFloat:value_]];
}





@dynamic firstMeetAddress;






@dynamic firstMeetDate;






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





@dynamic remarks;






@dynamic value;



- (float)valueValue {
	NSNumber *result = [self value];
	return [result floatValue];
}

- (void)setValueValue:(float)value_ {
	[self setValue:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result floatValue];
}

- (void)setPrimitiveValueValue:(float)value_ {
	[self setPrimitiveValue:[NSNumber numberWithFloat:value_]];
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





@dynamic customerCard;

	






@end
