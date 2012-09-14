// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CardTemplate.m instead.

#import "_CardTemplate.h"

const struct CardTemplateAttributes CardTemplateAttributes = {
	.atime = @"atime",
	.ctime = @"ctime",
	.id = @"id",
	.ownerID = @"ownerID",
	.type = @"type",
};

const struct CardTemplateRelationships CardTemplateRelationships = {
	.bgImage = @"bgImage",
	.cards = @"cards",
	.items = @"items",
};

const struct CardTemplateFetchedProperties CardTemplateFetchedProperties = {
};

@implementation CardTemplateID
@end

@implementation _CardTemplate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CardTemplate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CardTemplate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CardTemplate" inManagedObjectContext:moc_];
}

- (CardTemplateID*)objectID {
	return (CardTemplateID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"ownerIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ownerID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic atime;






@dynamic ctime;






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





@dynamic ownerID;



- (int64_t)ownerIDValue {
	NSNumber *result = [self ownerID];
	return [result longLongValue];
}

- (void)setOwnerIDValue:(int64_t)value_ {
	[self setOwnerID:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveOwnerIDValue {
	NSNumber *result = [self primitiveOwnerID];
	return [result longLongValue];
}

- (void)setPrimitiveOwnerIDValue:(int64_t)value_ {
	[self setPrimitiveOwnerID:[NSNumber numberWithLongLong:value_]];
}





@dynamic type;



- (int32_t)typeValue {
	NSNumber *result = [self type];
	return [result intValue];
}

- (void)setTypeValue:(int32_t)value_ {
	[self setType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTypeValue {
	NSNumber *result = [self primitiveType];
	return [result intValue];
}

- (void)setPrimitiveTypeValue:(int32_t)value_ {
	[self setPrimitiveType:[NSNumber numberWithInt:value_]];
}





@dynamic bgImage;

	

@dynamic cards;

	
- (NSMutableSet*)cardsSet {
	[self willAccessValueForKey:@"cards"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"cards"];
  
	[self didAccessValueForKey:@"cards"];
	return result;
}
	

@dynamic items;

	
- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];
  
	[self didAccessValueForKey:@"items"];
	return result;
}
	






@end
