#import "MZEControlCenterPositionProvider.h"
#import "BinPack/MaxRectsBinPack.h"
#import "BinPack/Rect.h"

#import <MaizeServices/MZEModuleRepository.h>

struct RectSize
{
	int width;
	int height;
};

typedef struct MZEModuleCoordinate {
    NSInteger row;
    NSInteger col;
} MZEModuleCoordinate;


struct MZEModuleCoordinate MZEModuleCoordinateMake(long long row, long long col) {
    MZEModuleCoordinate coordinate;
    coordinate.row = row;
    coordinate.col = col;
    return coordinate;
}

#define isNSNull(value) [value isKindOfClass:[NSNull class]]

@implementation MZEControlCenterPositionProvider 
{
	rbp::MaxRectsBinPack *_binPacker;
}


- (id)initWithLayoutStyle:(MZELayoutStyle *)layoutStyle orderedIdentifiers:(NSArray<NSString *> *)orderedIdentifiers orderedSizes:(NSArray<NSValue *> *)orderedSizes {
	self = [super init];
	if (self) {
		_layoutStyle = layoutStyle;
		_orderedIdentifiers = orderedIdentifiers;
		_orderedSizes = orderedSizes;
		_cachedLayoutSize = CGSizeMake(-1,-1);

		BOOL isLandscape = _layoutStyle.rows == -1 ? NO : YES;
	
		NSInteger numberOfSpacesTaken = 0;
		_numberOfRows = 0;
		_numberOfColumns = 0;
		for (NSValue *sizeValue in _orderedSizes) {
			CGSize size = [sizeValue CGSizeValue];
			numberOfSpacesTaken += (size.width * size.height);
		}

		if (isLandscape) {
			_numberOfRows = _layoutStyle.rows;
			_numberOfColumns = (NSInteger)ceil((CGFloat)numberOfSpacesTaken/(CGFloat)_numberOfRows);

		} else {
			_numberOfColumns = _layoutStyle.columns;
			_numberOfRows = numberOfSpacesTaken;
			//if (_numberOfRows == 0) _numberOfRows = 1;
		}
		//_numberOfRows += 1;

		//_binPacker = new rbp::MaxRectsBinPack((int)_numberOfColumns,(int)_numberOfRows);
		_framesByIdentifiers = [self orderedStuff];
		NSInteger numberOfRows = _numberOfRows;
		NSInteger numberOfColumns = _numberOfColumns;

		CGFloat width = numberOfColumns*_layoutStyle.moduleSize + (numberOfColumns-1)*_layoutStyle.spacing;
		CGFloat height = numberOfRows*_layoutStyle.moduleSize + (numberOfRows - 1)*_layoutStyle.spacing;

		_cachedLayoutSize = CGSizeMake(width, height);

	}
	return self;
}

- (CGRect)positionForIdentifier:(NSString *)identifier {
	if (_framesByIdentifiers) {
		if ([_framesByIdentifiers objectForKey:identifier]) {
			return [(NSValue *)[_framesByIdentifiers objectForKey:identifier] CGRectValue];
		}
	}

	return CGRectZero;
}

- (CGSize)sizeOfLayoutView {
	if (_cachedLayoutSize.width != -1) {
		return _cachedLayoutSize;
	} else {

		NSInteger numberOfRows = _numberOfRows;
		NSInteger numberOfColumns = _numberOfColumns;

		CGFloat width = numberOfColumns*_layoutStyle.moduleSize + (numberOfColumns-1)*_layoutStyle.spacing;
		CGFloat height = numberOfRows*_layoutStyle.moduleSize + (numberOfRows - 1)*_layoutStyle.spacing;

		_cachedLayoutSize = CGSizeMake(width, height);
		return _cachedLayoutSize;
	}
}

- (void)generateAllFrames {

	std::vector<rbp::RectSize> inputRects;
	std::vector<rbp::Rect> outputRects;


	for (NSValue *sizeValue in _orderedSizes) {
		CGSize size = [sizeValue CGSizeValue];
		int width = (int)size.width;
		int height = (int)size.height;
		inputRects.push_back((rbp::RectSize){width,height});
	}

	// std::vector<RectSize> & inputRectsRef = inputRects;
	// std::vector<RectSize> & outputRectsRef = outputRects;

	_binPacker->Insert(inputRects,outputRects,(rbp::MaxRectsBinPack::FreeRectChoiceHeuristic)rbp::MaxRectsBinPack::RectBottomLeftRule);


	// for (auto it = outputRects.begin(); it != outputRects.end(); ++it) {
	// 	NSLog(@"X:%@ Y:%@ W:%@ H: %@", [NSNumber numberWithInteger:it.x],[NSNumber numberWithInteger:it.y],[NSNumber numberWithInteger:it.width],[NSNumber numberWithInteger:it.height]);
  

	// }

	HBLogInfo(@"INSERTED STUFF");
	for(std::vector<rbp::Rect>::iterator it = outputRects.begin(); it != outputRects.end(); ++it) {
		HBLogInfo(@"X:%@ Y:%@ W:%@ H: %@", [NSNumber numberWithInteger:it->x],[NSNumber numberWithInteger:it->y],[NSNumber numberWithInteger:it->width],[NSNumber numberWithInteger:it->height]);
    	//it->doSomething();
 	}
}

- (NSMutableDictionary *)orderedStuff {
	if (self.layoutStyle.isLandscape) {
		_numberOfColumns += 10;
	}

	_cachedTest = [NSMutableArray new];

	_framesByIdentifiers = [NSMutableDictionary new];
	NSMutableArray *identifiersToProcess = [_orderedIdentifiers mutableCopy];
	NSMutableArray *finalGrid = [NSMutableArray new];
	NSUInteger currentEnumCount = 0;

	for (int r = 0; r < _numberOfRows; r++) {
	    finalGrid[r] = [NSMutableArray new];
	    for (int c = 0; c < _numberOfColumns; c++) {
	        finalGrid[r][c] = [NSNull null];
	    }
	}


	while ([identifiersToProcess count] > 0) {
		NSMutableDictionary *processedDict = [self testOtherOrderWithIdentifiers:[identifiersToProcess mutableCopy]];
		identifiersToProcess = [[processedDict objectForKey:@"uncalculatedIdentifiers"] mutableCopy];
		NSMutableArray *calculatedGrid = [processedDict objectForKey:@"calculatedGrid"];
		for (int r = 0; r < [calculatedGrid count]; r++) {
			NSMutableArray *row = calculatedGrid[r];
			for (int c = 0; c < [row count]; c++) {
				finalGrid[r][c + 2*currentEnumCount] = calculatedGrid[r][c];
			}
		}
		[_cachedTest addObject:calculatedGrid];
		currentEnumCount++;
	}
	_enumCount = currentEnumCount;

	self.otherCachedTest = finalGrid; 

	NSMutableArray *orderedSizes = [NSMutableArray new];

	NSUInteger maxCol = 0;
	NSUInteger maxRow = 0;
	for (int r = 0; r < [finalGrid count]; r++) {
		NSMutableArray *row = finalGrid[r];
	    for (int c = 0; c < [row count]; c++) {
	     
	        if (!isNSNull(finalGrid[r][c])) {
	            if (c > maxCol) maxCol = c;
	            if (r > maxRow) maxRow = r;
	  
	        } else {
	        }
	    }
	}

	_numberOfColumns = maxCol + 1;
	_numberOfRows = maxRow + 1;

	for (int r = 0; r < _numberOfRows; r++) {
	    for (int c = 0; c < _numberOfColumns; c++) {
	        if (!isNSNull(finalGrid[r][c])) {
	            [orderedSizes addObject:finalGrid[r][c]];
	        } else {
	        	[orderedSizes addObject:@"empty"];
	        }
	    }
	}


	//NSMutableArray *ordered = [NSMutableArray new];
	for (NSString *identifier in _orderedIdentifiers) { 
		if ([orderedSizes containsObject:identifier]) {
			NSInteger index = [orderedSizes indexOfObject:identifier];
			MZEModuleCoordinate coord = MZEModuleCoordinateMake((index / (int)_numberOfColumns) + 1, (index % (int)_numberOfColumns) + 1);
			int moduleWidth = [[_orderedSizes objectAtIndex:[_orderedIdentifiers indexOfObject:identifier]] CGSizeValue].width;
	    	int moduleHeight = [[_orderedSizes objectAtIndex:[_orderedIdentifiers indexOfObject:identifier]] CGSizeValue].height;
			CGRect position = CGRectMake(coord.col,coord.row,moduleWidth,moduleHeight);

			CGFloat x = (position.origin.x -1)*_layoutStyle.moduleSize + (position.origin.x -1)*_layoutStyle.spacing;
			CGFloat y = (position.origin.y -1)*_layoutStyle.moduleSize + (position.origin.y -1)*_layoutStyle.spacing;
			CGFloat width = position.size.width*_layoutStyle.moduleSize+(position.size.width - 1)*_layoutStyle.spacing;
			CGFloat height = position.size.height*_layoutStyle.moduleSize+(position.size.height - 1)*_layoutStyle.spacing;

			[_framesByIdentifiers setObject:[NSValue valueWithCGRect:CGRectMake(x,y,width,height)] forKey:identifier];

		}
	}
	return _framesByIdentifiers;
}

- (NSMutableDictionary *)testOtherOrderWithIdentifiers:(NSMutableArray *)_unfinishedIdentifiers {
	NSInteger maxNumberOfRows = _numberOfRows;
	NSInteger maxNumberOfColumns = self.layoutStyle.isLandscape ? 20 : _numberOfColumns;

	NSMutableArray *identifiers = [_unfinishedIdentifiers mutableCopy];

	//BOOL isEnumiration = _unfinishedIdentifiers == nil ? NO : YES;
	NSMutableArray *grid =  [NSMutableArray new]; 
	for (int r = 0; r < maxNumberOfRows; r++) {
	    grid[r] = [NSMutableArray new];
	    for (int c = 0; c < maxNumberOfColumns; c++) {
	        grid[r][c] = [NSNull null];
	    }
	}

	NSMutableArray *unfinishedIdentifiers = [_unfinishedIdentifiers mutableCopy];

	for (NSString *identifier in identifiers) {
	    // NSInteger index = [self indexForModuleID:identifier];
	    // if (index < 0) {
	    //     index = 0;
	    // }

	    //NSInteger index = 0;

	    MZEModuleCoordinate coord;
	    MZEModuleCoordinate origCoord;

	    coord = MZEModuleCoordinateMake(1,1);
	    origCoord = coord;

	    int moduleWidth = [[_orderedSizes objectAtIndex:[_orderedIdentifiers indexOfObject:identifier]] CGSizeValue].width;
	                    
	    int moduleHeight = [[_orderedSizes objectAtIndex:[_orderedIdentifiers indexOfObject:identifier]] CGSizeValue].height;

	    BOOL isPlaced = NO;
	                    
	    while (!isPlaced) {
	        if (self.layoutStyle.isLandscape) {

	        	if (coord.row + moduleHeight - 1 > maxNumberOfRows) {
	                
	                coord.col += 1;
	                coord.row = 1;
	            }

	            if (coord.col + moduleWidth - 1 > maxNumberOfColumns || coord.row + moduleHeight - 1 > maxNumberOfRows) {
	                isPlaced = YES;
	                continue;
	            }
	        } else {
	            if (coord.col + moduleWidth - 1 > maxNumberOfColumns) {
	                
	                coord.row = coord.row + 1;
	                coord.col = 1;
	            }
	        
	            if (coord.row + moduleHeight - 1 > maxNumberOfRows) {
	                
	                //[unfinishedIdentifiers removeObject: identifier];
	                isPlaced = YES;
	                continue;
	            }
	        }
	        
	        BOOL isValid = YES;
	        
	        for (int row = 0; row < moduleHeight; row++) {
	            for (int col = 0; col < moduleWidth; col++) {
	                
	                if (!isNSNull(grid[coord.row + row - 1][coord.col + col - 1])) {
	                    
	                    isValid = NO;
	                }
	            }
	        }
	        
	        // If all of the coordinates that the block would consume are empty we can place it in the 2D grid.
	        
	        if (isValid) {
	            
	            for (int row = 0; row < moduleHeight; row++) {
	                for (int col = 0; col < moduleWidth; col++) {
	                    
	                    if (row == 0 && col == 0) {
	                        
	                        grid[coord.row - 1][coord.col - 1] = identifier;
	                    } else {
	                        grid[coord.row + row - 1][coord.col + col - 1] = [NSString stringWithFormat:@"%@|%@", identifier, [NSNumber numberWithInt:row+col]];
	                    }
	                }
	            }
	            
	            
	            //int newIndex = 0;
	            NSInteger rowIndex = coord.row > 0 ? coord.row - 1 : maxNumberOfRows   + coord.row;
	            NSInteger colIndex = coord.col > 0 ? coord.col - 1 : maxNumberOfColumns + coord.col;

	            if (colIndex >= 0 && rowIndex >= 0 && colIndex < maxNumberOfColumns && rowIndex < maxNumberOfRows) {
	                //newIndex = (rowIndex * totalCols) + colIndex;
	               // [self setIndex: newIndex forModuleID:identifier];
	                [unfinishedIdentifiers removeObject: identifier];
	                isPlaced = YES;
	            }
	            
	        }
	        else {
	            if (self.layoutStyle.isLandscape) {
	            	if (coord.row + moduleHeight - 1 == maxNumberOfRows) {
	            		coord.col += 1;
	                	coord.row = 1;
	            	} else {
	            		coord.row += 1;
	            	}
	            } else {
	            	if (coord.col + moduleWidth - 1 == maxNumberOfColumns) {
		                
		                coord.row += 1;
		                coord.col = 1;
		            } else {
		                
		                coord.col += 1;
		            }
	            }
	        }
	    }
	}

	//NSMutableArray *finalGrid = [NSMutableArray new];
	        
	// for (int row = 0; row < maxNumberOfRows; row++) {
	//     for (int col = 0; col < maxNumberOfColumns; col++) {
	        
	//         if (!isNSNull(grid[row][col])) {
	            
	//             [finalGrid addObject:grid[row][col]];
	//         } else {
	//         	[finalGrid addObject:@"empty"];
	//         }
	//     }
	// }

	NSMutableDictionary *finalDict = [NSMutableDictionary new];
	[finalDict setObject:[grid mutableCopy] forKey:@"calculatedGrid"];
	[finalDict setObject:unfinishedIdentifiers forKey:@"uncalculatedIdentifiers"];

	return finalDict;
}

// + (id)justTest {
// 	MZELayoutStyle *layoutStyle = [[MZELayoutStyle alloc] initWithSize:CGSizeMake(1,3)];
// 	NSMutableArray<NSString *> *orderedIdentifiers = [NSMutableArray new];
// 	NSMutableArray<NSValue *> *orderedSizes = [NSMutableArray new];

// 	[orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,2)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,2)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,2)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(2,2)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,2)]]; //
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,1)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(2,1)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,1)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(2,2)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,1)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,1)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,1)]];
//     [orderedSizes addObject:[NSValue valueWithCGSize:CGSizeMake(1,1)]];

//     int count = 0;
//     for (NSValue *value in orderedSizes) {
//     	NSLog(@"%@", value);
//     	[orderedIdentifiers addObject:[NSString stringWithFormat:@"com.ioscreatix.maize.%@", [NSNumber numberWithInteger:count]]];
//     	count++;
//     }

// 	MZEControlCenterPositionProvider *provider = [[MZEControlCenterPositionProvider alloc] initWithLayoutStyle:layoutStyle orderedIdentifiers:[orderedIdentifiers copy] orderedSizes:[orderedSizes copy]];
// 	[provider generateAllFrames];
// 	return provider;

// }
@end