// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncMark.h instead.

#import <CoreData/CoreData.h>


extern const struct SyncMarkAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *value;
} SyncMarkAttributes;

extern const struct SyncMarkRelationships {
} SyncMarkRelationships;

extern const struct SyncMarkFetchedProperties {
} SyncMarkFetchedProperties;





@interface SyncMarkID : NSManagedObjectID {}
@end

@interface _SyncMark : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SyncMarkID*)objectID;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _SyncMark (CoreDataGeneratedAccessors)

@end

@interface _SyncMark (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;




@end
