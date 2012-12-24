// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CardTemplate.h instead.

#import <CoreData/CoreData.h>


extern const struct CardTemplateAttributes {
	__unsafe_unretained NSString *descriptionInfo;
	__unsafe_unretained NSString *domainType;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *isFull;
	__unsafe_unretained NSString *ownerID;
	__unsafe_unretained NSString *style;
	__unsafe_unretained NSString *version;
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





@property (nonatomic, strong) NSString* descriptionInfo;



//- (BOOL)validateDescriptionInfo:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* domainType;



@property int32_t domainTypeValue;
- (int32_t)domainTypeValue;
- (void)setDomainTypeValue:(int32_t)value_;

//- (BOOL)validateDomainType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isFull;



@property BOOL isFullValue;
- (BOOL)isFullValue;
- (void)setIsFullValue:(BOOL)value_;

//- (BOOL)validateIsFull:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* ownerID;



@property int64_t ownerIDValue;
- (int64_t)ownerIDValue;
- (void)setOwnerIDValue:(int64_t)value_;

//- (BOOL)validateOwnerID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* style;



//- (BOOL)validateStyle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* version;



@property int64_t versionValue;
- (int64_t)versionValue;
- (void)setVersionValue:(int64_t)value_;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Image *bgImage;

//- (BOOL)validateBgImage:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *cards;

- (NSMutableSet*)cardsSet;




@property (nonatomic, strong) NSSet *items;

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


- (NSString*)primitiveDescriptionInfo;
- (void)setPrimitiveDescriptionInfo:(NSString*)value;




- (NSNumber*)primitiveDomainType;
- (void)setPrimitiveDomainType:(NSNumber*)value;

- (int32_t)primitiveDomainTypeValue;
- (void)setPrimitiveDomainTypeValue:(int32_t)value_;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSNumber*)primitiveIsFull;
- (void)setPrimitiveIsFull:(NSNumber*)value;

- (BOOL)primitiveIsFullValue;
- (void)setPrimitiveIsFullValue:(BOOL)value_;




- (NSNumber*)primitiveOwnerID;
- (void)setPrimitiveOwnerID:(NSNumber*)value;

- (int64_t)primitiveOwnerIDValue;
- (void)setPrimitiveOwnerIDValue:(int64_t)value_;




- (NSString*)primitiveStyle;
- (void)setPrimitiveStyle:(NSString*)value;




- (NSNumber*)primitiveVersion;
- (void)setPrimitiveVersion:(NSNumber*)value;

- (int64_t)primitiveVersionValue;
- (void)setPrimitiveVersionValue:(int64_t)value_;





- (Image*)primitiveBgImage;
- (void)setPrimitiveBgImage:(Image*)value;



- (NSMutableSet*)primitiveCards;
- (void)setPrimitiveCards:(NSMutableSet*)value;



- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end
