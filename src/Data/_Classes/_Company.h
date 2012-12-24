// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Company.h instead.

#import <CoreData/CoreData.h>


extern const struct CompanyAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} CompanyAttributes;

extern const struct CompanyRelationships {
	__unsafe_unretained NSString *cards;
	__unsafe_unretained NSString *logo;
} CompanyRelationships;

extern const struct CompanyFetchedProperties {
} CompanyFetchedProperties;

@class Card;
@class Image;





@interface CompanyID : NSManagedObjectID {}
@end

@interface _Company : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CompanyID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *cards;

- (NSMutableSet*)cardsSet;




@property (nonatomic, strong) Image *logo;

//- (BOOL)validateLogo:(id*)value_ error:(NSError**)error_;





@end

@interface _Company (CoreDataGeneratedAccessors)

- (void)addCards:(NSSet*)value_;
- (void)removeCards:(NSSet*)value_;
- (void)addCardsObject:(Card*)value_;
- (void)removeCardsObject:(Card*)value_;

@end

@interface _Company (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveCards;
- (void)setPrimitiveCards:(NSMutableSet*)value;



- (Image*)primitiveLogo;
- (void)setPrimitiveLogo:(Image*)value;


@end
