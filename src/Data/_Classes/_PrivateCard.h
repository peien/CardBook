// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PrivateCard.h instead.

#import <CoreData/CoreData.h>
#import "ContactCard.h"

extern const struct PrivateCardAttributes {
} PrivateCardAttributes;

extern const struct PrivateCardRelationships {
} PrivateCardRelationships;

extern const struct PrivateCardFetchedProperties {
} PrivateCardFetchedProperties;



@interface PrivateCardID : NSManagedObjectID {}
@end

@interface _PrivateCard : ContactCard {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PrivateCardID*)objectID;






@end

@interface _PrivateCard (CoreDataGeneratedAccessors)

@end

@interface _PrivateCard (CoreDataGeneratedPrimitiveAccessors)


@end
