// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CardTemplateItem.h instead.

#import <CoreData/CoreData.h>


extern const struct CardTemplateItemAttributes {
	__unsafe_unretained NSString *fontColor;
	__unsafe_unretained NSString *fontSize;
	__unsafe_unretained NSString *fontWeight;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *originX;
	__unsafe_unretained NSString *originY;
	__unsafe_unretained NSString *rectHeight;
	__unsafe_unretained NSString *rectWidth;
	__unsafe_unretained NSString *style;
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





@property (nonatomic, strong) NSString* fontColor;



//- (BOOL)validateFontColor:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fontSize;



@property float fontSizeValue;
- (float)fontSizeValue;
- (void)setFontSizeValue:(float)value_;

//- (BOOL)validateFontSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fontWeight;



//- (BOOL)validateFontWeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* originX;



@property float originXValue;
- (float)originXValue;
- (void)setOriginXValue:(float)value_;

//- (BOOL)validateOriginX:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* originY;



@property float originYValue;
- (float)originYValue;
- (void)setOriginYValue:(float)value_;

//- (BOOL)validateOriginY:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rectHeight;



@property float rectHeightValue;
- (float)rectHeightValue;
- (void)setRectHeightValue:(float)value_;

//- (BOOL)validateRectHeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rectWidth;



@property float rectWidthValue;
- (float)rectWidthValue;
- (void)setRectWidthValue:(float)value_;

//- (BOOL)validateRectWidth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* style;



//- (BOOL)validateStyle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) CardTemplate *template;

//- (BOOL)validateTemplate:(id*)value_ error:(NSError**)error_;





@end

@interface _CardTemplateItem (CoreDataGeneratedAccessors)

@end

@interface _CardTemplateItem (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFontColor;
- (void)setPrimitiveFontColor:(NSString*)value;




- (NSNumber*)primitiveFontSize;
- (void)setPrimitiveFontSize:(NSNumber*)value;

- (float)primitiveFontSizeValue;
- (void)setPrimitiveFontSizeValue:(float)value_;




- (NSString*)primitiveFontWeight;
- (void)setPrimitiveFontWeight:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveOriginX;
- (void)setPrimitiveOriginX:(NSNumber*)value;

- (float)primitiveOriginXValue;
- (void)setPrimitiveOriginXValue:(float)value_;




- (NSNumber*)primitiveOriginY;
- (void)setPrimitiveOriginY:(NSNumber*)value;

- (float)primitiveOriginYValue;
- (void)setPrimitiveOriginYValue:(float)value_;




- (NSNumber*)primitiveRectHeight;
- (void)setPrimitiveRectHeight:(NSNumber*)value;

- (float)primitiveRectHeightValue;
- (void)setPrimitiveRectHeightValue:(float)value_;




- (NSNumber*)primitiveRectWidth;
- (void)setPrimitiveRectWidth:(NSNumber*)value;

- (float)primitiveRectWidthValue;
- (void)setPrimitiveRectWidthValue:(float)value_;




- (NSString*)primitiveStyle;
- (void)setPrimitiveStyle:(NSString*)value;





- (CardTemplate*)primitiveTemplate;
- (void)setPrimitiveTemplate:(CardTemplate*)value;


@end
