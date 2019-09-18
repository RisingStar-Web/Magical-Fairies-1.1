//
//  Puzzles.m
//  Puzzle
//
//  Created by flashore on 11-12-22.
//  Copyright (c) 2011 flashore. All rights reserved.
//

#import "Puzzles.h"

@implementation Puzzles

@synthesize puzzleArr, buttonsArr, difficultyArr, backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        srand(time(NULL));
        self.userInteractionEnabled = YES;
        
        //size and position of the board where puzzles are supposed to be dropped
        boardSize = CGSizeMake(525, 700); 
        boardPosition = CGPointMake(160, 245);
        
        //size and position of the stack where puzzles appear at the start of the game 
        stackSize = CGSizeMake(638, 200);
        stackPosition = CGPointMake(84, 66);
        
        backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(boardPosition.x, boardPosition.y, boardSize.width, boardSize.height)];
        backgroundImage.alpha = 0.2;
        
        [self addSubview:backgroundImage];
        
        [self createButtons];
        [self selectLevel:0];
        [self selectPicture:0];
        [self createBoard];
    }
    return self;
}

/**
 * create picture buttons 
 * and create dificulty buttons
 */
-(void)createButtons {
    UIButton *but;
    UIImage *img1, *img2;
    
    buttonsArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<5; i++) {
        img1 = [UIImage imageNamed:[NSString stringWithFormat:@"gfx/thumbs/thumb%ddown.jpg",i+1]];
        img2 = [UIImage imageNamed:[NSString stringWithFormat:@"gfx/thumbs/thumb%dup.jpg",i+1]];
        
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = i;
        
        but.frame = CGRectMake(stackPosition.x, stackPosition.y + stackSize.height + 110*i, img1.size.width, img1.size.height);
        [but setImage:img1 forState:UIControlStateNormal];
        [but setImage:img2 forState:UIControlStateDisabled];
        [but addTarget:self action:@selector(butPushed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        [buttonsArr addObject:but];
    }
    
    //difficulty buttons
    difficultyArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<3; i++) {
        img1 = [UIImage imageNamed:[NSString stringWithFormat:@"gfx/levels/level%d_1.png",i+1]];
        img2 = [UIImage imageNamed:[NSString stringWithFormat:@"gfx/levels/level%d_2.png",i+1]];
        
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = i+100;
        
        but.frame = CGRectMake(83, 836 + 30*i, img1.size.width, img1.size.height);
        [but setImage:img1 forState:UIControlStateNormal];
        [but setImage:img2 forState:UIControlStateDisabled];
        [but addTarget:self action:@selector(butLevelPushed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        [difficultyArr addObject:but];
    }    
}

-(void) butLevelPushed:(id)sender {
    UIButton *but = sender;
    [self selectLevel:but.tag-100];
    [self createBoard];
}

/**
 * selecting level, each level has different number of puzzles
 */
-(void)selectLevel:(int)level {
    switch (level) {
        case 0:
            //12 pieces
            rowsNum = 4;
            colsNum = 3;
            break;
        case 1:
            //25 pieces
            rowsNum = 5;
            colsNum = 5;
            break;
        case 2: 
            //49 pieces
            rowsNum = 7;
            colsNum = 7;
        default:
            break;
    }
    selectedLevel = level;
    
    UIButton *but;
    for (int i = 0; i<3; i++) {
        but = [difficultyArr objectAtIndex:i];
        if (but.tag == selectedLevel + 100) {
            but.enabled = NO; 
            but.alpha = 0.5;
        } else {
            but.enabled = YES;   
            but.alpha = 1;
        }
    }
}

-(void) butPushed:(id)sender {
    
    UIButton *but = sender;
    [self selectPicture:but.tag];
    
}

/**
 * select one of five pictures to play
 */
-(void)selectPicture:(int)pic {
    UIButton *but;
    selectedPicture = pic;
    for (int i = 0; i<5; i++) {
        but = [buttonsArr objectAtIndex:i];
        if (but.tag == selectedPicture) {
            but.enabled = NO; 
            but.alpha = 0.5;
        } else {
            but.enabled = YES;   
            but.alpha = 1;
        }
    }
    [self createBoard];
}

/** 
 * clear old board
 */
-(void)clearBoard {
    if (puzzleArr != nil) {
        UIImageView *item;
        if ([puzzleArr count] > 0) {
            for (int i = 0; i<[puzzleArr count]; i++) {
                item = [puzzleArr objectAtIndex:i];
                [item removeFromSuperview];
                item = nil;
            }
        }
        puzzleArr = nil;
    }
    puzzleArr = [[NSMutableArray alloc] init];
}

/**
 * create new board
 */
-(void)createBoard {
    
    [self clearBoard];
    
    UIImageView *item;
    UIImageView *itemFrame;
    
    UIImage *sourceImg = [UIImage imageNamed:[NSString stringWithFormat:@"gfx/images/%d.jpg",selectedPicture+1]];
    UIImage *frameImg = [UIImage imageNamed:@"gfx/images/frame.png"];
    
    [backgroundImage setImage:sourceImg];
    
    CGPoint offset = boardPosition;
    
    width = boardSize.width / colsNum;
    height = boardSize.height / rowsNum;
    
    for (int x = 0; x<colsNum; x++) {
        for (int y = 0; y<rowsNum; y++) {
            int ranX = (int)stackPosition.x + arc4random() % ((int)stackSize.width - (int)boardSize.width/colsNum);
            int ranY = (int)stackPosition.y + arc4random() % ((int)stackSize.height - (int)boardSize.height/rowsNum);  
            //item = [[UIImageView alloc] initWithFrame:CGRectMake(offset.x + width * x, offset.y + height * y, width, height)];
            item = [[UIImageView alloc] initWithFrame:CGRectMake(ranX, ranY, width, height)];
            CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImg.CGImage, CGRectMake(width * x, height * y, width, height));
            item.image = [UIImage imageWithCGImage:imageRef];
            
            item.tag = 1000000 * (offset.x + width * x) + (offset.y + height * y);
            
            itemFrame = [[UIImageView alloc] initWithImage:frameImg];
            if (selectedLevel == 0) {
                itemFrame.frame = CGRectMake(-7, -7, width/0.88, height/0.88);
            } else if (selectedLevel == 1) {
                itemFrame.frame = CGRectMake(-5, -6, width/0.88, height/0.88);
            } else if (selectedLevel == 2) {
                itemFrame.frame = CGRectMake(-3, -5, width/0.88, height/0.88);
            }
            [item addSubview:itemFrame];
            
            item.userInteractionEnabled = YES;
            
            [self addSubview:item];
            [puzzleArr addObject:item];
        }
    }
     
}

/**
 * bring the puzzle to the starting position
 */
-(void)resetItem:(UIImageView *)item {
    item.frame = CGRectMake(startPosition.x, startPosition.y, item.frame.size.width, item.frame.size.height);
}

#pragma mark touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view.tag < 1000000)
        return;
    startPosition = CGPointMake(touch.view.frame.origin.x, touch.view.frame.origin.y);
    [self bringSubviewToFront:touch.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view.tag < 1000000)
        return;
    CGPoint location = [touch locationInView:self];
    touch.view.center = location;
}

/**
 * checking position of dropped puzzle
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view.tag < 1000000)
        return;
    
    CGPoint newPosition = CGPointMake(touch.view.frame.origin.x, touch.view.frame.origin.y);
    
    //if put on stack, don't do anything
    if (newPosition.x > stackPosition.x && newPosition.x < stackPosition.x + stackSize.width - width &&  newPosition.y > stackPosition.y && newPosition.y < stackPosition.y+stackSize.height - height) {
        return;
    }

    //if dropped out of board then reset
    if (newPosition.x < boardPosition.x - width/2 || newPosition.x > boardPosition.x + boardSize.width - width/2 
        || newPosition.y <boardPosition.y - height/2 || newPosition.y > boardPosition.y + boardSize.height - height/2) {
        [self resetItem:(UIImageView*)touch.view];    
    }
    
    //snap to the nearest block
    CGPoint offset = boardPosition;
    float x, y;
    
    x = round((newPosition.x - offset.x) / width);
    y = round((newPosition.y - offset.y) / height);
    touch.view.frame = CGRectMake(offset.x + width * x, offset.y + height * y, touch.view.frame.size.width, touch.view.frame.size.height);
    [self checkResult];
}

/**
 * checking result
 * if all is ok, then hide frames over the pieces
 * and disable user interaction
 */
-(void)checkResult {
    UIImageView *item;
    UIImageView *itemFrame;
    int value;
    BOOL allOK = YES;
    for (int i = 0; i<[puzzleArr count]; i++) {
        item = (UIImageView*)[puzzleArr objectAtIndex:i];
        value = 1000000 * item.frame.origin.x + item.frame.origin.y;
        if (value != item.tag) {
            allOK = NO;
            break;
        }
    }
    if (allOK) {
        NSLog(@"ALL OK!!");
        for (int i = 0; i<[puzzleArr count]; i++) {
            item = (UIImageView*)[puzzleArr objectAtIndex:i];
            itemFrame = (UIImageView*)[[item subviews] objectAtIndex:0];
            itemFrame.hidden = YES;
            item.userInteractionEnabled = NO;
        }
    }
}

@end
