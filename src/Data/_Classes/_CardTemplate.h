// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CardTemplate.h instead.

#import <CoreData/CoreData.h>


extern const struct CardTemplateAttributes {
	__unsafe_unretained NSString *atime;
	__unsafe_unretained NSString *ctime;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *ownerID;
	__unsafe_unretained NSString *type;
} CardTemplateAttributes;

extern const struct CardTemplateRelationships {
	__unsafe_unretained NSString *bgImage;
	__unsafe_unretained NSString *cards;
	__unsafe_unretained NSString *items;
} CardTemplateRelationships;

extern const struct CardTemplateFetchedProperties {
} CardTemplateFetchedProperties;

@class Image;
@class Card;
@class CardTemplateItem;







@interface CardTemplateID : NSManagedObjectID {}
@end

@interface _CardTemplate : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CardTemplateID*)objectID;




@property (nonatomic, strong) NSString* atime;


//- (BOOL)validateAtime:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* ctime;


//- (BOOL)validateCtime:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* id;


@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* ownerID;


@property int64_t ownerIDValue;
- (int64_t)ownerIDValue;
- (void)setOwnerIDValue:(int64_t)value_;

//- (BOOL)validateOwnerID:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* type;


@property int32_t typeValue;
- (int32_t)typeValue;
- (void)setTypeValue:(int32_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Image* bgImage;

//- (BOOL)validateBgImage:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet* cards;

- (NSMutableSet*)cardsSet;




@property (nonatomic, strong) NSSet* items;

- (NSMutableSet*)itemsSet;





@end

@interface _CardTemplate (CoreDataGeneratedAccessors)

- (void)addCards:(NSSet*)value_;
- (void)removeCards:(NSSet*)value_;
- (void)addCardsObject:(Card*)value_;
- (void)removeCardsObject:(Card*)value_;

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(CardTemplateItem*)value_;
- (void)removeItemsObject:(CardTemplateItem*)value_;

@end

@interface _CardTemplate (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAtime;
- (void)setPrimitiveAtime:(NSString*)value;




- (NSString*)primitiveCtime;
- (void)setPrimitiveCtime:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSNumber*)primitiveOwnerID;
- (void)setPrimitiveOwnerID:(NSNumber*)value;

- (int64_t)primitiveOwnerIDValue;
- (void)setPrimitiveOwnerIDValue:(int64_t)value_;




- (NSNumber*)primitiveType;
- (void)setPrimitiveType:(NSNumber*)value;

- (int32_t)primitiveTypeValue;
- (void)setPrimitiveTypeValue:(int32_t)value_;





- (Image*)primitiveBgImage;
- (void)setPrimitiveBgImage:(Image*)value;



- (NSMutableSet*)primitiveCards;
- (void)setPrimitiveCards:(NSMutableSet*)value;



- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end
