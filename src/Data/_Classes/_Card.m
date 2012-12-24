// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Card.m instead.

#import "_Card.h"

const struct CardAttributes CardAttributes = {
	.aliWangWang = @"aliWangWang",
	.businessScope = @"businessScope",
	.department = @"department",
	.email = @"email",
	.fax = @"fax",
	.id = @"id",
	.isFull = @"isFull",
	.isRead = @"isRead",
	.microblog = @"microblog",
	.mobilePhone = @"mobilePhone",
	.modelType = @"modelType",
	.moreInfo = @"moreInfo",
	.msn = @"msn",
	.name = @"name",
	.qq = @"qq",
	.remarks = @"remarks",
	.roleType = @"roleType",
	.telephone = @"telephone",
	.title = @"title",
	.userID = @"userID",
	.version = @"version",
	.web = @"web",
};

const struct CardRelationships CardRelationships = {
	.address = @"address",
	.bankAccount = @"bankAccount",
	.company = @"company",
	.evaluation = @"evaluation",
	.frames = @"frames",
	.groups = @"groups",
	.logo = @"logo",
	.schedules = @"schedules",
	.template = @"template",
};

const struct CardFetchedProperties CardFetchedProperties = {
};

@implementation CardID
@end

@implementation _Card

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Card";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Card" inManagedObjectContext:moc_];
}

- (CardID*)objectID {
	return (CardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
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
	if ([key isEqualToString:@"isReadValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isRead"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"modelTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"modelType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"roleTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"roleType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"userIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userID"];
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




@dynamic aliWangWang;






@dynamic businessScope;






@dynamic department;






@dynamic email;






@dynamic fax;






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





@dynamic isRead;



- (BOOL)isReadValue {
	NSNumber *result = [self isRead];
	return [result boolValue];
}

- (void)setIsReadValue:(BOOL)value_ {
	[self setIsRead:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsReadValue {
	NSNumber *result = [self primitiveIsRead];
	return [result boolValue];
}

- (void)setPrimitiveIsReadValue:(BOOL)value_ {
	[self setPrimitiveIsRead:[NSNumber numberWithBool:value_]];
}





@dynamic microblog;






@dynamic mobilePhone;






@dynamic modelType;



- (int32_t)modelTypeValue {
	NSNumber *result = [self modelType];
	return [result intValue];
}

- (void)setModelTypeValue:(int32_t)value_ {
	[self setModelType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveModelTypeValue {
	NSNumber *result = [self primitiveModelType];
	return [result intValue];
}

- (void)setPrimitiveModelTypeValue:(int32_t)value_ {
	[self setPrimitiveModelType:[NSNumber numberWithInt:value_]];
}





@dynamic moreInfo;






@dynamic msn;






@dynamic name;






@dynamic qq;






@dynamic remarks;






@dynamic roleType;



- (int32_t)roleTypeValue {
	NSNumber *result = [self roleType];
	return [result intValue];
}

- (void)setRoleTypeValue:(int32_t)value_ {
	[self setRoleType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRoleTypeValue {
	NSNumber *result = [self primitiveRoleType];
	return [result intValue];
}

- (void)setPrimitiveRoleTypeValue:(int32_t)value_ {
	[self setPrimitiveRoleType:[NSNumber numberWithInt:value_]];
}





@dynamic telephone;






@dynamic title;






@dynamic userID;



- (int64_t)userIDValue {
	NSNumber *result = [self userID];
	return [result longLongValue];
}

- (void)setUserIDValue:(int64_t)value_ {
	[self setUserID:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveUserIDValue {
	NSNumber *result = [self primitiveUserID];
	return [result longLongValue];
}

- (void)setPrimitiveUserIDValue:(int64_t)value_ {
	[self setPrimitiveUserID:[NSNumber numberWithLongLong:value_]];
}





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





@dynamic web;






@dynamic address;

	

@dynamic bankAccount;

	

@dynamic company;

	

@dynamic evaluation;

	

@dynamic frames;

	
- (NSMutableSet*)framesSet {
	[self willAccessValueForKey:@"frames"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"frames"];
  
	[self didAccessValueForKey:@"frames"];
	return result;
}
	

@dynamic groups;

	
- (NSMutableSet*)groupsSet {
	[self willAccessValueForKey:@"groups"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"groups"];
  
	[self didAccessValueForKey:@"groups"];
	return result;
}
	

@dynamic logo;

	

@dynamic schedules;

	
- (NSMutableSet*)schedulesSet {
	[self willAccessValueForKey:@"schedules"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"schedules"];
  
	[self didAccessValueForKey:@"schedules"];
	return result;
}
	

@dynamic template;

	






@end
