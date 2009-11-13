
#import <UXKit/UXThumbsTableViewCell.h>
#import <UXKit/UXThumbView.h>
#import <UXKit/UXPhotoSource.h>

static CGFloat kSpacing				= 4;
static CGFloat kDefaultThumbSize	= 75;

@implementation UXThumbsTableViewCell

	@synthesize delegate	= _delegate;
	@synthesize photo		= _photo;
	@synthesize thumbSize	= _thumbSize;
	@synthesize thumbOrigin = _thumbOrigin;
	@synthesize columnCount = _columnCount;

	#pragma mark SPI

	-(void) assignPhotoAtIndex:(int)index toView:(UXThumbView *)thumbView {
		id <UXPhoto> photo	= [_photo.photoSource photoAtIndex:index];
		if (photo) {
			thumbView.thumbURL	= [photo URLForVersion:UXPhotoVersionThumbnail];
			thumbView.hidden	= NO;
		}
		else {
			thumbView.thumbURL	= nil;
			thumbView.hidden	= YES;
		}
	}

	-(void) thumbTouched:(UXThumbView *)thumbView {
		NSUInteger thumbViewIndex	= [_thumbViews indexOfObject:thumbView];
		NSInteger index				= _photo.index + thumbViewIndex;
		id <UXPhoto> photo		= [_photo.photoSource photoAtIndex:index];
		[_delegate thumbsTableViewCell:self didSelectPhoto:photo];
	}

	-(void) layoutThumbViews {
		CGRect thumbFrame = CGRectMake(self.thumbOrigin.x, self.thumbOrigin.y, self.thumbSize, self.thumbSize);
		for (UXThumbView *thumbView in _thumbViews) {
			thumbView.frame		= thumbFrame;
			thumbFrame.origin.x += kSpacing + self.thumbSize;
		}
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			_photo			= nil;
			_delegate		= nil;
			_thumbViews		= [[NSMutableArray alloc] init];
			_thumbSize		= kDefaultThumbSize;
			_thumbOrigin	= CGPointMake(kSpacing, 0);
			_columnCount	= 0;

			self.accessoryType	= UITableViewCellAccessoryNone;
			self.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_photo);
		UX_SAFE_RELEASE(_thumbViews);
		[super dealloc];
	}

	
	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		[self layoutThumbViews];
	}

	
	#pragma mark UXTableViewCell

	-(id) object {
		return _photo;
	}

	-(void) setObject:(id)object {
		[self setPhoto:object];
	}

	
	#pragma mark API

	-(void) setThumbSize:(CGFloat)aThumbSize {
		_thumbSize = aThumbSize;
		[self setNeedsLayout];
	}

	-(void) setThumbOrigin:(CGPoint)aThumbOrigin {
		_thumbOrigin = aThumbOrigin;
		[self setNeedsLayout];
	}

	-(void) setColumnCount:(NSInteger)aColumnCount {
		if (_columnCount != aColumnCount) {
			if (aColumnCount > _columnCount) {
				for (UXThumbView *thumbView in _thumbViews) {
					[thumbView removeFromSuperview];
				}
				[_thumbViews removeAllObjects];
			}
			
			_columnCount = aColumnCount;
			
			for (NSInteger i = _thumbViews.count; i < _columnCount; ++i) {
				UXThumbView *thumbView = [[[UXThumbView alloc] init] autorelease];
				[thumbView addTarget:self action:@selector(thumbTouched:) forControlEvents:UIControlEventTouchUpInside];
				[self.contentView addSubview:thumbView];
				[_thumbViews addObject:thumbView];
				if (_photo) {
					[self assignPhotoAtIndex:_photo.index + i toView:thumbView];
				}
			}
		}
	}

	-(void) setPhoto:(id <UXPhoto>)photo {
		if (_photo != photo) {
			[_photo release];
			_photo = [photo retain];
			
			if (!_photo) {
				for (UXThumbView *thumbView in _thumbViews) {
					thumbView.thumbURL = nil;
				}
				return;
			}
			
			NSInteger i = 0;
			for (UXThumbView *thumbView in _thumbViews) {
				[self assignPhotoAtIndex:_photo.index + i toView:thumbView];
				++i;
			}
		}
	}

	-(void) suspendLoading:(BOOL)suspended {
		for (UXThumbView *thumbView in _thumbViews) {
			[thumbView suspendLoadingImages:suspended];
		}
	}

@end
