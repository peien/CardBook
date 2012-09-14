// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Schedule.h instead.

#import <CoreData/CoreData.h>


extern const struct ScheduleAttributes {
	__unsafe_unretained NSString *companions;
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *id;
} ScheduleAttributes;

extern const struct ScheduleRelationships {
	__unsafe_unretained NSString *images;
	__unsafe_unretained NSString *targets;
} ScheduleRelationships;

extern const struct ScheduleFetchedProperties {
} ScheduleFetchedProperties;

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




@property (nonatomic, strong) NSString* date;


//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* id;


@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* images;

- (NSMutableSet*)imagesSet;




@property (nonatomic, strong) NSSet* targets;

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




- (NSString*)primitiveDate;
- (void)setPrimitiveDate:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;





- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTargets;
- (void)setPrimitiveTargets:(NSMutableSet*)value;


@end
