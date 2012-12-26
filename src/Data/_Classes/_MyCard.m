// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MyCard.m instead.

#import "_MyCard.h"

const struct MyCardAttributes MyCardAttributes = {
};

const struct MyCardRelationships MyCardRelationships = {
};

const struct MyCardFetchedProperties MyCardFetchedProperties = {
};

@implementation MyCardID
@end

@implementation _MyCard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MyCard" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MyCard";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MyCard" inManagedObjectContext:moc_];
}

- (MyCardID*)objectID {
	return (MyCardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
