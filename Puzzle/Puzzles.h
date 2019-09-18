//
//  Puzzles.h
//  Puzzle
//
//  Created by flashore on 11-12-22.
//  Copyright (c) 2011 flashore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Puzzles : UIImageView {
    int colsNum, rowsNum, selectedPicture, selectedLevel;
    CGPoint startPosition, boardPosition, stackPosition;
    float width, height;
    CGSize boardSize, stackSize;
}

-(void) createButtons;
-(void) createBoard;
-(void) clearBoard;
-(void) checkResult;

-(void) selectLevel:(int)level;
-(void) selectPicture:(int)pic;
-(void) resetItem:(UIImageView*)item;   

@property (nonatomic, strong) NSMutableArray *puzzleArr, *buttonsArr, *difficultyArr;
@property (nonatomic, strong) UIImageView *backgroundImage;

@end
