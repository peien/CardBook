// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BankAccount.m instead.

#import "_BankAccount.h"

const struct BankAccountAttributes BankAccountAttributes = {
	.bank = @"bank",
	.branch = @"branch",
	.name = @"name",
	.number = @"number",
};

const struct BankAccountRelationships BankAccountRelationships = {
	.cards = @"cards",
};

const struct BankAccountFetchedProperties BankAccountFetchedProperties = {
};

@implementation BankAccountID
@end

@implementation _BankAccount

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BankAccount" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BankAccount";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BankAccount" inManagedObjectContext:moc_];
}

- (BankAccountID*)objectID {
	return (BankAccountID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic bank;






@dynamic branch;






@dynamic name;






@dynamic number;






@dynamic cards;

	
- (NSMutableSet*)cardsSet {
	[self willAccessValueForKey:@"cards"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"cards"];
  
	[self didAccessValueForKey:@"cards"];
	return result;
}
	






@end
