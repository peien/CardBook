// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Schedule.h instead.

#import <CoreData/CoreData.h>


extern const struct ScheduleAttributes {
	__unsafe_unretained NSString *companions;
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *customer;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *isFinished;
	__unsafe_unretained NSString *minutesToRemind;
	__unsafe_unretained NSString *plannedDate;
	__unsafe_unretained NSString *remind;
	__unsafe_unretained NSString *version;
} ScheduleAttributes;

extern const struct ScheduleRelationships {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *images;
	__unsafe_unretained NSString *targets;
} ScheduleRelationships;

extern const struct ScheduleFetchedProperties {
} ScheduleFetchedProperties;

@class Address;
@class Image;
@class Card;











@interface ScheduleID : NSManagedObjectID {}
@end

@interface _Schedule : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ScheduleID*)objectID;





@property (nonatomic, strong) NSString* companions;



//- (BOOL)validateCompanions:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* content;



//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* customer;



//- (BOOL)validateCustomer:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isFinished;



@property BOOL isFinishedValue;
- (BOOL)isFinishedValue;
- (void)setIsFinishedValue:(BOOL)value_;

//- (BOOL)validateIsFinished:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* minutesToRemind;



@property int32_t minutesToRemindValue;
- (int32_t)minutesToRemindValue;
- (void)setMinutesToRemindValue:(int32_t)value_;

//- (BOOL)validateMinutesToRemind:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* plannedDate;



//- (BOOL)validatePlannedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* remind;



@property BOOL remindValue;
- (BOOL)remindValue;
- (void)setRemindValue:(BOOL)value_;

//- (BOOL)validateRemind:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* version;



@property int64_t versionValue;
- (int64_t)versionValue;
- (void)setVersionValue:(int64_t)value_;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Address *address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *images;

- (NSMutableSet*)imagesSet;




@property (nonatomic, strong) NSSet *targets;

- (NSMutableSet*)targetsSet;





@end

@interface _Schedule (CoreDataGeneratedAccessors)

- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(Image*)value_;
- (void)removeImagesObject:(Image*)value_;

- (void)addTargets:(NSSet*)value_;
- (void)removeTargets:(NSSet*)value_;
- (void)addTargetsObject:(Card*)value_;
- (void)removeTargetsObject:(Card*)value_;

@end

@interface _Schedule (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCompanions;
- (void)setPrimitiveCompanions:(NSString*)value;




- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;




- (NSString*)primitiveCustomer;
- (void)setPrimitiveCustomer:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSNumber*)primitiveIsFinished;
- (void)setPrimitiveIsFinished:(NSNumber*)value;

- (BOOL)primitiveIsFinishedValue;
- (void)setPrimitiveIsFinishedValue:(BOOL)value_;




- (NSNumber*)primitiveMinutesToRemind;
- (void)setPrimitiveMinutesToRemind:(NSNumber*)value;

- (int32_t)primitiveMinutesToRemindValue;
- (void)setPrimitiveMinutesToRemindValue:(int32_t)value_;




- (NSDate*)primitivePlannedDate;
- (void)setPrimitivePlannedDate:(NSDate*)value;




- (NSNumber*)primitiveRemind;
- (void)setPrimitiveRemind:(NSNumber*)value;

- (BOOL)primitiveRemindValue;
- (void)setPrimitiveRemindValue:(BOOL)value_;




- (NSNumber*)primitiveVersion;
- (void)setPrimitiveVersion:(NSNumber*)value;

- (int64_t)primitiveVersionValue;
- (void)setPrimitiveVersionValue:(int64_t)value_;





- (Address*)primitiveAddress;
- (void)setPrimitiveAddress:(Address*)value;



- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTargets;
- (void)setPrimitiveTargets:(NSMutableSet*)value;


@end
