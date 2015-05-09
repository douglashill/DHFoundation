// Douglas Hill, May 2015
// https://github.com/douglashill/DHFoundation

@import XCTest;
@import DHFoundation;

@interface DHFoundationTests : XCTestCase

@end

@implementation DHFoundationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Sign conversion

- (void)testUnsigningAPositiveInteger
{
	static NSInteger const positive = 1234;
	XCTAssertEqual(unsign(positive), positive);
}

- (void)testUnsigningZero
{
	static NSInteger const zero = 0;
	XCTAssertEqual(unsign(zero), zero);
}

- (void)testUnsigningANegativeInteger
{
	XCTAssertThrows(unsign(-1234));
}

- (void)testSigningASmallInteger
{
	static NSUInteger const small = 1234;
	XCTAssertEqual(sign(small), small);
}

- (void)testSigningNSIntegerMax
{
	XCTAssertEqual(sign(NSIntegerMax), NSIntegerMax);
}

- (void)testSigningALargeInteger
{
	XCTAssertThrows(sign((NSUInteger)NSIntegerMax + 1));
}

#pragma mark - Array mapping

- (void)testMappingRange
{
	NSArray *const mapped = [NSArray dh_arrayByMappingRange:NSMakeRange(5, 3) usingMap:^(NSUInteger idx){
		return @(idx);
	}];
	NSArray *const expected = @[@5, @6, @7];
	
	XCTAssertEqualObjects(mapped, expected);
}

- (void)testMappingCArray
{
	int source[] = {5, -2, 0};
	int *sourcePointer = source; // Don’t do this at home.
	
	NSArray *const mapped = [NSArray dh_arrayByMappingRange:NSMakeRange(0, sizeof source / sizeof *source) usingMap:^(NSUInteger idx){
		return @(sourcePointer[idx]);
	}];
	NSArray *const expected = @[@5, @-2, @0];
	
	XCTAssertEqualObjects(mapped, expected);
}

- (void)testMappingEmptyArray
{
	NSArray *const mapped = [@[] dh_arrayByMappingObjectsUsingMap:^(NSNumber *number){
		return number;
	}];
	NSArray *const expected = @[];
	
	XCTAssertEqualObjects(mapped, expected);
}

- (void)testIdentityMappingArray
{
	NSArray *const mapped = [@[@1, @2, @3] dh_arrayByMappingObjectsUsingMap:^(NSNumber *number){
		return number;
	}];
	NSArray *const expected = @[@1, @2, @3];
	
	XCTAssertEqualObjects(mapped, expected);
}

- (void)testDoublingArray
{
	NSArray *const mapped = [@[@1, @2, @3] dh_arrayByMappingObjectsUsingMap:^(NSNumber *number){
		return @(2 * [number integerValue]);
	}];
	NSArray *const expected = @[@2, @4, @6];
	
	XCTAssertEqualObjects(mapped, expected);
}

@end
