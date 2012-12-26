// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Address.m instead.

#import "_Address.h"

const struct AddressAttributes AddressAttributes = {
	.city = @"city",
	.country = @"country",
	.district = @"district",
	.other = @"other",
	.province = @"province",
	.street = @"street",
	.zip = @"zip",
};

const struct AddressRelationships AddressRelationships = {
	.card = @"card",
	.schedule = @"schedule",
};

const struct AddressFetchedProperties AddressFetchedProperties = {
};

@implementation AddressID
@end

@implementation _Address

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Address";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Address" inManagedObjectContext:moc_];
}

- (AddressID*)objectID {
	return (AddressID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic city;






@dynamic country;






@dynamic district;






@dynamic other;






@dynamic province;






@dynamic street;






@dynamic zip;






@dynamic card;

	

@dynamic schedule;

	






@end
