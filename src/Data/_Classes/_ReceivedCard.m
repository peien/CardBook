// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ReceivedCard.m instead.

#import "_ReceivedCard.h"

const struct ReceivedCardAttributes ReceivedCardAttributes = {
	.isRead = @"isRead",
	.memo = @"memo",
};

const struct ReceivedCardRelationships ReceivedCardRelationships = {
};

const struct ReceivedCardFetchedProperties ReceivedCardFetchedProperties = {
};

@implementation ReceivedCardID
@end

@implementation _ReceivedCard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ReceivedCard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ReceivedCard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ReceivedCard" inManagedObjectContext:moc_];
}

- (ReceivedCardID*)objectID {
	return (ReceivedCardID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isReadValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isRead"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic isRead;



- (BOOL)isReadValue {
	NSNumber *result = [self isRead];
	return [result boolValue];
}

- (void)setIsReadValue:(BOOL)value_ {
	[self setIsRead:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsReadValue {
	NSNumber *result = [self primitiveIsRead];
	return [result boolValue];
}

- (void)setPrimitiveIsReadValue:(BOOL)value_ {
	[self setPrimitiveIsRead:[NSNumber numberWithBool:value_]];
}





@dynamic memo;











@end
