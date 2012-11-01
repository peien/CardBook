// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KHHMessage.m instead.

#import "_KHHMessage.h"

const struct KHHMessageAttributes KHHMessageAttributes = {
	.company = @"company",
	.content = @"content",
	.id = @"id",
	.subject = @"subject",
	.time = @"time",
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

	return keyPaths;
}




@dynamic company;






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






@dynamic image;

	






@end
