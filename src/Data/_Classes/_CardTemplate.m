// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CardTemplate.m instead.

#import "_CardTemplate.h"

const struct CardTemplateAttributes CardTemplateAttributes = {
	.descriptionInfo = @"descriptionInfo",
	.domainType = @"domainType",
	.id = @"id",
	.isFull = @"isFull",
	.ownerID = @"ownerID",
	.style = @"style",
	.version = @"version",
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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"domainTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"domainType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isFullValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFull"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"ownerIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ownerID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"versionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"version"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic descriptionInfo;






@dynamic domainType;



- (int32_t)domainTypeValue {
	NSNumber *result = [self domainType];
	return [result intValue];
}

- (void)setDomainTypeValue:(int32_t)value_ {
	[self setDomainType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDomainTypeValue {
	NSNumber *result = [self primitiveDomainType];
	return [result intValue];
}

- (void)setPrimitiveDomainTypeValue:(int32_t)value_ {
	[self setPrimitiveDomainType:[NSNumber numberWithInt:value_]];
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





@dynamic isFull;



- (BOOL)isFullValue {
	NSNumber *result = [self isFull];
	return [result boolValue];
}

- (void)setIsFullValue:(BOOL)value_ {
	[self setIsFull:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsFullValue {
	NSNumber *result = [self primitiveIsFull];
	return [result boolValue];
}

- (void)setPrimitiveIsFullValue:(BOOL)value_ {
	[self setPrimitiveIsFull:[NSNumber numberWithBool:value_]];
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





@dynamic style;






@dynamic version;



- (int64_t)versionValue {
	NSNumber *result = [self version];
	return [result longLongValue];
}

- (void)setVersionValue:(int64_t)value_ {
	[self setVersion:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveVersionValue {
	NSNumber *result = [self primitiveVersion];
	return [result longLongValue];
}

- (void)setPrimitiveVersionValue:(int64_t)value_ {
	[self setPrimitiveVersion:[NSNumber numberWithLongLong:value_]];
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
