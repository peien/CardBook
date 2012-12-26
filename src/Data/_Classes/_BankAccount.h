// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BankAccount.h instead.

#import <CoreData/CoreData.h>


extern const struct BankAccountAttributes {
	__unsafe_unretained NSString *bank;
	__unsafe_unretained NSString *branch;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *number;
} BankAccountAttributes;

extern const struct BankAccountRelationships {
	__unsafe_unretained NSString *cards;
} BankAccountRelationships;

extern const struct BankAccountFetchedProperties {
} BankAccountFetchedProperties;

@class Card;






@interface BankAccountID : NSManagedObjectID {}
@end

@interface _BankAccount : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BankAccountID*)objectID;





@property (nonatomic, strong) NSString* bank;



//- (BOOL)validateBank:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* branch;



//- (BOOL)validateBranch:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* number;



//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *cards;

- (NSMutableSet*)cardsSet;





@end

@interface _BankAccount (CoreDataGeneratedAccessors)

- (void)addCards:(NSSet*)value_;
- (void)removeCards:(NSSet*)value_;
- (void)addCardsObject:(Card*)value_;
- (void)removeCardsObject:(Card*)value_;

@end

@interface _BankAccount (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBank;
- (void)setPrimitiveBank:(NSString*)value;




- (NSString*)primitiveBranch;
- (void)setPrimitiveBranch:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveNumber;
- (void)setPrimitiveNumber:(NSString*)value;





- (NSMutableSet*)primitiveCards;
- (void)setPrimitiveCards:(NSMutableSet*)value;


@end
