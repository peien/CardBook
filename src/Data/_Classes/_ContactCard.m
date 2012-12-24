// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ContactCard.m instead.

#import "_ContactCard.h"

const struct ContactCardAttributes ContactCardAttributes = {
};

const struct ContactCardRelationships ContactCardRelationships = {
};

const struct ContactCardFetchedProperties ContactCardFetchedProperties = {
};

@implementation ContactCardID
@end

@implementation _ContactCard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ContactCard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ContactCard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ContactCard" inManagedObjectContext:moc_];
}

- (ContactCardID*)objectID {
	return (ContactCardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
