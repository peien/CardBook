// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Message.h instead.

#import <CoreData/CoreData.h>


extern const struct MessageAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *subject;
	__unsafe_unretained NSString *time;
	__unsafe_unretained NSString *version;
} MessageAttributes;

extern const struct MessageRelationships {
	__unsafe_unretained NSString *image;
} MessageRelationships;

extern const struct MessageFetchedProperties {
} MessageFetchedProperties;

@class Image;







@interface MessageID : NSManagedObjectID {}
@end

@interface _Message : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MessageID*)objectID;




@property (nonatomic, strong) NSString* content;


//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* id;


@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* subject;


//- (BOOL)validateSubject:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* time;


//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* version;


@property int32_t versionValue;
- (int32_t)versionValue;
- (void)setVersionValue:(int32_t)value_;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Image* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@end

@interface _Message (CoreDataGeneratedAccessors)

@end

@interface _Message (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveSubject;
- (void)setPrimitiveSubject:(NSString*)value;




- (NSString*)primitiveTime;
- (void)setPrimitiveTime:(NSString*)value;




- (NSNumber*)primitiveVersion;
- (void)setPrimitiveVersion:(NSNumber*)value;

- (int32_t)primitiveVersionValue;
- (void)setPrimitiveVersionValue:(int32_t)value_;





- (Image*)primitiveImage;
- (void)setPrimitiveImage:(Image*)value;


@end
