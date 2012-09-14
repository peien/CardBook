// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CardTemplateItem.h instead.

#import <CoreData/CoreData.h>


extern const struct CardTemplateItemAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} CardTemplateItemAttributes;

extern const struct CardTemplateItemRelationships {
	__unsafe_unretained NSString *template;
} CardTemplateItemRelationships;

extern const struct CardTemplateItemFetchedProperties {
} CardTemplateItemFetchedProperties;

@class CardTemplate;




@interface CardTemplateItemID : NSManagedObjectID {}
@end

@interface _CardTemplateItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CardTemplateItemID*)objectID;




@property (nonatomic, strong) NSNumber* id;


@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) CardTemplate* template;

//- (BOOL)validateTemplate:(id*)value_ error:(NSError**)error_;





@end

@interface _CardTemplateItem (CoreDataGeneratedAccessors)

@end

@interface _CardTemplateItem (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (CardTemplate*)primitiveTemplate;
- (void)setPrimitiveTemplate:(CardTemplate*)value;


@end
