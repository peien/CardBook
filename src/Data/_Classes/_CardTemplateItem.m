// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CardTemplateItem.m instead.

#import "_CardTemplateItem.h"

const struct CardTemplateItemAttributes CardTemplateItemAttributes = {
	.fontColor = @"fontColor",
	.fontSize = @"fontSize",
	.fontWeight = @"fontWeight",
	.id = @"id",
	.name = @"name",
	.originX = @"originX",
	.originY = @"originY",
	.rectHeight = @"rectHeight",
	.rectWidth = @"rectWidth",
	.style = @"style",
};

const struct CardTemplateItemRelationships CardTemplateItemRelationships = {
	.template = @"template",
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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"fontSizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fontSize"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"originXValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"originX"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"originYValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"originY"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"rectHeightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rectHeight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"rectWidthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rectWidth"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic fontColor;






@dynamic fontSize;



- (float)fontSizeValue {
	NSNumber *result = [self fontSize];
	return [result floatValue];
}

- (void)setFontSizeValue:(float)value_ {
	[self setFontSize:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveFontSizeValue {
	NSNumber *result = [self primitiveFontSize];
	return [result floatValue];
}

- (void)setPrimitiveFontSizeValue:(float)value_ {
	[self setPrimitiveFontSize:[NSNumber numberWithFloat:value_]];
}





@dynamic fontWeight;






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






@dynamic originX;



- (float)originXValue {
	NSNumber *result = [self originX];
	return [result floatValue];
}

- (void)setOriginXValue:(float)value_ {
	[self setOriginX:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveOriginXValue {
	NSNumber *result = [self primitiveOriginX];
	return [result floatValue];
}

- (void)setPrimitiveOriginXValue:(float)value_ {
	[self setPrimitiveOriginX:[NSNumber numberWithFloat:value_]];
}





@dynamic originY;



- (float)originYValue {
	NSNumber *result = [self originY];
	return [result floatValue];
}

- (void)setOriginYValue:(float)value_ {
	[self setOriginY:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveOriginYValue {
	NSNumber *result = [self primitiveOriginY];
	return [result floatValue];
}

- (void)setPrimitiveOriginYValue:(float)value_ {
	[self setPrimitiveOriginY:[NSNumber numberWithFloat:value_]];
}





@dynamic rectHeight;



- (float)rectHeightValue {
	NSNumber *result = [self rectHeight];
	return [result floatValue];
}

- (void)setRectHeightValue:(float)value_ {
	[self setRectHeight:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveRectHeightValue {
	NSNumber *result = [self primitiveRectHeight];
	return [result floatValue];
}

- (void)setPrimitiveRectHeightValue:(float)value_ {
	[self setPrimitiveRectHeight:[NSNumber numberWithFloat:value_]];
}





@dynamic rectWidth;



- (float)rectWidthValue {
	NSNumber *result = [self rectWidth];
	return [result floatValue];
}

- (void)setRectWidthValue:(float)value_ {
	[self setRectWidth:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveRectWidthValue {
	NSNumber *result = [self primitiveRectWidth];
	return [result floatValue];
}

- (void)setPrimitiveRectWidthValue:(float)value_ {
	[self setPrimitiveRectWidth:[NSNumber numberWithFloat:value_]];
}





@dynamic style;






@dynamic template;

	






@end
