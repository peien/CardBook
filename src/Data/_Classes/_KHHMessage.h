// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KHHMessage.h instead.

#import <CoreData/CoreData.h>


extern const struct KHHMessageAttributes {
	__unsafe_unretained NSString *company;
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *isRead;
	__unsafe_unretained NSString *subject;
	__unsafe_unretained NSString *time;
} KHHMessageAttributes;

extern const struct KHHMessageRelationships {
	__unsafe_unretained NSString *image;
} KHHMessageRelationships;

extern const struct KHHMessageFetchedProperties {
} KHHMessageFetchedProperties;

@class Image;








@interface KHHMessageID : NSManagedObjectID {}
@end

@interface _KHHMessage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (KHHMessageID*)objectID;





@property (nonatomic, strong) NSString* company;



//- (BOOL)validateCompany:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* content;



//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isRead;



@property BOOL isReadValue;
- (BOOL)isReadValue;
- (void)setIsReadValue:(BOOL)value_;

//- (BOOL)validateIsRead:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* subject;



//- (BOOL)validateSubject:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* time;



//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Image *image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@end

@interface _KHHMessage (CoreDataGeneratedAccessors)

@end

@interface _KHHMessage (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCompany;
- (void)setPrimitiveCompany:(NSString*)value;




- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSNumber*)primitiveIsRead;
- (void)setPrimitiveIsRead:(NSNumber*)value;

- (BOOL)primitiveIsReadValue;
- (void)setPrimitiveIsReadValue:(BOOL)value_;




- (NSString*)primitiveSubject;
- (void)setPrimitiveSubject:(NSString*)value;




- (NSString*)primitiveTime;
- (void)setPrimitiveTime:(NSString*)value;





- (Image*)primitiveImage;
- (void)setPrimitiveImage:(Image*)value;


@end
