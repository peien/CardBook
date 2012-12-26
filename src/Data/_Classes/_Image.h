// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.h instead.

#import <CoreData/CoreData.h>


extern const struct ImageAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *url;
} ImageAttributes;

extern const struct ImageRelationships {
	__unsafe_unretained NSString *cardsWithFrame;
	__unsafe_unretained NSString *cardsWithLogo;
	__unsafe_unretained NSString *companies;
	__unsafe_unretained NSString *messages;
	__unsafe_unretained NSString *schedules;
	__unsafe_unretained NSString *templates;
} ImageRelationships;

extern const struct ImageFetchedProperties {
} ImageFetchedProperties;

@class Card;
@class Card;
@class Company;
@class KHHMessage;
@class Schedule;
@class CardTemplate;




@interface ImageID : NSManagedObjectID {}
@end

@interface _Image : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ImageID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *cardsWithFrame;

- (NSMutableSet*)cardsWithFrameSet;




@property (nonatomic, strong) NSSet *cardsWithLogo;

- (NSMutableSet*)cardsWithLogoSet;




@property (nonatomic, strong) NSSet *companies;

- (NSMutableSet*)companiesSet;




@property (nonatomic, strong) NSSet *messages;

- (NSMutableSet*)messagesSet;




@property (nonatomic, strong) NSSet *schedules;

- (NSMutableSet*)schedulesSet;




@property (nonatomic, strong) NSSet *templates;

- (NSMutableSet*)templatesSet;





@end

@interface _Image (CoreDataGeneratedAccessors)

- (void)addCardsWithFrame:(NSSet*)value_;
- (void)removeCardsWithFrame:(NSSet*)value_;
- (void)addCardsWithFrameObject:(Card*)value_;
- (void)removeCardsWithFrameObject:(Card*)value_;

- (void)addCardsWithLogo:(NSSet*)value_;
- (void)removeCardsWithLogo:(NSSet*)value_;
- (void)addCardsWithLogoObject:(Card*)value_;
- (void)removeCardsWithLogoObject:(Card*)value_;

- (void)addCompanies:(NSSet*)value_;
- (void)removeCompanies:(NSSet*)value_;
- (void)addCompaniesObject:(Company*)value_;
- (void)removeCompaniesObject:(Company*)value_;

- (void)addMessages:(NSSet*)value_;
- (void)removeMessages:(NSSet*)value_;
- (void)addMessagesObject:(KHHMessage*)value_;
- (void)removeMessagesObject:(KHHMessage*)value_;

- (void)addSchedules:(NSSet*)value_;
- (void)removeSchedules:(NSSet*)value_;
- (void)addSchedulesObject:(Schedule*)value_;
- (void)removeSchedulesObject:(Schedule*)value_;

- (void)addTemplates:(NSSet*)value_;
- (void)removeTemplates:(NSSet*)value_;
- (void)addTemplatesObject:(CardTemplate*)value_;
- (void)removeTemplatesObject:(CardTemplate*)value_;

@end

@interface _Image (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveCardsWithFrame;
- (void)setPrimitiveCardsWithFrame:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCardsWithLogo;
- (void)setPrimitiveCardsWithLogo:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCompanies;
- (void)setPrimitiveCompanies:(NSMutableSet*)value;



- (NSMutableSet*)primitiveMessages;
- (void)setPrimitiveMessages:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSchedules;
- (void)setPrimitiveSchedules:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTemplates;
- (void)setPrimitiveTemplates:(NSMutableSet*)value;


@end
