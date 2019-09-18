//
//  ViewController.m
//  Puzzle
//
//  Created by flashore on 11-12-22.
//  Copyright (c) 2011 flashore. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize puzzles;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)loadView {
    [super loadView];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];	
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [background setImage:[UIImage imageNamed:@"gfx/background/background.jpg"]];
    
    //create puzzles, the main class 
    puzzles = [[Puzzles alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:background];
    [self.view addSubview:puzzles];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
@end
