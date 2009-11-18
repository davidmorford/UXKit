
#import <UXKit/UXView.h>
#import <UXKit/UXStyle.h>
#import <UXKit/UXLayout.h>

@implementation UXView

	@synthesize style = _style;
	@synthesize layout = _layout;

	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_style	= nil;
			_layout = nil;
			self.contentMode = UIViewContentModeRedraw;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_style);
		UX_SAFE_RELEASE(_layout);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) drawRect:(CGRect)rect {
		UXStyle *style = self.style;
		if (style) {
			UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
			context.delegate = self;
			context.frame = self.bounds;
			context.contentFrame = context.frame;
			
			[style draw:context];
			if (!context.didDrawContent) {
				[self drawContent:self.bounds];
			}
		}
		else {
			[self drawContent:self.bounds];
		}
	}

	-(void) layoutSubviews {
		UXLayout *layout = self.layout;
		if (layout) {
			[layout layoutSubviews:self.subviews forView:self];
		}
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		UXStyleContext *context = [[[UXStyleContext alloc] init] autorelease];
		context.delegate = self;
		context.font = nil;
		return [_style addToSize:CGSizeZero context:context];
	}


	#pragma mark API

	-(void) setStyle:(UXStyle *)style {
		if (style != _style) {
			[_style release];
			_style = [style retain];
			
			[self setNeedsDisplay];
		}
	}

	-(void) drawContent:(CGRect)rect {
	
	}

@end

#pragma mark -

@interface UXKVOView ()
	@property (nonatomic, readwrite, assign) BOOL isObservingForDisplay;
	@property (nonatomic, readwrite, assign) BOOL isObservingForLayout;
	-(void) observeForDisplay;
	-(void) stopObservingForDisplay;
@end

#pragma mark -

@implementation UXKVOView
	
	@synthesize isObservingForDisplay = observingForDisplay;
	@synthesize isObservingForLayout  = observingForLayout;

	#pragma mark UIView

	-(id) initWithFrame:(CGRect)frame {
		self = [super initWithFrame:frame];
		if (self) {
			[self observeForDisplay];
		}
		return self;
	}


	#pragma mark Display Keys

	-(NSArray *) keysAffectingDisplay {
		return [NSArray array];
	}

	-(void) observeForDisplay {
		if (self.isObservingForDisplay) {
			return;
		}
		self.isObservingForDisplay = TRUE;
		NSArray * keys = [self keysAffectingDisplay];
		for (NSString * aKey in keys) {
			[self addObserver:self forKeyPath:aKey options:NSKeyValueObservingOptionNew context:(void *)NSStringFromClass([self class])];
		}
	}

	-(void) stopObservingForDisplay {
		if (!self.isObservingForDisplay) {
			return;
		}
		self.isObservingForDisplay	= FALSE;
		NSArray * keys				= [self keysAffectingDisplay];
		for (NSString *aKey in keys) {
			[self removeObserver:self forKeyPath:aKey];
		}
	}


	#pragma mark Layout Keys

	-(NSArray *) keysAffectingLayout {
		return [NSArray array];
	}

	-(void) observeForLayout {
		if (self.isObservingForDisplay) {
			return;
		}
		self.isObservingForLayout = TRUE;
		NSArray * keys = [self keysAffectingLayout];
		for (NSString * aKey in keys) {
			[self addObserver:self forKeyPath:aKey options:NSKeyValueObservingOptionNew context:(void *)NSStringFromClass([self class])];
		}
	}

	-(void) stopObservingForLayout {
		if (!self.isObservingForLayout) {
			return;
		}
		self.isObservingForLayout	= FALSE;
		NSArray * keys				= [self keysAffectingLayout];
		for (NSString *aKey in keys) {
			[self removeObserver:self forKeyPath:aKey];
		}
	}


	#pragma mark Key-Value Observing

	-(void) observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary *)aChange context:(void *)aContext {
		if (anObject == self && NULL != aContext && [(NSString *)aContext isEqualToString:NSStringFromClass([self class])]) {
			[self setNeedsDisplay];
		}
	}

	-(void) dealloc {
		[self stopObservingForDisplay];
		[self stopObservingForLayout];
		[super dealloc];
	}

@end
