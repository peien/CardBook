// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PrivateCard.m instead.

#import "_PrivateCard.h"

const struct PrivateCardAttributes PrivateCardAttributes = {
};

const struct PrivateCardRelationships PrivateCardRelationships = {
};

const struct PrivateCardFetchedProperties PrivateCardFetchedProperties = {
};

@implementation PrivateCardID
@end

@implementation _PrivateCard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PrivateCard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PrivateCard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PrivateCard" inManagedObjectContext:moc_];
}

- (PrivateCardID*)objectID {
	return (PrivateCardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
