
#import "SearchPhotosViewController.h"
#import "SearchResultsPhotoSource.h"
#import "SearchResultsModel.h"

@implementation SearchPhotosViewController

	-(id) init {
		if ((self = [super init])) {
			self.title	= @"Photo example";
			photoSource = [[SearchResultsPhotoSource alloc] initWithModel:CreateSearchModelWithCurrentSettings()];
		}
		return self;
	}

	-(void) doSearch {
		/*
		NSLog(@"Searching for %@", queryField.text);
		*/
		[queryField resignFirstResponder];
		
		/*
		Configure the photo source with the user's search terms. NOTE: I have to 
		explicitly cast the photoSource to the SearchResultsModel protocol because 
		otherwise the compiler will issue a warning (because the compiler doesn't know 
		that the photoSource forwards to a SearchResultsModel at runtime)
		*/
		[(id <SearchResultsModel>) photoSource setSearchTerms:[queryField text]];
		
		// Load the new data
		[photoSource load:UXURLRequestCachePolicyDefault more:NO];
		
		// Display the updated photoSource.
		UXThumbsViewController *thumbs = [[UXThumbsViewController alloc] init];
		[thumbs setPhotoSource:photoSource];
		
		/*
		Ugly hack: the UXModel system does not expect that your UXPhotoSource implementation
		is actually forwarding to another object in order to conform to the UXModel aspect
		of the UXPhotoSource protocol. So I have to ensure that the UXModelViewController's
		notion of what its model is matches the object that it will receive
		via the UXModelDelegate messages.
		*/
		thumbs.model = [photoSource underlyingModel];
		[self.navigationController pushViewController:thumbs animated:YES];
		[thumbs release];
	}

	-(void) loadView {
		[super loadView];
		
		self.view.backgroundColor			= [UIColor colorWithWhite:0.9f alpha:1.f];
		
		queryField							= [[UITextField alloc] initWithFrame:CGRectMake(20.f, 20.f, 280.f, 30.f)];
		queryField.placeholder				= @"Image Search";
		queryField.autocorrectionType		= NO;
		queryField.autocapitalizationType	= NO;
		queryField.clearsOnBeginEditing		= YES;
		queryField.borderStyle				= UITextBorderStyleRoundedRect;
		[self.view addSubview:queryField];
		
		UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[searchButton setTitle:@"Search" forState:UIControlStateNormal];
		[searchButton setFrame:CGRectMake(20.f, 70.f, 280.f, 44.f)];
		[searchButton addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:searchButton];
	}

	-(void) dealloc {
		[queryField release];
		[photoSource release];
		[super dealloc];
	}

@end
