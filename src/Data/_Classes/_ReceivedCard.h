// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ReceivedCard.h instead.

#import <CoreData/CoreData.h>
#import "ContactCard.h"

extern const struct ReceivedCardAttributes {
	__unsafe_unretained NSString *memo;
} ReceivedCardAttributes;

extern const struct ReceivedCardRelationships {
} ReceivedCardRelationships;

extern const struct ReceivedCardFetchedProperties {
} ReceivedCardFetchedProperties;




@interface ReceivedCardID : NSManagedObjectID {}
@end

@interface _ReceivedCard : ContactCard {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ReceivedCardID*)objectID;





@property (nonatomic, strong) NSString* memo;



//- (BOOL)validateMemo:(id*)value_ error:(NSError**)error_;






@end

@interface _ReceivedCard (CoreDataGeneratedAccessors)

@end

@interface _ReceivedCard (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveMemo;
- (void)setPrimitiveMemo:(NSString*)value;




@end
