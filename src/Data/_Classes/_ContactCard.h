// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ContactCard.h instead.

#import <CoreData/CoreData.h>
#import "Card.h"

extern const struct ContactCardAttributes {
} ContactCardAttributes;

extern const struct ContactCardRelationships {
} ContactCardRelationships;

extern const struct ContactCardFetchedProperties {
} ContactCardFetchedProperties;



@interface ContactCardID : NSManagedObjectID {}
@end

@interface _ContactCard : Card {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ContactCardID*)objectID;






@end

@interface _ContactCard (CoreDataGeneratedAccessors)

@end

@interface _ContactCard (CoreDataGeneratedPrimitiveAccessors)


@end
