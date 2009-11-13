
#import "ScrollViewTestController.h"
#import "MockPhotoSource.h"

@implementation ScrollViewTestController

	-(void) dealloc {
		_scrollView.delegate	= nil;
		_scrollView.dataSource	= nil;
		UX_SAFE_RELEASE(_scrollView);
		UX_SAFE_RELEASE(_colors);
		[super dealloc];
	}

	-(void) loadView {
		CGRect appFrame				= [UIScreen mainScreen].applicationFrame;
		CGRect frame				= CGRectMake(0, 0, appFrame.size.width, appFrame.size.height - 44);
		self.view					= [[[UIView alloc] initWithFrame:frame] autorelease];
		
		_scrollView					= [[UXScrollView alloc] initWithFrame:self.view.bounds];
		_scrollView.dataSource		= self;
		_scrollView.backgroundColor = [UIColor whiteColor];
		[self.view addSubview:_scrollView];
		
		_colors = [[NSArray arrayWithObjects:
					[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1],
					[UIColor blueColor],
					[UIColor redColor],
					[UIColor yellowColor],
					[UIColor orangeColor],
					[UIColor cyanColor],
					[UIColor purpleColor],
					[UIColor brownColor],
					[UIColor magentaColor],
					[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1], nil] retain];
	}


	#pragma mark UXScrollViewDataSource

	-(NSInteger) numberOfPagesInScrollView:(UXScrollView *)scrollView {
		return _colors.count;
	}

	-(UIView *) scrollView:(UXScrollView *)scrollView pageAtIndex:(NSInteger)pageIndex {
		UXView *pageView = nil;
		if (!pageView) {
			pageView						= [[[UXView alloc] initWithFrame:CGRectZero] autorelease];
			pageView.backgroundColor		= [UIColor clearColor];
			pageView.userInteractionEnabled = NO;
			//pageView.contentMode = UIViewContentModeLeft;
		}
		
		pageView.style = [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:30] 
												 next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(10, 10, 10, 10) 
												 next:[UXLinearGradientFillStyle styleWithColor1:[_colors objectAtIndex:pageIndex] color2:[UIColor whiteColor] 
												 next:[UXSolidBorderStyle styleWithColor:[UIColor blueColor] width:1 
												 next:nil]]]];
		return pageView;
	}

	-(CGSize) scrollView:(UXScrollView *)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex {
		return CGSizeMake(320, 416);
	}

@end
