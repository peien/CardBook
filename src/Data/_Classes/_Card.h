// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Card.h instead.

#import <CoreData/CoreData.h>


extern const struct CardAttributes {
	__unsafe_unretained NSString *aliWangWang;
	__unsafe_unretained NSString *businessScope;
	__unsafe_unretained NSString *department;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *fax;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *isFull;
	__unsafe_unretained NSString *isRead;
	__unsafe_unretained NSString *microblog;
	__unsafe_unretained NSString *mobilePhone;
	__unsafe_unretained NSString *modelType;
	__unsafe_unretained NSString *moreInfo;
	__unsafe_unretained NSString *msn;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *qq;
	__unsafe_unretained NSString *remarks;
	__unsafe_unretained NSString *roleType;
	__unsafe_unretained NSString *telephone;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *version;
	__unsafe_unretained NSString *web;
} CardAttributes;

extern const struct CardRelationships {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *bankAccount;
	__unsafe_unretained NSString *company;
	__unsafe_unretained NSString *evaluation;
	__unsafe_unretained NSString *frames;
	__unsafe_unretained NSString *groups;
	__unsafe_unretained NSString *logo;
	__unsafe_unretained NSString *schedules;
	__unsafe_unretained NSString *template;
} CardRelationships;

extern const struct CardFetchedProperties {
} CardFetchedProperties;

@class Address;
@class BankAccount;
@class Company;
@class CustomerEvaluation;
@class Image;
@class Group;
@class Image;
@class Schedule;
@class CardTemplate;
























@interface CardID : NSManagedObjectID {}
@end

@interface _Card : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CardID*)objectID;





@property (nonatomic, strong) NSString* aliWangWang;



//- (BOOL)validateAliWangWang:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* businessScope;



//- (BOOL)validateBusinessScope:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* department;



//- (BOOL)validateDepartment:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fax;



//- (BOOL)validateFax:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSNumber* isRead;



@property BOOL isReadValue;
- (BOOL)isReadValue;
- (void)setIsReadValue:(BOOL)value_;

//- (BOOL)validateIsRead:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* microblog;



//- (BOOL)validateMicroblog:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mobilePhone;



//- (BOOL)validateMobilePhone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* modelType;



@property int32_t modelTypeValue;
- (int32_t)modelTypeValue;
- (void)setModelTypeValue:(int32_t)value_;

//- (BOOL)validateModelType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* moreInfo;



//- (BOOL)validateMoreInfo:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* msn;



//- (BOOL)validateMsn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* qq;



//- (BOOL)validateQq:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* remarks;



//- (BOOL)validateRemarks:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* roleType;



@property int32_t roleTypeValue;
- (int32_t)roleTypeValue;
- (void)setRoleTypeValue:(int32_t)value_;

//- (BOOL)validateRoleType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* telephone;



//- (BOOL)validateTelephone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* userID;



@property int64_t userIDValue;
- (int64_t)userIDValue;
- (void)setUserIDValue:(int64_t)value_;

//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* version;



@property int64_t versionValue;
- (int64_t)versionValue;
- (void)setVersionValue:(int64_t)value_;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* web;



//- (BOOL)validateWeb:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Address *address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) BankAccount *bankAccount;

//- (BOOL)validateBankAccount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Company *company;

//- (BOOL)validateCompany:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) CustomerEvaluation *evaluation;

//- (BOOL)validateEvaluation:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *frames;

- (NSMutableSet*)framesSet;




@property (nonatomic, strong) NSSet *groups;

- (NSMutableSet*)groupsSet;




@property (nonatomic, strong) Image *logo;

//- (BOOL)validateLogo:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *schedules;

- (NSMutableSet*)schedulesSet;




@property (nonatomic, strong) CardTemplate *template;

//- (BOOL)validateTemplate:(id*)value_ error:(NSError**)error_;





@end

@interface _Card (CoreDataGeneratedAccessors)

- (void)addFrames:(NSSet*)value_;
- (void)removeFrames:(NSSet*)value_;
- (void)addFramesObject:(Image*)value_;
- (void)removeFramesObject:(Image*)value_;

- (void)addGroups:(NSSet*)value_;
- (void)removeGroups:(NSSet*)value_;
- (void)addGroupsObject:(Group*)value_;
- (void)removeGroupsObject:(Group*)value_;

- (void)addSchedules:(NSSet*)value_;
- (void)removeSchedules:(NSSet*)value_;
- (void)addSchedulesObject:(Schedule*)value_;
- (void)removeSchedulesObject:(Schedule*)value_;

@end

@interface _Card (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAliWangWang;
- (void)setPrimitiveAliWangWang:(NSString*)value;




- (NSString*)primitiveBusinessScope;
- (void)setPrimitiveBusinessScope:(NSString*)value;




- (NSString*)primitiveDepartment;
- (void)setPrimitiveDepartment:(NSString*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFax;
- (void)setPrimitiveFax:(NSString*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSNumber*)primitiveIsFull;
- (void)setPrimitiveIsFull:(NSNumber*)value;

- (BOOL)primitiveIsFullValue;
- (void)setPrimitiveIsFullValue:(BOOL)value_;




- (NSNumber*)primitiveIsRead;
- (void)setPrimitiveIsRead:(NSNumber*)value;

- (BOOL)primitiveIsReadValue;
- (void)setPrimitiveIsReadValue:(BOOL)value_;




- (NSString*)primitiveMicroblog;
- (void)setPrimitiveMicroblog:(NSString*)value;




- (NSString*)primitiveMobilePhone;
- (void)setPrimitiveMobilePhone:(NSString*)value;




- (NSNumber*)primitiveModelType;
- (void)setPrimitiveModelType:(NSNumber*)value;

- (int32_t)primitiveModelTypeValue;
- (void)setPrimitiveModelTypeValue:(int32_t)value_;




- (NSString*)primitiveMoreInfo;
- (void)setPrimitiveMoreInfo:(NSString*)value;




- (NSString*)primitiveMsn;
- (void)setPrimitiveMsn:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveQq;
- (void)setPrimitiveQq:(NSString*)value;




- (NSString*)primitiveRemarks;
- (void)setPrimitiveRemarks:(NSString*)value;




- (NSNumber*)primitiveRoleType;
- (void)setPrimitiveRoleType:(NSNumber*)value;

- (int32_t)primitiveRoleTypeValue;
- (void)setPrimitiveRoleTypeValue:(int32_t)value_;




- (NSString*)primitiveTelephone;
- (void)setPrimitiveTelephone:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSNumber*)primitiveUserID;
- (void)setPrimitiveUserID:(NSNumber*)value;

- (int64_t)primitiveUserIDValue;
- (void)setPrimitiveUserIDValue:(int64_t)value_;




- (NSNumber*)primitiveVersion;
- (void)setPrimitiveVersion:(NSNumber*)value;

- (int64_t)primitiveVersionValue;
- (void)setPrimitiveVersionValue:(int64_t)value_;




- (NSString*)primitiveWeb;
- (void)setPrimitiveWeb:(NSString*)value;





- (Address*)primitiveAddress;
- (void)setPrimitiveAddress:(Address*)value;



- (BankAccount*)primitiveBankAccount;
- (void)setPrimitiveBankAccount:(BankAccount*)value;



- (Company*)primitiveCompany;
- (void)setPrimitiveCompany:(Company*)value;



- (CustomerEvaluation*)primitiveEvaluation;
- (void)setPrimitiveEvaluation:(CustomerEvaluation*)value;



- (NSMutableSet*)primitiveFrames;
- (void)setPrimitiveFrames:(NSMutableSet*)value;



- (NSMutableSet*)primitiveGroups;
- (void)setPrimitiveGroups:(NSMutableSet*)value;



- (Image*)primitiveLogo;
- (void)setPrimitiveLogo:(Image*)value;



- (NSMutableSet*)primitiveSchedules;
- (void)setPrimitiveSchedules:(NSMutableSet*)value;



- (CardTemplate*)primitiveTemplate;
- (void)setPrimitiveTemplate:(CardTemplate*)value;


@end
