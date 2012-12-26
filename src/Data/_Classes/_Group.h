// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.h instead.

#import <CoreData/CoreData.h>


extern const struct GroupAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} GroupAttributes;

extern const struct GroupRelationships {
	__unsafe_unretained NSString *cards;
	__unsafe_unretained NSString *children;
	__unsafe_unretained NSString *parent;
} GroupRelationships;

extern const struct GroupFetchedProperties {
} GroupFetchedProperties;

@class Card;
@class Group;
@class Group;




@interface GroupID : NSManagedObjectID {}
@end

@interface _Group : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GroupID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *cards;

- (NSMutableSet*)cardsSet;




@property (nonatomic, strong) NSSet *children;

- (NSMutableSet*)childrenSet;




@property (nonatomic, strong) Group *parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;





@end

@interface _Group (CoreDataGeneratedAccessors)

- (void)addCards:(NSSet*)value_;
- (void)removeCards:(NSSet*)value_;
- (void)addCardsObject:(Card*)value_;
- (void)removeCardsObject:(Card*)value_;

- (void)addChildren:(NSSet*)value_;
- (void)removeChildren:(NSSet*)value_;
- (void)addChildrenObject:(Group*)value_;
- (void)removeChildrenObject:(Group*)value_;

@end

@interface _Group (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveCards;
- (void)setPrimitiveCards:(NSMutableSet*)value;



- (NSMutableSet*)primitiveChildren;
- (void)setPrimitiveChildren:(NSMutableSet*)value;



- (Group*)primitiveParent;
- (void)setPrimitiveParent:(Group*)value;


@end
