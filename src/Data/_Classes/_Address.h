// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Address.h instead.

#import <CoreData/CoreData.h>


extern const struct AddressAttributes {
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *district;
	__unsafe_unretained NSString *other;
	__unsafe_unretained NSString *province;
	__unsafe_unretained NSString *street;
	__unsafe_unretained NSString *zip;
} AddressAttributes;

extern const struct AddressRelationships {
	__unsafe_unretained NSString *card;
	__unsafe_unretained NSString *schedule;
} AddressRelationships;

extern const struct AddressFetchedProperties {
} AddressFetchedProperties;

@class Card;
@class Schedule;









@interface AddressID : NSManagedObjectID {}
@end

@interface _Address : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AddressID*)objectID;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country;



//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* district;



//- (BOOL)validateDistrict:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* other;



//- (BOOL)validateOther:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* province;



//- (BOOL)validateProvince:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* street;



//- (BOOL)validateStreet:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* zip;



//- (BOOL)validateZip:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Card *card;

//- (BOOL)validateCard:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Schedule *schedule;

//- (BOOL)validateSchedule:(id*)value_ error:(NSError**)error_;





@end

@interface _Address (CoreDataGeneratedAccessors)

@end

@interface _Address (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveDistrict;
- (void)setPrimitiveDistrict:(NSString*)value;




- (NSString*)primitiveOther;
- (void)setPrimitiveOther:(NSString*)value;




- (NSString*)primitiveProvince;
- (void)setPrimitiveProvince:(NSString*)value;




- (NSString*)primitiveStreet;
- (void)setPrimitiveStreet:(NSString*)value;




- (NSString*)primitiveZip;
- (void)setPrimitiveZip:(NSString*)value;





- (Card*)primitiveCard;
- (void)setPrimitiveCard:(Card*)value;



- (Schedule*)primitiveSchedule;
- (void)setPrimitiveSchedule:(Schedule*)value;


@end
