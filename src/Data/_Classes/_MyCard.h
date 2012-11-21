// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MyCard.h instead.

#import <CoreData/CoreData.h>
#import "Card.h"

extern const struct MyCardAttributes {
} MyCardAttributes;

extern const struct MyCardRelationships {
} MyCardRelationships;

extern const struct MyCardFetchedProperties {
} MyCardFetchedProperties;



@interface MyCardID : NSManagedObjectID {}
@end

@interface _MyCard : Card {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MyCardID*)objectID;






@end

@interface _MyCard (CoreDataGeneratedAccessors)

@end

@interface _MyCard (CoreDataGeneratedPrimitiveAccessors)


@end
