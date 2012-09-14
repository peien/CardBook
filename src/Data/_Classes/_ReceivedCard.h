// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ReceivedCard.h instead.

#import <CoreData/CoreData.h>
#import "Card.h"

extern const struct ReceivedCardAttributes {
	__unsafe_unretained NSString *isRead;
} ReceivedCardAttributes;

extern const struct ReceivedCardRelationships {
} ReceivedCardRelationships;

extern const struct ReceivedCardFetchedProperties {
} ReceivedCardFetchedProperties;




@interface ReceivedCardID : NSManagedObjectID {}
@end

@interface _ReceivedCard : Card {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ReceivedCardID*)objectID;




@property (nonatomic, strong) NSNumber* isRead;


@property BOOL isReadValue;
- (BOOL)isReadValue;
- (void)setIsReadValue:(BOOL)value_;

//- (BOOL)validateIsRead:(id*)value_ error:(NSError**)error_;






@end

@interface _ReceivedCard (CoreDataGeneratedAccessors)

@end

@interface _ReceivedCard (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIsRead;
- (void)setPrimitiveIsRead:(NSNumber*)value;

- (BOOL)primitiveIsReadValue;
- (void)setPrimitiveIsReadValue:(BOOL)value_;




@end
