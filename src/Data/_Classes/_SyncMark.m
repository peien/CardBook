// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncMark.m instead.

#import "_SyncMark.h"

const struct SyncMarkAttributes SyncMarkAttributes = {
	.key = @"key",
	.value = @"value",
};

const struct SyncMarkRelationships SyncMarkRelationships = {
};

const struct SyncMarkFetchedProperties SyncMarkFetchedProperties = {
};

@implementation SyncMarkID
@end

@implementation _SyncMark

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SyncMark" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SyncMark";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SyncMark" inManagedObjectContext:moc_];
}

- (SyncMarkID*)objectID {
	return (SyncMarkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic key;






@dynamic value;











@end
