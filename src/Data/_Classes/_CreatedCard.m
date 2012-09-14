// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CreatedCard.m instead.

#import "_CreatedCard.h"

const struct CreatedCardAttributes CreatedCardAttributes = {
};

const struct CreatedCardRelationships CreatedCardRelationships = {
};

const struct CreatedCardFetchedProperties CreatedCardFetchedProperties = {
};

@implementation CreatedCardID
@end

@implementation _CreatedCard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CreatedCard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CreatedCard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CreatedCard" inManagedObjectContext:moc_];
}

- (CreatedCardID*)objectID {
	return (CreatedCardID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
