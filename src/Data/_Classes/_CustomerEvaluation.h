// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CustomerEvaluation.h instead.

#import <CoreData/CoreData.h>


extern const struct CustomerEvaluationAttributes {
	__unsafe_unretained NSString *degree;
	__unsafe_unretained NSString *firstMeetAddress;
	__unsafe_unretained NSString *firstMeetDate;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *remarks;
	__unsafe_unretained NSString *value;
	__unsafe_unretained NSString *version;
} CustomerEvaluationAttributes;

extern const struct CustomerEvaluationRelationships {
	__unsafe_unretained NSString *customerCard;
} CustomerEvaluationRelationships;

extern const struct CustomerEvaluationFetchedProperties {
} CustomerEvaluationFetchedProperties;

@class Card;









@interface CustomerEvaluationID : NSManagedObjectID {}
@end

@interface _CustomerEvaluation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CustomerEvaluationID*)objectID;





@property (nonatomic, strong) NSNumber* degree;



@property float degreeValue;
- (float)degreeValue;
- (void)setDegreeValue:(float)value_;

//- (BOOL)validateDegree:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstMeetAddress;



//- (BOOL)validateFirstMeetAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstMeetDate;



//- (BOOL)validateFirstMeetDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* remarks;



//- (BOOL)validateRemarks:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* value;



@property float valueValue;
- (float)valueValue;
- (void)setValueValue:(float)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* version;



@property int64_t versionValue;
- (int64_t)versionValue;
- (void)setVersionValue:(int64_t)value_;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Card *customerCard;

//- (BOOL)validateCustomerCard:(id*)value_ error:(NSError**)error_;





@end

@interface _CustomerEvaluation (CoreDataGeneratedAccessors)

@end

@interface _CustomerEvaluation (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDegree;
- (void)setPrimitiveDegree:(NSNumber*)value;

- (float)primitiveDegreeValue;
- (void)setPrimitiveDegreeValue:(float)value_;




- (NSString*)primitiveFirstMeetAddress;
- (void)setPrimitiveFirstMeetAddress:(NSString*)value;




- (NSString*)primitiveFirstMeetDate;
- (void)setPrimitiveFirstMeetDate:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveRemarks;
- (void)setPrimitiveRemarks:(NSString*)value;




- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (float)primitiveValueValue;
- (void)setPrimitiveValueValue:(float)value_;




- (NSNumber*)primitiveVersion;
- (void)setPrimitiveVersion:(NSNumber*)value;

- (int64_t)primitiveVersionValue;
- (void)setPrimitiveVersionValue:(int64_t)value_;





- (Card*)primitiveCustomerCard;
- (void)setPrimitiveCustomerCard:(Card*)value;


@end
