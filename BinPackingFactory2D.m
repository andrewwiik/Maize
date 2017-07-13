//
//  BinPackingFactory2D.m
//  BinPackingProject
//
//  Created by Ugljesa Erceg on 5/18/12.
//  Open Source project
//

#import "BinPackingFactory2D.h"
#import "GeneticAlgorithmFactory2D.h"

#define FF_STORAGE_WIDTH        10.0f
#define MAX_PERMUTATION_COUNT   500000

@implementation BinPackingFactory2D
{
    @private BOOL storageHeightLimited;
    
    @private float wastedArea;
    @private float storageWidth;
    @private float storageHeight;
    @private float storageOccupacy;
    @private float totalShelvesUsedArea;
    @private float wastedAreaPercentage;
    @private float bestWidthUsagePercentage;
    
    @private NSUInteger bestShelfNumber;
    @private NSUInteger permutationCount;
    @private NSUInteger numberOfUsedShelves;

    @private NSMutableArray *rectangles;
    @private NSMutableArray *shelvesHeight;
    @private NSMutableArray *currentlyUsedShelfArea;
    @private NSMutableArray *currentlyUsedShelfWidth;
    @private NSMutableArray *numberOfRectanglesOnShelf;
    @private NSMutableArray *rectanglesPositionsOnShelves;
    
    @private NSMutableArray *bestShelvesHeight;
    @private NSMutableArray *bestShelvesUsedWidth;
    @private NSMutableArray *bestRectangleCombination;
    
    @private NSMutableDictionary *rectanglesPerLevel;
    @private NSMutableArray *addedRectangles;
}

@synthesize permutationCount;

- (id) initWithStorageWidth:(float)width 
              storageHeight:(float)height
       storageHeightLimited:(BOOL)limit

{
    if (self = [super init]) 
    {        
        // Initialize class fields
        self->storageHeightLimited = limit;
        
        self->rectangles = [NSMutableArray new];
        self->shelvesHeight = [NSMutableArray new];
        self->currentlyUsedShelfArea = [NSMutableArray new];
        self->currentlyUsedShelfWidth = [NSMutableArray new];
        self->numberOfRectanglesOnShelf = [NSMutableArray new];
        self->rectanglesPositionsOnShelves = [NSMutableArray array];
        
        self->addedRectangles = [NSMutableArray new];
        self->bestShelvesHeight = [NSMutableArray new];
        self->bestShelvesUsedWidth = [NSMutableArray new];
        self->bestRectangleCombination = [NSMutableArray new];
        self->rectanglesPerLevel = [NSMutableDictionary dictionary];
        
        self->storageWidth = width;
        self->storageHeight = height;
        
        self->storageOccupacy = 0.0f;
        self->numberOfUsedShelves = 0;
    }
    
    return self;
}

// PUBLIC: Next Fit Bin Packing Algorithm
// RETURNS: Number of used shelves
- (NSUInteger) shelfNextFitAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    float usedWidth = 0.0f;
    float currentHeight = 0.0f;
    NSUInteger currentShelfIndex = 0;
    NSUInteger currentSelectedRectangle = 0;
    
    self->numberOfUsedShelves = 0;
    
    [self->rectangles removeAllObjects];
    [self->shelvesHeight removeAllObjects];
    [self->currentlyUsedShelfArea removeAllObjects];
    [self->currentlyUsedShelfWidth removeAllObjects];
    [self->rectanglesPositionsOnShelves removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [self->currentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        if (0 == [self->shelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                // Storage is empty, assign first item height to be
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Add rectangle to first shelf
                usedWidth += rectangle.size.height;
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                
                currentHeight = rectangle.size.width;
                currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                // Storage is empty, assign first item height to be
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Add rectangle to first shelf
                usedWidth += rectangle.size.width;
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                
                currentHeight = rectangle.size.height;
                currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                BOOL foundShelfForRectangle = NO;
                
                if (rectangle.size.height <= currentHeight)
                {
                    if (usedWidth + rectangle.size.width <= self->storageWidth)
                    {
                        usedWidth += rectangle.size.width;
                        [self->currentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Save rectangle position on shelf
                        [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                else if (rectangle.size.width <= currentHeight)
                {
                    if (usedWidth + rectangle.size.height <= self->storageWidth)
                    {
                        usedWidth += rectangle.size.height;
                        [self->currentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Save rectangle position on shelf
                        [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                
                if (NO == foundShelfForRectangle)
                {
                    [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                    [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    currentHeight = rectangle.size.width;
                    usedWidth = rectangle.size.height;
                    
                    currentShelfIndex += 1;
                    
                    // Save rectangle position on shelf
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
            else
            {
                BOOL foundShelfForRectangle = NO;
                
                if (rectangle.size.width <= currentHeight)
                {
                    if (usedWidth + rectangle.size.height <= self->storageWidth)
                    {
                        usedWidth += rectangle.size.height;
                        [self->currentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Save rectangle position on shelf
                        [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                else if (rectangle.size.height <= currentHeight)
                {
                    if (usedWidth + rectangle.size.width <= self->storageWidth)
                    {
                        usedWidth += rectangle.size.width;
                        [self->currentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Save rectangle position on shelf
                        [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                
                if (NO == foundShelfForRectangle)
                {
                    [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                    [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    currentHeight = rectangle.size.height;
                    usedWidth = rectangle.size.width;
                    
                    currentShelfIndex += 1;
                    
                    // Save rectangle position on shelf
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    self->numberOfUsedShelves = [self->shelvesHeight count];
    
    return self->numberOfUsedShelves;
}

// PRIVATE: Block implementation of Next Fit Bin Packing algorithm (used for GA)
// RETURNS: Number of used shelves
NSUInteger (^ffShelfNextFitAlgorithm2DFF1) (NSMutableArray *) = ^(NSMutableArray * givenRectangles)
{
    float usedWidth = 0.0f;
    float currentHeight = 0.0f;
    NSUInteger currentShelfIndex = 0;
    NSUInteger currentSelectedRectangle = 0;
    
    NSMutableArray *ffShelvesHeight = [NSMutableArray new];
    NSMutableArray *ffCurrentlyUsedShelfWidth = [NSMutableArray new];
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        if (0 == [ffShelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                // Storage is empty, assign first item height to be
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Add rectangle to first shelf
                usedWidth += rectangle.size.height;
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                
                currentHeight = rectangle.size.width;
                currentShelfIndex = [ffShelvesHeight count] - 1;
            }
            else
            {
                // Storage is empty, assign first item height to be
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Add rectangle to first shelf
                usedWidth += rectangle.size.width;
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                
                currentHeight = rectangle.size.height;
                currentShelfIndex = [ffShelvesHeight count] - 1;
            }
        }
        else
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                BOOL foundShelfForRectangle = NO;
                
                if (rectangle.size.height <= currentHeight)
                {
                    if (usedWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                    {
                        usedWidth += rectangle.size.width;
                        [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                    }
                }
                else if (rectangle.size.width <= currentHeight)
                {
                    if (usedWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                    {
                        usedWidth += rectangle.size.height;
                        [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                    }
                }
                
                if (NO == foundShelfForRectangle)
                {
                    [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                    [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    currentHeight = rectangle.size.width;
                    usedWidth = rectangle.size.height;
                    
                    currentShelfIndex += 1;
                }
            }
            else
            {
                BOOL foundShelfForRectangle = NO;
                
                if (rectangle.size.width <= currentHeight)
                {
                    if (usedWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                    {
                        usedWidth += rectangle.size.height;
                        [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                    }
                }
                else if (rectangle.size.height <= currentHeight)
                {
                    if (usedWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                    {
                        usedWidth += rectangle.size.width;
                        [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                    }
                }
                
                if (NO == foundShelfForRectangle)
                {
                    [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                    [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    currentHeight = rectangle.size.height;
                    usedWidth = rectangle.size.width;
                    
                    currentShelfIndex += 1;
                }
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    return [ffShelvesHeight count];
};

// PRIVATE: Block implementation of Next Fit Bin Packing algorithm (used for GA)
// RETURNS: Number of used shelves
NSUInteger (^ffShelfNextFitAlgorithm2DFF2) (NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *) = ^(NSMutableArray * givenRectangles, NSMutableArray *ffCurrentlyUsedShelfWidth, NSMutableArray *ffShelvesHeight, NSMutableArray *ffCurrentlyUsedShelfArea)
{
    float usedWidth = 0.0f;
    float currentHeight = 0.0f;
    NSUInteger currentShelfIndex = 0;
    NSUInteger currentSelectedRectangle = 0;
    
    [ffShelvesHeight removeAllObjects];
    [ffCurrentlyUsedShelfArea removeAllObjects];
    [ffCurrentlyUsedShelfWidth removeAllObjects];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [givenRectangles count]; i++)
    {
        [ffCurrentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        if (0 == [ffShelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                // Storage is empty, assign first item height to be
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Add rectangle to first shelf
                usedWidth += rectangle.size.height;
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                
                currentHeight = rectangle.size.width;
                currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                // Storage is empty, assign first item height to be
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Add rectangle to first shelf
                usedWidth += rectangle.size.width;
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                
                currentHeight = rectangle.size.height;
                currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                BOOL foundShelfForRectangle = NO;
                
                if (rectangle.size.height <= currentHeight)
                {
                    if (usedWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                    {
                        usedWidth += rectangle.size.width;
                        [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                else if (rectangle.size.width <= currentHeight)
                {
                    if (usedWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                    {
                        usedWidth += rectangle.size.height;
                        [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                
                if (NO == foundShelfForRectangle)
                {
                    [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                    [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    currentHeight = rectangle.size.width;
                    usedWidth = rectangle.size.height;
                    
                    currentShelfIndex += 1;
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                    [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
            else
            {
                BOOL foundShelfForRectangle = NO;
                
                if (rectangle.size.width <= currentHeight)
                {
                    if (usedWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                    {
                        usedWidth += rectangle.size.height;
                        [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                else if (rectangle.size.height <= currentHeight)
                {
                    if (usedWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                    {
                        usedWidth += rectangle.size.width;
                        [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;

                        // Update used are on shelf
                        float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                
                if (NO == foundShelfForRectangle)
                {
                    [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                    [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    currentHeight = rectangle.size.height;
                    usedWidth = rectangle.size.width;
                    
                    currentShelfIndex += 1;
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                    [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    return [ffShelvesHeight count];
};

// PUBLIC: Next Fit Decreasing Height Bin Packing Algorithm
// RETURNS: Number of used shelves
- (NSUInteger) shelfNextFitDecreasingAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    float usedWidth = 0.0f;
    float currentHeight = 0.0f;
    NSUInteger currentShelfIndex = 0;
    NSUInteger currentSelectedRectangle = 0;
    
    self->numberOfUsedShelves = 0;
    
    [self->rectangles removeAllObjects];
    [self->shelvesHeight removeAllObjects];
    [self->currentlyUsedShelfArea removeAllObjects];
    [self->currentlyUsedShelfWidth removeAllObjects];
    [self->rectanglesPositionsOnShelves removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    // Sort rectangles by height
    NSMutableArray *specArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        CGRect rectangle = [[self->rectangles objectAtIndex:i] CGRectValue];
        
        [specArray addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:rectangle.size.height], [NSNumber numberWithInteger:i], nil]];
    }
    
    NSArray *sortedArray = [specArray sortedArrayUsingFunction:customCompareFunctionDecr context:NULL];
    NSMutableArray *sortedRectangles = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [sortedRectangles addObject:[self->rectangles objectAtIndex:[[[sortedArray objectAtIndex:i] objectAtIndex:1] intValue]]];
    }
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [self->currentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in sortedRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        if (0 == [self->shelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                // Storage is empty, assign first item height to be
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Add rectangle to first shelf
                usedWidth += rectangle.size.height;
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                
                currentHeight = rectangle.size.width;
                currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                // Storage is empty, assign first item height to be
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Add rectangle to first shelf
                usedWidth += rectangle.size.width;
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                
                currentHeight = rectangle.size.height;
                currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                BOOL foundShelfForRectangle = NO;
                
                if (rectangle.size.height <= currentHeight)
                {
                    if (usedWidth + rectangle.size.width <= self->storageWidth)
                    {
                        usedWidth += rectangle.size.width;
                        [self->currentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Save rectangle position on shelf
                        NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                        [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                else if (rectangle.size.width <= currentHeight)
                {
                    if (usedWidth + rectangle.size.height <= self->storageWidth)
                    {
                        usedWidth += rectangle.size.height;
                        [self->currentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Save rectangle position on shelf
                        NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                        [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                
                if (NO == foundShelfForRectangle)
                {
                    [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                    [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    currentHeight = rectangle.size.width;
                    usedWidth = rectangle.size.height;
                    
                    currentShelfIndex += 1;
                    
                    // Save rectangle position on shelf
                    NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
            else
            {
                BOOL foundShelfForRectangle = NO;
                
                if (rectangle.size.width <= currentHeight)
                {
                    if (usedWidth + rectangle.size.height <= self->storageWidth)
                    {
                        usedWidth += rectangle.size.height;
                        [self->currentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Save rectangle position on shelf
                        NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                        [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                else if (rectangle.size.height <= currentHeight)
                {
                    if (usedWidth + rectangle.size.width <= self->storageWidth)
                    {
                        usedWidth += rectangle.size.width;
                        [self->currentlyUsedShelfWidth replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:usedWidth]];
                        foundShelfForRectangle = YES;
                        
                        // Save rectangle position on shelf
                        NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                        [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                        
                        // Update used are on shelf
                        float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                        [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                    }
                }
                
                if (NO == foundShelfForRectangle)
                {
                    currentHeight = rectangle.size.height;
                    usedWidth = rectangle.size.width;
                    
                    [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:usedWidth]];
                    [self->shelvesHeight addObject:[NSNumber numberWithFloat:currentHeight]];
                    
                    currentShelfIndex += 1;
                    
                    // Save rectangle position on shelf
                    NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    self->numberOfUsedShelves = [self->shelvesHeight count];
    
    return self->numberOfUsedShelves;
}

// PUBLIC: First Fit Bin Packing Algorithm
// RETURNS: Number of used shelves
- (NSUInteger) shelfFirstFitAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    NSUInteger currentSelectedRectangle = 0;
    
    self->numberOfUsedShelves = 0;
    
    [self->rectangles removeAllObjects];
    [self->shelvesHeight removeAllObjects];
    [self->currentlyUsedShelfArea removeAllObjects];
    [self->currentlyUsedShelfWidth removeAllObjects];
    [self->rectanglesPositionsOnShelves removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [self->currentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Check if there's any open shelf
        if (0 == [self->shelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                // Storage is empty, assign first item height to be
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Add rectangle to first shelf
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                // Storage is empty, assign first item height to be
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Add rectangle to first shelf
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            BOOL foundFittingShelf = NO;
            BOOL isRectangleRotated = NO;
            NSInteger iterator = -1;
            NSInteger fittingShelfId = -1;
            
            for (NSNumber *shelfHeight in self->shelvesHeight)
            {
                // Try to determine which rectangle size is smaller
                // That side will be candidate to place it by width in case second side fits height of shelf
                // 0 - width is smaller | 1 - height is smaller
                NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
                
                if (rectangle.size.height <= [shelfHeight floatValue] || rectangle.size.width <= [shelfHeight floatValue])
                {
                    if (0 == smallerSide)
                    {
                        if (rectangle.size.height <= [shelfHeight floatValue])
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceedes shelf width
                            if ((rectangle.size.width + [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= self->storageWidth)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = NO;
                                
                                break;
                            }
                        }
                        else
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceedes shelf width
                            if ((rectangle.size.height + [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= self->storageWidth)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = YES;
                                
                                break;
                            }
                        }
                    }
                    else
                    {
                        // Rectangle height wasn't fitting to shelf height
                        // ROTATE the rectangle and try to fit it with width-height sides swapped
                        if (rectangle.size.width <= [shelfHeight floatValue])
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceede shelf width
                            if ((rectangle.size.height + [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= self->storageWidth)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = YES;
                                
                                break;
                            }
                        }
                        else
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceede shelf width
                            if ((rectangle.size.width + [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= self->storageWidth)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = NO;
                                
                                break;
                            }
                            
                        }
                    }
                }
            }
            
            if (YES == foundFittingShelf)
            {
                // Add rectangle to fitting shelf
                // BE AWARE on fact that rectangle may be rotated
                float currentShelfWidth = [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue];
                
                if (NO == isRectangleRotated)
                {
                    [self->currentlyUsedShelfWidth replaceObjectAtIndex:fittingShelfId 
                                                             withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                    
                    // Save rectangle position on shelf
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:fittingShelfId], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:fittingShelfId] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:fittingShelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
                else
                {
                    [self->currentlyUsedShelfWidth replaceObjectAtIndex:fittingShelfId 
                                                             withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                    
                    // Save rectangle position on shelf
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:fittingShelfId], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:fittingShelfId] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:fittingShelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
            else
            {
                // Fitting shelf not found, must add new one
                // NOTE: Should be aware of storage height, for v1 we won't pay attention to that
                
                // Place rectangle so that shorter side is height (flip it if needed)
                // 0 - width is smaller | 1 - height is smaller
                NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
                
                if (0 == smallerSide)
                {
                    // Storage is empty, assign first item height to be
                    [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    // Add rectangle to first shelf
                    [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    // Save rectangle position on shelf
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue]] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue] withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
                else
                {
                    // Storage is empty, assign first item height to be
                    [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    // Add rectangle to first shelf
                    [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    // Save rectangle position on shelf
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue]] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue] withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }

            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    self->numberOfUsedShelves = [self->shelvesHeight count];
    
    return self->numberOfUsedShelves;
}

// PRIVATE: Block implementation of First Fit Bin Packing algorithm (used for GA)
// RETURNS: Number of used shelves
NSUInteger (^ffShelfFirstFitAlgorithm2DFF1) (NSMutableArray *) = ^(NSMutableArray * givenRectangles)
{
    NSMutableArray *ffShelvesHeight = [NSMutableArray new];
    NSMutableArray *ffCurrentlyUsedShelfWidth = [NSMutableArray new];
    
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Check if there's any open shelf
        if (0 == [ffShelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                // Storage is empty, assign first item height to be
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Add rectangle to first shelf
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
            }
            else
            {
                // Storage is empty, assign first item height to be
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Add rectangle to first shelf
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
            }
        }
        else
        {
            BOOL foundFittingShelf = NO;
            BOOL isRectangleRotated = NO;
            NSInteger iterator = -1;
            NSInteger fittingShelfId = -1;
            
            for (NSNumber *shelfHeight in ffShelvesHeight)
            {
                // Try to determine which rectangle size is smaller
                // That side will be candidate to place it by width in case second side fits height of shelf
                // 0 - width is smaller | 1 - height is smaller
                NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
                
                if (rectangle.size.height <= [shelfHeight floatValue] || rectangle.size.width <= [shelfHeight floatValue])
                {
                    if (0 == smallerSide)
                    {
                        if (rectangle.size.height <= [shelfHeight floatValue])
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceedes shelf width
                            if ((rectangle.size.width + [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= (float)FF_STORAGE_WIDTH)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = NO;
                                
                                break;
                            }
                        }
                        else
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceedes shelf width
                            if ((rectangle.size.height + [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= (float)FF_STORAGE_WIDTH)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = YES;
                                
                                break;
                            }
                        }
                    }
                    else
                    {
                        // Rectangle height wasn't fitting to shelf height
                        // ROTATE the rectangle and try to fit it with width-height sides swapped
                        if (rectangle.size.width <= [shelfHeight floatValue])
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceede shelf width
                            if ((rectangle.size.height + [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= (float)FF_STORAGE_WIDTH)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = YES;
                                
                                break;
                            }
                        }
                        else
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceede shelf width
                            if ((rectangle.size.width + [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= (float)FF_STORAGE_WIDTH)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = NO;
                                
                                break;
                            }
                            
                        }
                    }
                }
            }
            
            if (YES == foundFittingShelf)
            {
                // Add rectangle to fitting shelf
                // BE AWARE on fact that rectangle may be rotated
                float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue];
                
                if (NO == isRectangleRotated)
                {
                    [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:fittingShelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                }
                else
                {
                    [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:fittingShelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                }
            }
            else
            {
                // Fitting shelf not found, must add new one
                // NOTE: Should be aware of storage height, for v1 we won't pay attention to that
                
                // Place rectangle so that shorter side is height (flip it if needed)
                // 0 - width is smaller | 1 - height is smaller
                NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
                
                if (0 == smallerSide)
                {
                    // Storage is empty, assign first item height to be
                    [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    // Add rectangle to first shelf
                    [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                }
                else
                {
                    // Storage is empty, assign first item height to be
                    [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    // Add rectangle to first shelf
                    [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                }
                
            }
        }
    }
    
    return [ffShelvesHeight count];
};

// PRIVATE: Block implementation of First Fit Bin Packing algorithm (used for GA)
// RETURNS: Number of used shelves
NSUInteger (^ffShelfFirstFitAlgorithm2DFF2) (NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *) = ^(NSMutableArray * givenRectangles, NSMutableArray *ffCurrentlyUsedShelfWidth, NSMutableArray *ffShelvesHeight, NSMutableArray *ffCurrentlyUsedShelfArea)
{    
    [ffShelvesHeight removeAllObjects];
    [ffCurrentlyUsedShelfArea removeAllObjects];
    [ffCurrentlyUsedShelfWidth removeAllObjects];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [givenRectangles count]; i++)
    {
        [ffCurrentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Check if there's any open shelf
        if (0 == [ffShelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                // Storage is empty, assign first item height to be
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Add rectangle to first shelf
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                // Storage is empty, assign first item height to be
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Add rectangle to first shelf
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            BOOL foundFittingShelf = NO;
            BOOL isRectangleRotated = NO;
            NSInteger iterator = -1;
            NSInteger fittingShelfId = -1;
            
            for (NSNumber *shelfHeight in ffShelvesHeight)
            {
                // Try to determine which rectangle size is smaller
                // That side will be candidate to place it by width in case second side fits height of shelf
                // 0 - width is smaller | 1 - height is smaller
                NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
                
                if (rectangle.size.height <= [shelfHeight floatValue] || rectangle.size.width <= [shelfHeight floatValue])
                {
                    if (0 == smallerSide)
                    {
                        if (rectangle.size.height <= [shelfHeight floatValue])
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceedes shelf width
                            if ((rectangle.size.width + [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= (float)FF_STORAGE_WIDTH)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = NO;
                                
                                break;
                            }
                        }
                        else
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceedes shelf width
                            if ((rectangle.size.height + [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= (float)FF_STORAGE_WIDTH)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = YES;
                                
                                break;
                            }
                        }
                    }
                    else
                    {
                        // Rectangle height wasn't fitting to shelf height
                        // ROTATE the rectangle and try to fit it with width-height sides swapped
                        if (rectangle.size.width <= [shelfHeight floatValue])
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceede shelf width
                            if ((rectangle.size.height + [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= (float)FF_STORAGE_WIDTH)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = YES;
                                
                                break;
                            }
                        }
                        else
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceede shelf width
                            if ((rectangle.size.width + [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= (float)FF_STORAGE_WIDTH)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = NO;
                                
                                break;
                            }
                            
                        }
                    }
                }
            }
            
            if (YES == foundFittingShelf)
            {
                // Add rectangle to fitting shelf
                // BE AWARE on fact that rectangle may be rotated
                float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue];
                
                if (NO == isRectangleRotated)
                {
                    [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:fittingShelfId 
                                                             withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:fittingShelfId] floatValue];
                    [ffCurrentlyUsedShelfArea replaceObjectAtIndex:fittingShelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
                else
                {
                    [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:fittingShelfId 
                                                             withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:fittingShelfId] floatValue];
                    [ffCurrentlyUsedShelfArea replaceObjectAtIndex:fittingShelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
            else
            {
                // Fitting shelf not found, must add new one
                // NOTE: Should be aware of storage height, for v1 we won't pay attention to that
                
                // Place rectangle so that shorter side is height (flip it if needed)
                // 0 - width is smaller | 1 - height is smaller
                NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
                
                if (0 == smallerSide)
                {
                    // Storage is empty, assign first item height to be
                    [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    // Add rectangle to first shelf
                    [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:[[NSNumber numberWithInteger:([ffShelvesHeight count] - 1)] intValue]] floatValue];
                    [ffCurrentlyUsedShelfArea replaceObjectAtIndex:[[NSNumber numberWithInteger:([ffShelvesHeight count] - 1)] intValue] withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
                else
                {
                    // Storage is empty, assign first item height to be
                    [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    // Add rectangle to first shelf
                    [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:[[NSNumber numberWithInteger:([ffShelvesHeight count] - 1)] intValue]] floatValue];
                    [ffCurrentlyUsedShelfArea replaceObjectAtIndex:[[NSNumber numberWithInteger:([ffShelvesHeight count] - 1)] intValue] withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
                
            }
        }
    }

    return [ffShelvesHeight count];
};

// PUBLIC: First Fit Decreasing Algorithm
// RETURNS: Number of used shelves
- (NSUInteger) shelfFirstFitDecreasingAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    NSUInteger currentSelectedRectangle = 0;
    
    self->numberOfUsedShelves = 0;
    
    [self->rectangles removeAllObjects];
    [self->shelvesHeight removeAllObjects];
    [self->currentlyUsedShelfArea removeAllObjects];
    [self->currentlyUsedShelfWidth removeAllObjects];
    [self->rectanglesPositionsOnShelves removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    // Sort rectangles by height
    NSMutableArray *specArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        CGRect rectangle = [[self->rectangles objectAtIndex:i] CGRectValue];
        
        [specArray addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:rectangle.size.height], [NSNumber numberWithInteger:i], nil]];
    }
    
    NSArray *sortedArray = [specArray sortedArrayUsingFunction:customCompareFunctionDecr context:NULL];
    NSMutableArray *sortedRectangles = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [sortedRectangles addObject:[self->rectangles objectAtIndex:[[[sortedArray objectAtIndex:i] objectAtIndex:1] intValue]]];
    }
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [self->currentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in sortedRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Check if there's any open shelf
        if (0 == [self->shelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                // Storage is empty, assign first item height to be
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Add rectangle to first shelf
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                // Storage is empty, assign first item height to be
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Add rectangle to first shelf
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            BOOL foundFittingShelf = NO;
            BOOL isRectangleRotated = NO;
            NSInteger iterator = -1;
            NSInteger fittingShelfId = -1;
            
            for (NSNumber *shelfHeight in self->shelvesHeight)
            {
                // Try to determine which rectangle size is smaller
                // That side will be candidate to place it by width in case second side fits height of shelf
                // 0 - width is smaller | 1 - height is smaller
                NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
                
                if (rectangle.size.height <= [shelfHeight floatValue] || rectangle.size.width <= [shelfHeight floatValue])
                {
                    if (0 == smallerSide)
                    {
                        if (rectangle.size.height <= [shelfHeight floatValue])
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceedes shelf width
                            if ((rectangle.size.width + [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= self->storageWidth)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = NO;
                                
                                break;
                            }
                        }
                        else
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceedes shelf width
                            if ((rectangle.size.height + [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= self->storageWidth)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = YES;
                                
                                break;
                            }
                        }
                    }
                    else
                    {
                        // Rectangle height wasn't fitting to shelf height
                        // ROTATE the rectangle and try to fit it with width-height sides swapped
                        if (rectangle.size.width <= [shelfHeight floatValue])
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceede shelf width
                            if ((rectangle.size.height + [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= self->storageWidth)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = YES;
                                
                                break;
                            }
                        }
                        else
                        {
                            iterator += 1;
                            fittingShelfId = iterator;
                            // At this moment we found shelf where current rectangle fits by height
                            // We should now check if adding this rectangle to that shelf will exceede shelf width
                            if ((rectangle.size.width + [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue]) <= self->storageWidth)
                            {
                                foundFittingShelf = YES;
                                isRectangleRotated = NO;
                                
                                break;
                            }
                            
                        }
                    }
                }
            }
            
            if (YES == foundFittingShelf)
            {
                // Add rectangle to fitting shelf
                // BE AWARE on fact that rectangle may be rotated
                float currentShelfWidth = [[self->currentlyUsedShelfWidth objectAtIndex:fittingShelfId] floatValue];
                
                if (NO == isRectangleRotated)
                {
                    [self->currentlyUsedShelfWidth replaceObjectAtIndex:fittingShelfId 
                                                             withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                    
                    // Save rectangle position on shelf
                    NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:fittingShelfId], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:fittingShelfId] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:fittingShelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
                else
                {
                    [self->currentlyUsedShelfWidth replaceObjectAtIndex:fittingShelfId 
                                                             withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                    
                    // Save rectangle position on shelf
                    NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:fittingShelfId], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:fittingShelfId] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:fittingShelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
            }
            else
            {
                // Fitting shelf not found, must add new one
                // NOTE: Should be aware of storage height, for v1 we won't pay attention to that
                
                // Place rectangle so that shorter side is height (flip it if needed)
                // 0 - width is smaller | 1 - height is smaller
                NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
                
                if (0 == smallerSide)
                {
                    // Storage is empty, assign first item height to be
                    [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    // Add rectangle to first shelf
                    [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    // Save rectangle position on shelf
                    NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue]] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue] withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
                else
                {
                    // Storage is empty, assign first item height to be
                    [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                    
                    // Add rectangle to first shelf
                    [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                    
                    // Save rectangle position on shelf
                    NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                    [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                    
                    // Update used are on shelf
                    float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue]] floatValue];
                    [self->currentlyUsedShelfArea replaceObjectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue] withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
                }
                
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    self->numberOfUsedShelves = [self->shelvesHeight count];
    
    return self->numberOfUsedShelves;
}

// PUBLIC: Best Fit Bin Packing Algorithm
// RETURNS: Number of used shelves
- (NSUInteger) shelfBestFitAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    NSUInteger currentSelectedRectangle = 0;
    
    self->numberOfUsedShelves = 0;
    
    [self->rectangles removeAllObjects];
    [self->shelvesHeight removeAllObjects];
    [self->currentlyUsedShelfArea removeAllObjects];
    [self->currentlyUsedShelfWidth removeAllObjects];
    [self->rectanglesPositionsOnShelves removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [self->currentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in self->rectangles)
    {
        BOOL shouldRotateRectangle = NO;
        CGRect rectangle = [wrappedRectangle CGRectValue];

        // Find id of shelf where to put new rectangle
        NSInteger shelfId = [self getIndexOfBestFitBin:rectangle shouldRotate:(&shouldRotateRectangle)];
        
        if (-1 == shelfId)
        {
            if (NO == shouldRotateRectangle)
            {
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            float currentShelfWidth = [[self->currentlyUsedShelfWidth objectAtIndex:shelfId] floatValue];
            
            if (NO == shouldRotateRectangle)
            {
                [self->currentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];

                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:shelfId], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [self->currentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:shelfId], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    self->numberOfUsedShelves = [self->shelvesHeight count];
    
    return self->numberOfUsedShelves;
}

// PRIVATE: Block implementation of Best Fit Bin Packing algorithm (used for GA)
// RETURNS: Number of used shelves
NSUInteger (^ffShelfBestFitAlgorithm2DFF1) (NSMutableArray *) = ^(NSMutableArray * givenRectangles)
{
    NSUInteger currentSelectedRectangle = 0;
    
    NSMutableArray *ffShelvesHeight = [NSMutableArray new];
    NSMutableArray *ffCurrentlyUsedShelfArea = [NSMutableArray new];
    NSMutableArray *ffCurrentlyUsedShelfWidth = [NSMutableArray new];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [givenRectangles count]; i++)
    {
        [ffCurrentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        BOOL shouldRotateRectangle = NO;
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Find id of shelf where to put new rectangle
        NSInteger shelfId;
        
        /////////////
        
        float currentFilledShelfWidth = (float)INT_MAX;
        float fittingShelfHeight = (float)INT_MAX;
        
        // Check if there's any open shelf
        if (0 == [ffShelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                shouldRotateRectangle = YES;
            }
            else
            {
                shouldRotateRectangle = NO;
            }
            
            shelfId = -1;
        }
        else
        {
            BOOL foundFittingShelf = NO;
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            // Iterate through each shelf
            for (NSUInteger i = 0; i < [ffShelvesHeight count]; i++)
            {
                float currentShelfHeight = [[ffShelvesHeight objectAtIndex:i] floatValue];
                float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:i] floatValue];
                
                // Check if current rectangle's width or height fitts current shelf
                if (rectangle.size.height <= currentShelfHeight || rectangle.size.width <= currentShelfHeight)
                {
                    if (0 == smallerSide)
                    {
                        if (rectangle.size.height <= currentShelfHeight)
                        {
                            if (currentShelfWidth + rectangle.size.width < currentFilledShelfWidth && currentShelfWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.height < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.width;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = NO;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.height;
                                }
                            }
                        }
                        else
                        {
                            if (currentShelfWidth + rectangle.size.height < currentFilledShelfWidth && currentShelfWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.width < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.height;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = YES;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.width;
                                }
                            }
                        }
                    }
                    else
                    {
                        if (rectangle.size.width <= currentShelfHeight)
                        {
                            if (currentShelfWidth + rectangle.size.height < currentFilledShelfWidth && currentShelfWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.width < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.height;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = YES;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.width;
                                }
                            }
                        }
                        else
                        {
                            if (currentShelfWidth + rectangle.size.width < currentFilledShelfWidth && currentShelfWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.height < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.width;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = NO;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.height;
                                }
                            }
                        }
                    }
                }
            }
            
            if (NO == foundFittingShelf)
            {
                // Create new shelf
                if (0 == smallerSide)
                {
                    shouldRotateRectangle = YES;
                }
                else
                {
                    shouldRotateRectangle = NO;
                }
                
                shelfId = -1;
            }
        }
        
        /////////////
        
        if (-1 == shelfId)
        {
            if (NO == shouldRotateRectangle)
            {
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:shelfId] floatValue];
            
            if (NO == shouldRotateRectangle)
            {
                [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                     withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                
                // Update used area on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                     withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                
                // Update used area on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    return [ffShelvesHeight count];
};

// PRIVATE: Block implementation of Best Fit Bin Packing algorithm (used for GA)
// RETURNS: Number of used shelves
NSUInteger (^ffShelfBestFitAlgorithm2DFF2) (NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *) = ^(NSMutableArray * givenRectangles, NSMutableArray *ffCurrentlyUsedShelfWidth, NSMutableArray *ffShelvesHeight, NSMutableArray *ffCurrentlyUsedShelfArea)
{
    NSUInteger currentSelectedRectangle = 0;
    
    [ffCurrentlyUsedShelfWidth removeAllObjects];
    [ffCurrentlyUsedShelfArea removeAllObjects];
    [ffShelvesHeight removeAllObjects];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [givenRectangles count]; i++)
    {
        [ffCurrentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        BOOL shouldRotateRectangle = NO;
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Find id of shelf where to put new rectangle
        NSInteger shelfId;
        
        /////////////

        float currentFilledShelfWidth = (float)INT_MAX;
        float fittingShelfHeight = (float)INT_MAX;
        
        // Check if there's any open shelf
        if (0 == [ffShelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                shouldRotateRectangle = YES;
            }
            else
            {
                shouldRotateRectangle = NO;
            }
            
            shelfId = -1;
        }
        else
        {
            BOOL foundFittingShelf = NO;
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            // Iterate through each shelf
            for (NSUInteger i = 0; i < [ffShelvesHeight count]; i++)
            {
                float currentShelfHeight = [[ffShelvesHeight objectAtIndex:i] floatValue];
                float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:i] floatValue];
                
                // Check if current rectangle's width or height fitts current shelf
                if (rectangle.size.height <= currentShelfHeight || rectangle.size.width <= currentShelfHeight)
                {
                    if (0 == smallerSide)
                    {
                        if (rectangle.size.height <= currentShelfHeight)
                        {
                            if (currentShelfWidth + rectangle.size.width < currentFilledShelfWidth && currentShelfWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.height < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.width;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = NO;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.height;
                                }
                            }
                        }
                        else
                        {
                            if (currentShelfWidth + rectangle.size.height < currentFilledShelfWidth && currentShelfWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.width < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.height;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = YES;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.width;
                                }
                            }
                        }
                    }
                    else
                    {
                        if (rectangle.size.width <= currentShelfHeight)
                        {
                            if (currentShelfWidth + rectangle.size.height < currentFilledShelfWidth && currentShelfWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.width < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.height;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = YES;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.width;
                                }
                            }
                        }
                        else
                        {
                            if (currentShelfWidth + rectangle.size.width < currentFilledShelfWidth && currentShelfWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.height < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.width;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = NO;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.height;
                                }
                            }
                        }
                    }
                }
            }
            
            if (NO == foundFittingShelf)
            {
                // Create new shelf
                if (0 == smallerSide)
                {
                    shouldRotateRectangle = YES;
                }
                else
                {
                    shouldRotateRectangle = NO;
                }
                
                shelfId = -1;
            }
        }
        
        /////////////
        
        if (-1 == shelfId)
        {
            if (NO == shouldRotateRectangle)
            {
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:shelfId] floatValue];
            
            if (NO == shouldRotateRectangle)
            {
                [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                
                // Update used area on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                
                // Update used area on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    return [ffShelvesHeight count];
};

// PUBLIC: Best Fit Decreasing Bin Packing Algorithm
// RETURNS: Number of used shelves
- (NSUInteger) shelfBestFitDecreasingAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    NSUInteger currentSelectedRectangle = 0;
    
    self->numberOfUsedShelves = 0;
    
    [self->rectangles removeAllObjects];
    [self->shelvesHeight removeAllObjects];
    [self->currentlyUsedShelfArea removeAllObjects];
    [self->currentlyUsedShelfWidth removeAllObjects];
    [self->rectanglesPositionsOnShelves removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    // Sort rectangles by height
    NSMutableArray *specArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        CGRect rectangle = [[self->rectangles objectAtIndex:i] CGRectValue];
        
        [specArray addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:rectangle.size.height], [NSNumber numberWithInteger:i], nil]];
    }
    
    NSArray *sortedArray = [specArray sortedArrayUsingFunction:customCompareFunctionDecr context:NULL];
    NSMutableArray *sortedRectangles = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [sortedRectangles addObject:[self->rectangles objectAtIndex:[[[sortedArray objectAtIndex:i] objectAtIndex:1] intValue]]];
    }
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [self->currentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in sortedRectangles)
    {
        BOOL shouldRotateRectangle = NO;
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Find id of shelf where to put new rectangle
        NSInteger shelfId = [self getIndexOfBestFitBin:rectangle shouldRotate:(&shouldRotateRectangle)];
        
        if (-1 == shelfId)
        {
            if (NO == shouldRotateRectangle)
            {
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                // Save rectangle position on shelf
                NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue]] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue] withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                // Save rectangle position on shelf
                NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue]] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:[[NSNumber numberWithInteger:([self->shelvesHeight count] - 1)] intValue] withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            float currentShelfWidth = [[self->currentlyUsedShelfWidth objectAtIndex:shelfId] floatValue];
            
            if (NO == shouldRotateRectangle)
            {
                [self->currentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                
                // Save rectangle position on shelf
                NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:shelfId], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [self->currentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                
                // Save rectangle position on shelf
                NSUInteger originalRectangleIndex = [[[sortedArray objectAtIndex:currentSelectedRectangle] objectAtIndex:1] intValue];
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:shelfId], [NSNumber numberWithInteger:originalRectangleIndex], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    self->numberOfUsedShelves = [self->shelvesHeight count];
    
    return self->numberOfUsedShelves;
}

// PUBLIC: Worst Fit Bin Packing Algorithm
// RETURNS: Number of used shelves
- (NSUInteger) shelfWorstFitAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    NSUInteger currentSelectedRectangle = 0;
    
    self->numberOfUsedShelves = 0;
    
    [self->rectangles removeAllObjects];
    [self->shelvesHeight removeAllObjects];
    [self->currentlyUsedShelfArea removeAllObjects];
    [self->currentlyUsedShelfWidth removeAllObjects];
    [self->rectanglesPositionsOnShelves removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [self->currentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in self->rectangles)
    {
        BOOL shouldRotateRectangle = NO;
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Find id of shelf where to put new rectangle
        NSInteger shelfId = [self getIndexOfWorstFitBin:rectangle shouldRotate:(&shouldRotateRectangle)];
        
        if (-1 == shelfId)
        {
            if (NO == shouldRotateRectangle)
            {
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            float currentShelfWidth = [[self->currentlyUsedShelfWidth objectAtIndex:shelfId] floatValue];
            
            if (NO == shouldRotateRectangle)
            {
                [self->currentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:shelfId], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [self->currentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:shelfId], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    self->numberOfUsedShelves = [self->shelvesHeight count];
    
    return self->numberOfUsedShelves;
}

// PRIVATE: Block implementation of Worst Fit Bin Packing algorithm (used for GA)
// RETURNS: Number of used shelves
NSUInteger (^ffShelfWorstFitAlgorithm2DFF1) (NSMutableArray *) = ^(NSMutableArray * givenRectangles)
{
    NSUInteger currentSelectedRectangle = 0;
    
    NSMutableArray *ffShelvesHeight = [NSMutableArray new];
    NSMutableArray *ffCurrentlyUsedShelfArea = [NSMutableArray new];
    NSMutableArray *ffCurrentlyUsedShelfWidth = [NSMutableArray new];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [givenRectangles count]; i++)
    {
        [ffCurrentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        BOOL shouldRotateRectangle = NO;
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Find id of shelf where to put new rectangle
        NSInteger shelfId;
        
        /////////////
        
        float currentFilledShelfWidth = 0.0f;
        float fittingShelfHeight = (float)INT_MAX;
        
        // Check if there's any open shelf
        if (0 == [ffShelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                shouldRotateRectangle = YES;
            }
            else
            {
                shouldRotateRectangle = NO;
            }
            
            shelfId = -1;
        }
        else
        {
            BOOL foundFittingShelf = NO;
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            // Iterate through each shelf
            for (NSUInteger i = 0; i < [ffShelvesHeight count]; i++)
            {
                float currentShelfHeight = [[ffShelvesHeight objectAtIndex:i] floatValue];
                float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:i] floatValue];
                
                // Check if current rectangle's width or height fitts current shelf
                if (rectangle.size.height <= currentShelfHeight || rectangle.size.width <= currentShelfHeight)
                {
                    if (0 == smallerSide)
                    {
                        if (rectangle.size.height <= currentShelfHeight)
                        {
                            if (currentShelfWidth + rectangle.size.width > currentFilledShelfWidth && currentShelfWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.height < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.width;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = NO;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.height;
                                }
                            }
                        }
                        else
                        {
                            if (currentShelfWidth + rectangle.size.height > currentFilledShelfWidth && currentShelfWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.width < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.height;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = YES;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.width;
                                }
                            }
                        }
                    }
                    else
                    {
                        if (rectangle.size.width <= currentShelfHeight)
                        {
                            if (currentShelfWidth + rectangle.size.height > currentFilledShelfWidth && currentShelfWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.width < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.height;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = YES;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.width;
                                }
                            }
                        }
                        else
                        {
                            if (currentShelfWidth + rectangle.size.width > currentFilledShelfWidth && currentShelfWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.height < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.width;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = NO;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.height;
                                }
                            }
                        }
                    }
                }
            }
            
            if (NO == foundFittingShelf)
            {
                // Create new shelf
                if (0 == smallerSide)
                {
                    shouldRotateRectangle = YES;
                }
                else
                {
                    shouldRotateRectangle = NO;
                }
                
                shelfId = -1;
            }
        }
        
        /////////////
        
        if (-1 == shelfId)
        {
            if (NO == shouldRotateRectangle)
            {
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:shelfId] floatValue];
            
            if (NO == shouldRotateRectangle)
            {
                [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                     withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                
                // Update used area on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                     withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                
                // Update used area on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    return [ffShelvesHeight count];
};

// PRIVATE: Block implementation of Best Fit Bin Packing algorithm (used for GA)
// RETURNS: Number of used shelves
NSUInteger (^ffShelfWorstFitAlgorithm2DFF2) (NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *) = ^(NSMutableArray * givenRectangles, NSMutableArray *ffCurrentlyUsedShelfWidth, NSMutableArray *ffShelvesHeight, NSMutableArray *ffCurrentlyUsedShelfArea)
{
    NSUInteger currentSelectedRectangle = 0;
    
    [ffCurrentlyUsedShelfWidth removeAllObjects];
    [ffCurrentlyUsedShelfArea removeAllObjects];
    [ffShelvesHeight removeAllObjects];
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [givenRectangles count]; i++)
    {
        [ffCurrentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in givenRectangles)
    {
        BOOL shouldRotateRectangle = NO;
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Find id of shelf where to put new rectangle
        NSInteger shelfId;
        
        /////////////
        
        float currentFilledShelfWidth = 0.0f;
        float fittingShelfHeight = (float)INT_MAX;
        
        // Check if there's any open shelf
        if (0 == [ffShelvesHeight count])
        {
            // Place rectangle so that shorter side is height (flip it if needed)
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            if (0 == smallerSide)
            {
                shouldRotateRectangle = YES;
            }
            else
            {
                shouldRotateRectangle = NO;
            }
            
            shelfId = -1;
        }
        else
        {
            BOOL foundFittingShelf = NO;
            // 0 - width is smaller | 1 - height is smaller
            NSUInteger smallerSide = (rectangle.size.width < rectangle.size.height ? 0 : 1);
            
            // Iterate through each shelf
            for (NSUInteger i = 0; i < [ffShelvesHeight count]; i++)
            {
                float currentShelfHeight = [[ffShelvesHeight objectAtIndex:i] floatValue];
                float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:i] floatValue];
                
                // Check if current rectangle's width or height fitts current shelf
                if (rectangle.size.height <= currentShelfHeight || rectangle.size.width <= currentShelfHeight)
                {
                    if (0 == smallerSide)
                    {
                        if (rectangle.size.height <= currentShelfHeight)
                        {
                            if (currentShelfWidth + rectangle.size.width > currentFilledShelfWidth && currentShelfWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.height < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.width;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = NO;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.height;
                                }
                            }
                        }
                        else
                        {
                            if (currentShelfWidth + rectangle.size.height > currentFilledShelfWidth && currentShelfWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.width < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.height;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = YES;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.width;
                                }
                            }
                        }
                    }
                    else
                    {
                        if (rectangle.size.width <= currentShelfHeight)
                        {
                            if (currentShelfWidth + rectangle.size.height > currentFilledShelfWidth && currentShelfWidth + rectangle.size.height <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.width < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.height;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = YES;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.width;
                                }
                            }
                        }
                        else
                        {
                            if (currentShelfWidth + rectangle.size.width > currentFilledShelfWidth && currentShelfWidth + rectangle.size.width <= (float)FF_STORAGE_WIDTH)
                            {
                                // If there are two shelves with same width, place rectangle on shelf which
                                // has closer height value to new rectangle
                                if (currentShelfHeight - rectangle.size.height < fittingShelfHeight)
                                {
                                    currentFilledShelfWidth = currentShelfWidth + rectangle.size.width;
                                    shelfId = i;
                                    
                                    shouldRotateRectangle = NO;
                                    foundFittingShelf = YES;
                                    
                                    fittingShelfHeight = currentShelfHeight - rectangle.size.height;
                                }
                            }
                        }
                    }
                }
            }
            
            if (NO == foundFittingShelf)
            {
                // Create new shelf
                if (0 == smallerSide)
                {
                    shouldRotateRectangle = YES;
                }
                else
                {
                    shouldRotateRectangle = NO;
                }
                
                shelfId = -1;
            }
        }
        
        /////////////
        
        if (-1 == shelfId)
        {
            if (NO == shouldRotateRectangle)
            {
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [ffShelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                [ffCurrentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [ffShelvesHeight count] - 1;
                
                // Update used are on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            float currentShelfWidth = [[ffCurrentlyUsedShelfWidth objectAtIndex:shelfId] floatValue];
            
            if (NO == shouldRotateRectangle)
            {
                [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                     withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                
                // Update used area on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [ffCurrentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                     withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                
                // Update used area on shelf
                float thisShelfUsedArea = [[ffCurrentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [ffCurrentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    return [ffShelvesHeight count];
};

// PUBLIC: Worst Fit Decreasing Bin Packing Algorithm
// RETURNS: Number of used shelves
- (NSUInteger) shelfWorstFitDecreasingAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    NSUInteger currentSelectedRectangle = 0;
    
    self->numberOfUsedShelves = 0;
    
    [self->rectangles removeAllObjects];
    [self->shelvesHeight removeAllObjects];
    [self->currentlyUsedShelfArea removeAllObjects];
    [self->currentlyUsedShelfWidth removeAllObjects];
    [self->rectanglesPositionsOnShelves removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    // Sort rectangles by height
    NSMutableArray *specArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        CGRect rectangle = [[self->rectangles objectAtIndex:i] CGRectValue];
        
        [specArray addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:rectangle.size.height], [NSNumber numberWithInteger:i], nil]];
    }
    
    NSArray *sortedArray = [specArray sortedArrayUsingFunction:customCompareFunctionDecr context:NULL];
    NSMutableArray *sortedRectangles = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [sortedRectangles addObject:[self->rectangles objectAtIndex:[[[sortedArray objectAtIndex:i] objectAtIndex:1] intValue]]];
    }
    
    // Fill currently used shelf area array with zeros, since they will be replaced in algorithm
    for (NSUInteger i = 0; i < [self->rectangles count]; i++)
    {
        [self->currentlyUsedShelfArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // Algorithm loop
    for (NSValue *wrappedRectangle in sortedRectangles)
    {
        BOOL shouldRotateRectangle = NO;
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        // Find id of shelf where to put new rectangle
        NSInteger shelfId = [self getIndexOfWorstFitBin:rectangle shouldRotate:(&shouldRotateRectangle)];
        
        if (-1 == shelfId)
        {
            if (NO == shouldRotateRectangle)
            {
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [self->shelvesHeight addObject:[NSNumber numberWithFloat:rectangle.size.width]];
                [self->currentlyUsedShelfWidth addObject:[NSNumber numberWithFloat:rectangle.size.height]];
                
                NSUInteger currentShelfIndex = [self->shelvesHeight count] - 1;
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:currentShelfIndex], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:currentShelfIndex] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:currentShelfIndex withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        else
        {
            float currentShelfWidth = [[self->currentlyUsedShelfWidth objectAtIndex:shelfId] floatValue];
            
            if (NO == shouldRotateRectangle)
            {
                [self->currentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.width)]];
                
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:shelfId], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
            else
            {
                [self->currentlyUsedShelfWidth replaceObjectAtIndex:shelfId 
                                                         withObject:[NSNumber numberWithFloat:(currentShelfWidth + rectangle.size.height)]];
                
                // Save rectangle position on shelf
                [self->rectanglesPositionsOnShelves addObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:shelfId], [NSNumber numberWithInteger:currentSelectedRectangle], nil]];
                
                // Update used are on shelf
                float thisShelfUsedArea = [[self->currentlyUsedShelfArea objectAtIndex:shelfId] floatValue];
                [self->currentlyUsedShelfArea replaceObjectAtIndex:shelfId withObject:[NSNumber numberWithFloat:(thisShelfUsedArea + rectangle.size.width * rectangle.size.height)]];
            }
        }
        
        currentSelectedRectangle += 1;
    }
    
    self->numberOfUsedShelves = [self->shelvesHeight count];
    
    return self->numberOfUsedShelves;
}

// PUBLIC: Detail Search Bin Packing Algorithm
// RETURNS: Number of used bins
- (NSUInteger) detailSearchAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    NSInteger size = [givenRectangles count];
    self->bestShelfNumber = INT_MAX;
    self->bestWidthUsagePercentage = 0.0f;
    self->permutationCount = 0;
    
    int indexes[size];
    
    for (NSUInteger i = 0; i < size; i++)
    {
        indexes[i] = i;
    }

    [self permutationArray2D:indexes 
           initialPosition:0 
               sizeOfArray:size 
                givenItems:givenRectangles];
    
    float shelvesUsedArea = 0.0f;
    float storageUsedArea = 0.0f;
    float storageUsedHeight = 0.0f;
    float storageArea = self->storageWidth * self->storageHeight;
    
    // Calculate actual area used by added rectangles
    for (NSValue *wrappedRectangle in self->bestRectangleCombination)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        storageUsedArea += rectangle.size.width * rectangle.size.height;
    }
    
    // Calculate storage used height
    for (NSNumber *height in self->bestShelvesHeight)
    {
        storageUsedHeight += [height floatValue];
    }
    
    // Calculate shelves used area
    for (NSNumber *shelfArea in self->currentlyUsedShelfArea)
    {
        shelvesUsedArea += [shelfArea floatValue];
    }
    
    self->totalShelvesUsedArea = storageUsedHeight * self->storageWidth;
    self->wastedArea = storageUsedHeight * self->storageWidth - shelvesUsedArea;
    self->wastedAreaPercentage = self->wastedArea / self->totalShelvesUsedArea * 100.0f;
    
    // Print report
    NSLog(@"Used storage: %.2f%%", storageUsedArea / storageArea * 100.0f);
    NSLog(@"Used storage height: %.2f [%.2f%%]", storageUsedHeight, storageUsedHeight / self->storageHeight * 100.0f);
    NSLog(@"Number of shelves used: %lu", (unsigned long)[self->bestShelvesHeight count]);
    NSLog(@"Wasted area on shelves: %.2f/%.2f [%.2f%%]", self->wastedArea, self->totalShelvesUsedArea, self->wastedAreaPercentage);
    
    self->numberOfUsedShelves = self->bestShelfNumber;
    
    return self->numberOfUsedShelves;
}

// PUBLIC: Bin Packing algorithm with usage of Genetic Algorithm
// RETURNS: Number of bins found in optimal item scheduling
// NOTE: Fitness function choice: 0 - Next Fit
//                                1 - First Fit
//                                2 - Best Fit
//                                3 - Worst Fit
- (NSUInteger) searchWithUsageOfGeneticAlgorithmForRectangles:(NSMutableArray *)bpRectangles
                                    numberOfUnitsInGeneration:(NSUInteger)unitNumber
                                          numberOfGenerations:(NSUInteger)generationsNumber 
                                     mutationFactorPercentage:(NSUInteger)mutationFactor 
                                                elitismFactor:(NSUInteger)elitismFactor 
                                      numberOfCrossoverPoints:(NSUInteger)crossoverPoints 
                                     fitnessFunctionSelection:(NSUInteger)choice
{
    // Initialize GA factory object
    NSUInteger currentNumberOfGenerations = 0;
    GeneticAlgorithmFactory2D *gaFactory = [[GeneticAlgorithmFactory2D alloc] initWithNumberOfUnitsInGeneration:unitNumber 
                                                                                                rectanglesArray:bpRectangles
                                                                                                  elitismFactor:elitismFactor
                                                                                                   storageWidth:self->storageWidth 
                                                                                                  storageHeight:self->storageHeight];
    // Create initial population and calculate costs
    [gaFactory generateInitialPopulation];

    switch (choice)
    {
        case 0: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfNextFitAlgorithm2DFF1 
                                                     fitnessFunction2:ffShelfNextFitAlgorithm2DFF2];
            break;
        case 1: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfFirstFitAlgorithm2DFF1 
                                                     fitnessFunction2:ffShelfFirstFitAlgorithm2DFF2];
            break;
        case 2: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfBestFitAlgorithm2DFF1 
                                                     fitnessFunction2:ffShelfBestFitAlgorithm2DFF2];
            break;
        case 3: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfWorstFitAlgorithm2DFF1 
                                                     fitnessFunction2:ffShelfWorstFitAlgorithm2DFF2];
            break;
        default: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfBestFitAlgorithm2DFF1 
                                                      fitnessFunction2:ffShelfBestFitAlgorithm2DFF2];
            break;
    }
    
    // GA loop
    do
    {
        currentNumberOfGenerations += 1;
        
        // Do mating and mutation
        [gaFactory mate:elitismFactor];
        [gaFactory mutate:mutationFactor];
        
        // Swap generations and calculate costs
        [gaFactory generationSwap];

        switch (choice)
        {
            case 0: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfNextFitAlgorithm2DFF1 
                                                         fitnessFunction2:ffShelfNextFitAlgorithm2DFF2];
                break;
            case 1: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfFirstFitAlgorithm2DFF1 
                                                         fitnessFunction2:ffShelfFirstFitAlgorithm2DFF2];
                break;
            case 2: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfBestFitAlgorithm2DFF1 
                                                         fitnessFunction2:ffShelfBestFitAlgorithm2DFF2];
                break;
            case 3: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfWorstFitAlgorithm2DFF1 
                                                         fitnessFunction2:ffShelfWorstFitAlgorithm2DFF2];
                break;
            default: [gaFactory calculateGenerationCostForFitnessFunction1:ffShelfBestFitAlgorithm2DFF1 
                                                          fitnessFunction2:ffShelfBestFitAlgorithm2DFF2];
                break;
        }
        
    } while (currentNumberOfGenerations < generationsNumber);
    
    self->numberOfUsedShelves = gaFactory.lowestCost;
    
    NSLog(@"Used storage: %.2f%%", gaFactory.usedStorage);
    NSLog(@"Used storage height: %.2f [%.2f%%]", gaFactory.usedStorageHeight, gaFactory.usedStorageHeightPercent);
    NSLog(@"Number of shelves used: %lu", (unsigned long)self->numberOfUsedShelves);
    NSLog(@"Wasted area on shelves: %.2f/%.2f [%.2f%%]", gaFactory.bestShelvesUsage, gaFactory.usedStorageHeight * self->storageWidth, gaFactory.bestShelvesUsage / (gaFactory.usedStorageHeight * self->storageWidth) * 100.0f);
    
    return self->numberOfUsedShelves;
}

// PUBLIC: Bottom-left Bin Packing Algorithm
// NOTE: This algorithm must be improved in order to take all cases in considerations!
- (void) bottomLeftAlgorithm2DForGivenRectangles:(NSMutableArray *)givenRectangles
{
    NSMutableArray *availablePoints = [NSMutableArray new];
    
    [self->addedRectangles removeAllObjects];
    [self->rectangles removeAllObjects];
    [self->rectangles addObjectsFromArray:givenRectangles];
    
    for (NSValue *wrappedRectangle in self->rectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        if (0 == [addedRectangles count])
        {
            // We are adding first rectangle in bottom left position on coordinates (0,0)
            CGRect rectangleToAdd = CGRectMake(0.0f, 0.0f, rectangle.size.width, rectangle.size.height);
            NSValue *rectangleToAddWrapped = [NSValue valueWithCGRect:rectangleToAdd];
            
            [self->addedRectangles addObject:rectangleToAddWrapped];
            
            // Determine available points as possible locations to add new rectangle
            CGPoint newAvailablePoint1 = CGPointMake(0.0f + rectangleToAdd.size.width, 0.0f);
            CGPoint newAvailablePoint2 = CGPointMake(0.0f, 0.0f + rectangleToAdd.size.height);
            
            NSValue *newAvailablePoint1Wrapped = [NSValue valueWithCGPoint:newAvailablePoint1];
            NSValue *newAvailablePoint2Wrapped = [NSValue valueWithCGPoint:newAvailablePoint2];
            
            [availablePoints addObject:newAvailablePoint1Wrapped];
            [availablePoints addObject:newAvailablePoint2Wrapped];
        }
        else
        {
            NSUInteger bestPointIndex = 0;
            
            BOOL foundFittingPoint = NO;
            
            // Some rectangle(s) already exist(s) in storage
            for (NSValue *wrappedPoint in availablePoints)
            {
                BOOL doesCurrentPointFits = YES;
                
                CGPoint point = [wrappedPoint CGPointValue];
                
                if (point.y + rectangle.size.height <= self->storageHeight)
                {
                    if (point.x + rectangle.size.width <= self->storageWidth)
                    {
                        // Check if it is possible to place rectangle on current location
                        // (maybe some rectangle placed above or on the right is blocking this rectangle
                        for (NSValue *wrappedPlacedRectangle in addedRectangles)
                        {
                            CGRect placedRectangle = [wrappedPlacedRectangle CGRectValue];
                            
                            if (point.y < placedRectangle.origin.y)
                            {
                                if (point.y + rectangle.size.height > placedRectangle.origin.y)
                                {
                                    if (placedRectangle.origin.x + placedRectangle.size.width > point.x)
                                    {
                                        doesCurrentPointFits = NO;
                                        break;
                                    }
                                }
                            }
                                
                            if (point.y > placedRectangle.origin.y)
                            {
                                if (placedRectangle.size.height + placedRectangle.origin.y > point.y)
                                {
                                    if (point.x + rectangle.size.width > placedRectangle.origin.x)
                                    {
                                        if (point.x < placedRectangle.origin.x)
                                        {
                                            doesCurrentPointFits = NO;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        doesCurrentPointFits = NO;
                    }
                }
                else
                {
                    doesCurrentPointFits = NO;
                }
                
                if (YES == doesCurrentPointFits)
                {
                    foundFittingPoint = YES;
                    
                    CGRect addedRectangle = CGRectMake(point.x, point.y, rectangle.size.width, rectangle.size.height);
                    NSValue *addedRectangleWrapped = [NSValue valueWithCGRect:addedRectangle];
                    
                    [self->addedRectangles addObject:addedRectangleWrapped];
                    
                    [availablePoints removeObjectAtIndex:bestPointIndex];
                    
                    // Determine available points as possible locations to add new rectangle
                    CGPoint newAvailablePoint1 = CGPointMake(addedRectangle.origin.x + addedRectangle.size.width, addedRectangle.origin.y);
                    CGPoint newAvailablePoint2 = CGPointMake(addedRectangle.origin.x, addedRectangle.origin.y + addedRectangle.size.height);
                    
                    NSValue *newAvailablePoint1Wrapped = [NSValue valueWithCGPoint:newAvailablePoint1];
                    NSValue *newAvailablePoint2Wrapped = [NSValue valueWithCGPoint:newAvailablePoint2];
                
                    [availablePoints addObject:newAvailablePoint1Wrapped];
                    [availablePoints addObject:newAvailablePoint2Wrapped];
                    
                    [availablePoints sortUsingComparator: ^NSComparisonResult (id obj1, id obj2) 
                    {  
                         CGPoint pt1 = [obj1 CGPointValue];  
                         CGPoint pt2 = [obj2 CGPointValue];  
                         
                         if (pt1.y > pt2.y)
                         {
                             return NSOrderedDescending;
                         }
                         else if (pt1.x < pt2.x)
                         {
                             return NSOrderedAscending;
                         }
                         else
                         {
                             return NSOrderedSame;
                         }
                     }]; 
                    
                    break;
                }
                
                bestPointIndex += 1;
            }
            
            if (NO == foundFittingPoint)
            {
                float usedHeight = 0.0f;
                
                for (NSValue *addedRectangleWrapped in self->addedRectangles)
                {
                    CGRect addedRectangle = [addedRectangleWrapped CGRectValue];
                    
                    if (addedRectangle.origin.y + addedRectangle.size.height > usedHeight)
                    {
                        usedHeight = addedRectangle.origin.y + addedRectangle.size.height;
                    }
                }
                
                CGRect addedRectangle = CGRectMake(0.0f, usedHeight, rectangle.size.width, rectangle.size.height);
                NSValue *addedRectangleWrapped = [NSValue valueWithCGRect:addedRectangle];
                
                [self->addedRectangles addObject:addedRectangleWrapped];
                
                // Determine available points as possible locations to add new rectangle
                CGPoint newAvailablePoint1 = CGPointMake(addedRectangle.origin.x + addedRectangle.size.width, addedRectangle.origin.y);
                CGPoint newAvailablePoint2 = CGPointMake(addedRectangle.origin.x, addedRectangle.origin.y + addedRectangle.size.height);
                
                NSValue *newAvailablePoint1Wrapped = [NSValue valueWithCGPoint:newAvailablePoint1];
                NSValue *newAvailablePoint2Wrapped = [NSValue valueWithCGPoint:newAvailablePoint2];
                
                [availablePoints addObject:newAvailablePoint1Wrapped];
                [availablePoints addObject:newAvailablePoint2Wrapped];
                
                [availablePoints sortUsingComparator: ^NSComparisonResult (id obj1, id obj2) 
                 {  
                     CGPoint pt1 = [obj1 CGPointValue];  
                     CGPoint pt2 = [obj2 CGPointValue];  
                     
                     if (pt1.y > pt2.y)
                     {
                         return NSOrderedDescending;
                     }
                     else if (pt1.x < pt2.x)
                     {
                         return NSOrderedAscending;
                     }
                     else
                     {
                         return NSOrderedSame;
                     }
                 }]; 
            }
        }
    }
}


- (id)finalPackingData {
    return nil;
}
// PUBLIC: Calculate storage occupacy
- (void) showStorageUsageDetails
{
    float shelvesUsedArea = 0.0f;
    float storageUsedArea = 0.0f;
    float storageUsedHeight = 0.0f;
    float storageArea = self->storageWidth * self->storageHeight;
    
    // Calculate actual area used by added rectangles
    for (NSValue *wrappedRectangle in self->rectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        storageUsedArea += rectangle.size.width * rectangle.size.height;
    }
    
    float estimatedOptimalHeight = ceilf(storageUsedArea / 10);
    
    // Calculate storage used height
    for (NSNumber *height in self->shelvesHeight)
    {
        storageUsedHeight += [height floatValue];
    }
    
    // Calculate shelves used area
    for (NSNumber *shelfArea in self->currentlyUsedShelfArea)
    {
        shelvesUsedArea += [shelfArea floatValue];
    }
    
    self->totalShelvesUsedArea = storageUsedHeight * self->storageWidth;
    self->wastedArea = storageUsedHeight * self->storageWidth - shelvesUsedArea;
    self->wastedAreaPercentage = self->wastedArea / self->totalShelvesUsedArea * 100.0f;
    
    // Print report
    NSLog(@"Used storage / storage area: %.2f / %.2f [%.2f%%]", storageUsedArea, storageArea, storageUsedArea / storageArea * 100.0f);
    NSLog(@"Used storage height / estimated optimal: %.2f / %.2f", storageUsedHeight, estimatedOptimalHeight);
    NSLog(@"Number of shelves used: %lu", (unsigned long)self->numberOfUsedShelves);
    NSLog(@"Wasted area on shelves: %.2f/%.2f [%.2f%%]", self->wastedArea, self->totalShelvesUsedArea, self->wastedAreaPercentage);
}

// PUBLIC: Calculate storage occupacy
- (void) showBottomLeftStorageUsageDetails
{
    float shelvesUsedArea = 0.0f;
    float storageUsedArea = 0.0f;
    float storageUsedHeight = 0.0f;
    float storageArea = self->storageWidth * self->storageHeight;
    
    // Calculate actual area used by added rectangles
    for (NSValue *wrappedRectangle in self->addedRectangles)
    {
        CGRect rectangle = [wrappedRectangle CGRectValue];
        
        storageUsedArea += rectangle.size.width * rectangle.size.height;
    }
    
    float estimatedOptimalHeight = ceilf(storageUsedArea / 10);
    
    // Calculate storage used height
    for (NSValue *addedRectangleWrapped in self->addedRectangles)
    {
        CGRect addedRectangle = [addedRectangleWrapped CGRectValue];
        
        if (addedRectangle.origin.y + addedRectangle.size.height > storageUsedHeight)
        {
            storageUsedHeight = addedRectangle.origin.y + addedRectangle.size.height;
        }
    }
    
    // Calculate shelves used area
    for (NSNumber *shelfArea in self->currentlyUsedShelfArea)
    {
        shelvesUsedArea += [shelfArea floatValue];
    }
    
    self->totalShelvesUsedArea = storageUsedHeight * self->storageWidth;
    self->wastedArea = storageUsedHeight * self->storageWidth - storageUsedArea;
    self->wastedAreaPercentage = self->wastedArea / self->totalShelvesUsedArea * 100.0f;
    
    // Print report
    NSLog(@"Used storage / storage area: %.2f / %.2f [%.2f%%]", storageUsedArea, storageArea, storageUsedArea / storageArea * 100.0f);
    NSLog(@"Used storage height / estimated optimal: %.2f / %.2f", storageUsedHeight, estimatedOptimalHeight);
    NSLog(@"Wasted area of used area: %.2f/%.2f [%.2f%%]", self->wastedArea, self->totalShelvesUsedArea, self->wastedAreaPercentage);
}

// PRIVATE: Calculate wasted area on shelves



- (void) calculateWastedArea
{
    float totalShelvesWastedArea = 0.0f;
    
    NSUInteger currentShelfId = 0;
    NSMutableArray *shelfUsedArea = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < [self->shelvesHeight count]; i++)
    {
        [shelfUsedArea addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    self->totalShelvesUsedArea = 0.0f;
    self->wastedArea = 0.0f;
    self->wastedAreaPercentage = 0.0f;
    
    for (NSMutableArray *positionAndRectangle in self->rectanglesPositionsOnShelves)
    {
        NSUInteger rectangleShelf = [[positionAndRectangle objectAtIndex:0] intValue];
        NSUInteger originalRectangleIndex = [[positionAndRectangle objectAtIndex:1] intValue];
        
        if (rectangleShelf == currentShelfId)
        {
            float currentShelfUsedArea = [[shelfUsedArea objectAtIndex:rectangleShelf] floatValue];
            CGRect currentRectangle = [[self->rectangles objectAtIndex:originalRectangleIndex] CGRectValue];
            
            currentShelfUsedArea += currentRectangle.size.height * currentRectangle.size.width;
            [shelfUsedArea replaceObjectAtIndex:rectangleShelf withObject:[NSNumber numberWithFloat:currentShelfUsedArea]];
        }
        else
        {
            currentShelfId += 1;
            
            float currentShelfUsedArea = [[shelfUsedArea objectAtIndex:rectangleShelf] floatValue];
            CGRect currentRectangle = [[self->rectangles objectAtIndex:originalRectangleIndex] CGRectValue];
            
            currentShelfUsedArea += currentRectangle.size.height * currentRectangle.size.width;
            [shelfUsedArea replaceObjectAtIndex:rectangleShelf withObject:[NSNumber numberWithFloat:currentShelfUsedArea]];
        }
    }
    
    for (NSUInteger i = 0; i < [shelfUsedArea count]; i++)
    {
        float currentShelfUsedArea = [[shelfUsedArea objectAtIndex:i] floatValue];
        totalShelvesWastedArea += ([[self->shelvesHeight objectAtIndex:i] floatValue] * self->storageWidth) - currentShelfUsedArea;
    }
    
    for (NSNumber *shelfHeight in self->shelvesHeight)
    {
        self->totalShelvesUsedArea += [shelfHeight floatValue] * self->storageWidth;
    }
    
    self->wastedArea = totalShelvesWastedArea;
    self->wastedAreaPercentage = totalShelvesWastedArea / self->totalShelvesUsedArea * 100.0f;
}

// PRIVATE: Sorting method
NSComparisonResult customCompareFunctionDecr(NSArray* first, NSArray* second, void* context)
{
    id firstValue = [first objectAtIndex:0];
    id secondValue = [second objectAtIndex:0];
    return [secondValue compare:firstValue];
}

// PRIVATE: Recursive method which generates permutations with usage of backstepping algorithm
//          and calculates number of used bins with usage of FF
- (void) permutationArray2D:(int *)array 
          initialPosition:(int)position 
              sizeOfArray:(int)size 
               givenItems:(NSMutableArray *)givenRectangles
{
    
    if (position == size - 1)
        
    {
        NSMutableArray *newRectanglesPermutation = [NSMutableArray new];
        self->permutationCount += 1;
        
        for (NSUInteger i = 0; i < size; ++i)
        {
            // Generating items array based on indexes array
            [newRectanglesPermutation addObject:[givenRectangles objectAtIndex:array[i]]];
        }
        
        // Now we need to check for current item order how many bins we need
        NSUInteger shelfNumber = [self shelfFirstFitAlgorithm2DForGivenRectangles:newRectanglesPermutation];
        
        // Locate through all permutations best item combination and save it
        float currentWidthUsagePercentage = [self shelvesWidthUsagePercentage];
        
        if (shelfNumber <= self->bestShelfNumber && currentWidthUsagePercentage > self->bestWidthUsagePercentage)
        {
            [self->bestShelvesHeight removeAllObjects];
            [self->bestShelvesUsedWidth removeAllObjects];
            [self->bestRectangleCombination removeAllObjects];
            
            self->bestShelfNumber = shelfNumber;
            [self->bestShelvesHeight addObjectsFromArray:self->shelvesHeight];
            [self->bestShelvesUsedWidth addObjectsFromArray:self->currentlyUsedShelfWidth];
            [self->bestRectangleCombination addObjectsFromArray:newRectanglesPermutation];
            
            self->bestWidthUsagePercentage = currentWidthUsagePercentage;
        }

    }
    else
    {
        for (int i = position; i < size; i++)
        {
            swap2D(&array[position], &array[i]);
            
            [self permutationArray2D:array 
                   initialPosition:position+1 
                       sizeOfArray:size 
                        givenItems:givenRectangles];
            
            swap2D(&array[position], &array[i]);
        }
    }
}

// PRIVATE: Used for permutation generation
void swap2D(int *first, int *second)
{
    int temp = *first;
    *first = *second;
    *second = temp;
}

// PRIVATE: Calculate current shelves width usage in % in order to help
//          detail search algorithm to locate the best rectangle combination
- (float) shelvesWidthUsagePercentage
{
    float usedShelvesWidth = 0.0f;
    float totalShelvesWidth = [self->shelvesHeight count] * self->storageWidth;
    
    // Calculate total used width on all shelves
    for (NSNumber *usedWidth in self->currentlyUsedShelfWidth)
    {
        usedShelvesWidth += [usedWidth floatValue];
    }
    
    return usedShelvesWidth / totalShelvesWidth;
}

// PRIVATE: Find best fitting bin for given item
// RETURNS: Best fitting bin index
- (NSInteger) getIndexOfBestFitBin:(CGRect)newRectangle 
                       shouldRotate:(BOOL *)rotation;
{
    NSInteger index = -1;
    float currentFilledShelfWidth = (float)INT_MAX;
    float fittingShelfHeight = (float)INT_MAX;
    
    // Check if there's any open shelf
    if (0 == [self->shelvesHeight count])
    {
        // Place rectangle so that shorter side is height (rotate it if needed)
        // 0 - width is smaller | 1 - height is smaller
        NSUInteger smallerSide = (newRectangle.size.width < newRectangle.size.height ? 0 : 1);
        
        if (0 == smallerSide)
        {
            *rotation = YES;
        }
        else
        {
            *rotation = NO;
        }
        
        index = -1;
    }
    else
    {
        BOOL foundFittingShelf = NO;
        // 0 - width is smaller | 1 - height is smaller
        NSUInteger smallerSide = (newRectangle.size.width < newRectangle.size.height ? 0 : 1);
        
        // Iterate through each shelf
        for (NSUInteger i = 0; i < [self->shelvesHeight count]; i++)
        {
            float currentShelfHeight = [[self->shelvesHeight objectAtIndex:i] floatValue];
            float currentShelfWidth = [[self->currentlyUsedShelfWidth objectAtIndex:i] floatValue];
            
            // Check if current rectangle's width or height fitts current shelf
            if (newRectangle.size.height <= currentShelfHeight || newRectangle.size.width <= currentShelfHeight)
            {
                if (0 == smallerSide)
                {
                    if (newRectangle.size.height <= currentShelfHeight)
                    {
                        if (currentShelfWidth + newRectangle.size.width < currentFilledShelfWidth && currentShelfWidth + newRectangle.size.width <= self->storageWidth)
                        {
                            // If there are two shelves with same width, place rectangle on shelf which
                            // has closer height value to new rectangle
                            if (currentShelfHeight - newRectangle.size.height < fittingShelfHeight)
                            {
                                currentFilledShelfWidth = currentShelfWidth + newRectangle.size.width;
                                index = i;
                                
                                *rotation = NO;
                                foundFittingShelf = YES;
                                
                                fittingShelfHeight = currentShelfHeight - newRectangle.size.height;
                            }
                        }
                    }
                    else
                    {
                        if (currentShelfWidth + newRectangle.size.height < currentFilledShelfWidth && currentShelfWidth + newRectangle.size.height <= self->storageWidth)
                        {
                            // If there are two shelves with same width, place rectangle on shelf which
                            // has closer height value to new rectangle
                            if (currentShelfHeight - newRectangle.size.width < fittingShelfHeight)
                            {
                                currentFilledShelfWidth = currentShelfWidth + newRectangle.size.height;
                                index = i;
                                
                                *rotation = YES;
                                foundFittingShelf = YES;
                                
                                fittingShelfHeight = currentShelfHeight - newRectangle.size.width;
                            }
                        }
                    }
                }
                else
                {
                    if (newRectangle.size.width <= currentShelfHeight)
                    {
                        if (currentShelfWidth + newRectangle.size.height < currentFilledShelfWidth && currentShelfWidth + newRectangle.size.height <= self->storageWidth)
                        {
                            // If there are two shelves with same width, place rectangle on shelf which
                            // has closer height value to new rectangle
                            if (currentShelfHeight - newRectangle.size.width < fittingShelfHeight)
                            {
                                currentFilledShelfWidth = currentShelfWidth + newRectangle.size.height;
                                index = i;
                                
                                *rotation = YES;
                                foundFittingShelf = YES;
                                
                                fittingShelfHeight = currentShelfHeight - newRectangle.size.width;
                            }
                        }
                    }
                    else
                    {
                        if (currentShelfWidth + newRectangle.size.width < currentFilledShelfWidth && currentShelfWidth + newRectangle.size.width <= self->storageWidth)
                        {
                            // If there are two shelves with same width, place rectangle on shelf which
                            // has closer height value to new rectangle
                            if (currentShelfHeight - newRectangle.size.height < fittingShelfHeight)
                            {
                                currentFilledShelfWidth = currentShelfWidth + newRectangle.size.width;
                                index = i;
                                
                                *rotation = NO;
                                foundFittingShelf = YES;
                                
                                fittingShelfHeight = currentShelfHeight - newRectangle.size.height;
                            }
                        }
                    }
                }
            }
        }
        
        if (NO == foundFittingShelf)
        {
            // Create new shelf
            if (0 == smallerSide)
            {
                *rotation = YES;
            }
            else
            {
                *rotation = NO;
            }
            
            index = -1;
        }
    }
    
    return index;
}

// PRIVATE: Find worst fitting bin for given item
// RETURNS: Worst fitting bin index
- (NSInteger) getIndexOfWorstFitBin:(CGRect)newRectangle 
                      shouldRotate:(BOOL *)rotation;
{
    NSInteger index = -1;
    float currentFilledShelfWidth = 0.0f;
    float fittingShelfHeight = (float)INT_MAX;
    
    // Check if there's any open shelf
    if (0 == [self->shelvesHeight count])
    {
        // Place rectangle so that shorter side is height (rotate it if needed)
        // 0 - width is smaller | 1 - height is smaller
        NSUInteger smallerSide = (newRectangle.size.width < newRectangle.size.height ? 0 : 1);
        
        if (0 == smallerSide)
        {
            *rotation = YES;
        }
        else
        {
            *rotation = NO;
        }
        
        index = -1;
    }
    else
    {
        BOOL foundFittingShelf = NO;
        // 0 - width is smaller | 1 - height is smaller
        NSUInteger smallerSide = (newRectangle.size.width < newRectangle.size.height ? 0 : 1);
        
        // Iterate through each shelf
        for (NSUInteger i = 0; i < [self->shelvesHeight count]; i++)
        {
            float currentShelfHeight = [[self->shelvesHeight objectAtIndex:i] floatValue];
            float currentShelfWidth = [[self->currentlyUsedShelfWidth objectAtIndex:i] floatValue];
            
            // Check if current rectangle's width or height fitts current shelf
            if (newRectangle.size.height <= currentShelfHeight || newRectangle.size.width <= currentShelfHeight)
            {
                if (0 == smallerSide)
                {
                    if (newRectangle.size.height <= currentShelfHeight)
                    {
                        if (currentShelfWidth + newRectangle.size.width > currentFilledShelfWidth && currentShelfWidth + newRectangle.size.width <= self->storageWidth)
                        {
                            // If there are two shelves with same width, place rectangle on shelf which
                            // has closer height value to new rectangle
                            if (currentShelfHeight - newRectangle.size.height < fittingShelfHeight)
                            {
                                currentFilledShelfWidth = currentShelfWidth + newRectangle.size.width;
                                index = i;
                                
                                *rotation = NO;
                                foundFittingShelf = YES;
                                
                                fittingShelfHeight = currentShelfHeight - newRectangle.size.height;
                            }
                        }
                    }
                    else
                    {
                        if (currentShelfWidth + newRectangle.size.height > currentFilledShelfWidth && currentShelfWidth + newRectangle.size.height <= self->storageWidth)
                        {
                            // If there are two shelves with same width, place rectangle on shelf which
                            // has closer height value to new rectangle
                            if (currentShelfHeight - newRectangle.size.width < fittingShelfHeight)
                            {
                                currentFilledShelfWidth = currentShelfWidth + newRectangle.size.height;
                                index = i;
                                
                                *rotation = YES;
                                foundFittingShelf = YES;
                                
                                fittingShelfHeight = currentShelfHeight - newRectangle.size.width;
                            }
                        }
                    }
                }
                else
                {
                    if (newRectangle.size.width <= currentShelfHeight)
                    {
                        if (currentShelfWidth + newRectangle.size.height > currentFilledShelfWidth && currentShelfWidth + newRectangle.size.height <= self->storageWidth)
                        {
                            // If there are two shelves with same width, place rectangle on shelf which
                            // has closer height value to new rectangle
                            if (currentShelfHeight - newRectangle.size.width < fittingShelfHeight)
                            {
                                currentFilledShelfWidth = currentShelfWidth + newRectangle.size.height;
                                index = i;
                                
                                *rotation = YES;
                                foundFittingShelf = YES;
                                
                                fittingShelfHeight = currentShelfHeight - newRectangle.size.width;
                            }
                        }
                    }
                    else
                    {
                        if (currentShelfWidth + newRectangle.size.width > currentFilledShelfWidth && currentShelfWidth + newRectangle.size.width <= self->storageWidth)
                        {
                            // If there are two shelves with same width, place rectangle on shelf which
                            // has closer height value to new rectangle
                            if (currentShelfHeight - newRectangle.size.height < fittingShelfHeight)
                            {
                                currentFilledShelfWidth = currentShelfWidth + newRectangle.size.width;
                                index = i;
                                
                                *rotation = NO;
                                foundFittingShelf = YES;
                                
                                fittingShelfHeight = currentShelfHeight - newRectangle.size.height;
                            }
                        }
                    }
                }
            }
        }
        
        if (NO == foundFittingShelf)
        {
            // Create new shelf
            if (0 == smallerSide)
            {
                *rotation = YES;
            }
            else
            {
                *rotation = NO;
            }
            
            index = -1;
        }
    }
    
    return index;
}

@end
