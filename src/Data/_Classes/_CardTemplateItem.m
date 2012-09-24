// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CardTemplateItem.m instead.

#import "_CardTemplateItem.h"

const struct CardTemplateItemAttributes CardTemplateItemAttributes = {
	.id = @"id",
	.name = @"name",
	.style = @"style",
};

const struct CardTemplateItemRelationships CardTemplateItemRelationships = {
	.templates = @"templates",
};

const struct CardTemplateItemFetchedProperties CardTemplateItemFetchedProperties = {
};

@implementation CardTemplateItemID
@end

@implementation _CardTemplateItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CardTemplateItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CardTemplateItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CardTemplateItem" inManagedObjectContext:moc_];
}

- (CardTemplateItemID*)objectID {
	return (CardTemplateItemID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




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





@dynamic name;






@dynamic style;






@dynamic templates;

	
- (NSMutableSet*)templatesSet {
	[self willAccessValueForKey:@"templates"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"templates"];
  
	[self didAccessValueForKey:@"templates"];
	return result;
}
	






@end
