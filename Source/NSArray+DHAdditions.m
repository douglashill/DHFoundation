// Douglas Hill, February 2015
// https://github.com/douglashill/DHFoundation

#import "NSArray+DHAdditions.h"

@implementation NSArray (DHMap)

+ (nonnull NSArray *)dh_arrayByMappingRange:(NSRange)range usingMap:(nonnull DHIndexToObjectMap)map
{
	NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:range.length];
	
	for (NSUInteger idx = range.location; idx < range.location + range.length; ++idx) {
		id const mappedObject = map(idx);
		if (mappedObject) [mappedArray addObject:mappedObject];
	}
	
	return mappedArray;
}

- (nonnull NSArray *)dh_arrayByMappingObjectsUsingMap:(nonnull DHObjectMap)map
{
	NSMutableArray *mappedArray = [NSMutableArray arrayWithCapacity:[self count]];
	
	for (id object in self) {
		id mappedObject = map(object);
		if (mappedObject) [mappedArray addObject:mappedObject];
	}
	
	return mappedArray;
}

- (nonnull NSDictionary *)dh_dictionaryByMappingObjectsUsingMap:(nonnull DHKeyValueMap)map
{
	NSMutableDictionary *mappedDictionary = [NSMutableDictionary dictionaryWithCapacity:[self count]];
	
	for (id object in self) {
		NSArray *const result = map(object);
		// Omit objects that map to nil.
		if ([result count] >= 2) {
			mappedDictionary[result[0]] = result[1];
		}
	}
	
	return mappedDictionary;
}

@end

@implementation NSArray (DHExtendedArray)

- (nonnull NSArray *)dh_objectsPassingTest:(nonnull DHIndexedCollectionFilterPredicate)predicate
{
	return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:predicate]];
}

- (nullable id)dh_objectPassingTest:(nonnull DHIndexedCollectionFilterPredicate)predicate
{
	NSUInteger const indexOfFirstMatchingObject = [self indexOfObjectPassingTest:predicate];
	if (indexOfFirstMatchingObject == NSNotFound) return nil;
	return self[indexOfFirstMatchingObject];
}

@end
