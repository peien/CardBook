// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.m instead.

#import "_Image.h"

const struct ImageAttributes ImageAttributes = {
	.id = @"id",
	.url = @"url",
};

const struct ImageRelationships ImageRelationships = {
	.cardsWithFrame = @"cardsWithFrame",
	.cardsWithLogo = @"cardsWithLogo",
	.companies = @"companies",
	.messages = @"messages",
	.schedules = @"schedules",
	.templates = @"templates",
};

const struct ImageFetchedProperties ImageFetchedProperties = {
};

@implementation ImageID
@end

@implementation _Image

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Image";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Image" inManagedObjectContext:moc_];
}

- (ImageID*)objectID {
	return (ImageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
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





@dynamic url;






@dynamic cardsWithFrame;

	
- (NSMutableSet*)cardsWithFrameSet {
	[self willAccessValueForKey:@"cardsWithFrame"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"cardsWithFrame"];
  
	[self didAccessValueForKey:@"cardsWithFrame"];
	return result;
}
	

@dynamic cardsWithLogo;

	
- (NSMutableSet*)cardsWithLogoSet {
	[self willAccessValueForKey:@"cardsWithLogo"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"cardsWithLogo"];
  
	[self didAccessValueForKey:@"cardsWithLogo"];
	return result;
}
	

@dynamic companies;

	
- (NSMutableSet*)companiesSet {
	[self willAccessValueForKey:@"companies"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"companies"];
  
	[self didAccessValueForKey:@"companies"];
	return result;
}
	

@dynamic messages;

	
- (NSMutableSet*)messagesSet {
	[self willAccessValueForKey:@"messages"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"messages"];
  
	[self didAccessValueForKey:@"messages"];
	return result;
}
	

@dynamic schedules;

	
- (NSMutableSet*)schedulesSet {
	[self willAccessValueForKey:@"schedules"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"schedules"];
  
	[self didAccessValueForKey:@"schedules"];
	return result;
}
	

@dynamic templates;

	
- (NSMutableSet*)templatesSet {
	[self willAccessValueForKey:@"templates"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"templates"];
  
	[self didAccessValueForKey:@"templates"];
	return result;
}
	






@end
