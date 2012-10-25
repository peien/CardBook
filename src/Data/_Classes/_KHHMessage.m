// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KHHMessage.m instead.

#import "_KHHMessage.h"

const struct KHHMessageAttributes KHHMessageAttributes = {
	.content = @"content",
	.id = @"id",
	.subject = @"subject",
	.time = @"time",
	.version = @"version",
};

const struct KHHMessageRelationships KHHMessageRelationships = {
	.image = @"image",
};

const struct KHHMessageFetchedProperties KHHMessageFetchedProperties = {
};

@implementation KHHMessageID
@end

@implementation _KHHMessage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KHHMessage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KHHMessage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KHHMessage" inManagedObjectContext:moc_];
}

- (KHHMessageID*)objectID {
	return (KHHMessageID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"versionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"version"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic content;






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





@dynamic subject;






@dynamic time;






@dynamic version;



- (int32_t)versionValue {
	NSNumber *result = [self version];
	return [result intValue];
}

- (void)setVersionValue:(int32_t)value_ {
	[self setVersion:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveVersionValue {
	NSNumber *result = [self primitiveVersion];
	return [result intValue];
}

- (void)setPrimitiveVersionValue:(int32_t)value_ {
	[self setPrimitiveVersion:[NSNumber numberWithInt:value_]];
}





@dynamic image;

	






@end
