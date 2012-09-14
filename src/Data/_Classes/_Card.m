// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Card.m instead.

#import "_Card.h"

const struct CardAttributes CardAttributes = {
	.aliWangWang = @"aliWangWang",
	.businessScope = @"businessScope",
	.customerServiceTel = @"customerServiceTel",
	.department = @"department",
	.email = @"email",
	.factoryAddress = @"factoryAddress",
	.fax = @"fax",
	.id = @"id",
	.microblog = @"microblog",
	.mobilePhone = @"mobilePhone",
	.moreInfo = @"moreInfo",
	.msn = @"msn",
	.name = @"name",
	.officeEmail = @"officeEmail",
	.qq = @"qq",
	.remarks = @"remarks",
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"userIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"versionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"version"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic aliWangWang;






@dynamic businessScope;






@dynamic customerServiceTel;






@dynamic department;






@dynamic email;






@dynamic factoryAddress;






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





@dynamic microblog;






@dynamic mobilePhone;






@dynamic moreInfo;






@dynamic msn;






@dynamic name;






@dynamic officeEmail;






@dynamic qq;






@dynamic remarks;






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
