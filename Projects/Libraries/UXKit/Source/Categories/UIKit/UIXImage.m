
#import <UXKit/UIXImage.h>

@implementation UIImage (UXTransform)

	-(UIImage *) transformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate {
		CGFloat destW	= width;
		CGFloat destH	= height;
		CGFloat sourceW = width;
		CGFloat sourceH = height;
		if (rotate) {
			if ((self.imageOrientation == UIImageOrientationRight) || (self.imageOrientation == UIImageOrientationLeft)) {
				sourceW = height;
				sourceH = width;
			}
		}
		
		CGImageRef imageRef = self.CGImage;
		CGContextRef bitmap = CGBitmapContextCreate(NULL, destW, destH,
													CGImageGetBitsPerComponent(imageRef),
													4 * destW,
													CGImageGetColorSpace(imageRef),
													CGImageGetBitmapInfo(imageRef));
		
		if (rotate) {
			if (self.imageOrientation == UIImageOrientationDown) {
				CGContextTranslateCTM(bitmap, sourceW, sourceH);
				CGContextRotateCTM(bitmap, 180 * (M_PI / 180));
			}
			else if (self.imageOrientation == UIImageOrientationLeft) {
				CGContextTranslateCTM(bitmap, sourceH, 0);
				CGContextRotateCTM(bitmap, 90 * (M_PI / 180));
			}
			else if (self.imageOrientation == UIImageOrientationRight) {
				CGContextTranslateCTM(bitmap, 0, sourceW);
				CGContextRotateCTM(bitmap, -90 * (M_PI / 180));
			}
		}
		
		CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
		
		CGImageRef ref	= CGBitmapContextCreateImage(bitmap);
		UIImage *result = [UIImage imageWithCGImage:ref];
		CGContextRelease(bitmap);
		CGImageRelease(ref);
		return result;
	}

	-(CGRect) convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
		if ((self.size.width != rect.size.width) || (self.size.height != rect.size.height) ) {
			if (contentMode == UIViewContentModeLeft) {
				return CGRectMake(rect.origin.x,
								  rect.origin.y + floor(rect.size.height / 2 - self.size.height / 2),
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeRight) {
				return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
								  rect.origin.y + floor(rect.size.height / 2 - self.size.height / 2),
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeTop) {
				return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - self.size.width / 2),
								  rect.origin.y,
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeBottom) {
				return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - self.size.width / 2),
								  rect.origin.y + floor(rect.size.height - self.size.height),
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeCenter) {
				return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - self.size.width / 2),
								  rect.origin.y + floor(rect.size.height / 2 - self.size.height / 2),
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeBottomLeft) {
				return CGRectMake(rect.origin.x,
								  rect.origin.y + floor(rect.size.height - self.size.height),
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeBottomRight) {
				return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
								  rect.origin.y + (rect.size.height - self.size.height),
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeTopLeft) {
				return CGRectMake(rect.origin.x,
								  rect.origin.y,
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeTopRight) {
				return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
								  rect.origin.y,
								  self.size.width, 
								  self.size.height);
			}
			else if (contentMode == UIViewContentModeScaleAspectFill) {
				CGSize imageSize = self.size;
				if (imageSize.height < imageSize.width) {
					imageSize.width		= floor((imageSize.width / imageSize.height) * rect.size.height);
					imageSize.height	= rect.size.height;
				}
				else {
					imageSize.height	= floor((imageSize.height / imageSize.width) * rect.size.width);
					imageSize.width		= rect.size.width;
				}
				return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - imageSize.width / 2),
								  rect.origin.y + floor(rect.size.height / 2 - imageSize.height / 2),
								  imageSize.width, 
								  imageSize.height);
			}
			else if (contentMode == UIViewContentModeScaleAspectFit) {
				CGSize imageSize = self.size;
				if (imageSize.height < imageSize.width) {
					imageSize.height	= floor((imageSize.height / imageSize.width) * rect.size.width);
					imageSize.width		= rect.size.width;
				}
				else {
					imageSize.width		= floor((imageSize.width / imageSize.height) * rect.size.height);
					imageSize.height	= rect.size.height;
				}
				return CGRectMake(rect.origin.x + floor(rect.size.width / 2 - imageSize.width / 2),
								  rect.origin.y + floor(rect.size.height / 2 - imageSize.height / 2),
								  imageSize.width, 
								  imageSize.height);
			}
		}
		return rect;
	}

	-(UIImage *) rescaleImageToSize:(CGSize)size {
		CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
		UIGraphicsBeginImageContext(rect.size);
		[self drawInRect:rect];  // scales image to rect
		UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return resImage;
	}

	-(UIImage *) cropImageToRect:(CGRect)cropRect {
		// Begin the drawing (again)
		UIGraphicsBeginImageContext(cropRect.size);
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
		CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
		CGContextScaleCTM(ctx, 1.0, -1.0);
		
		// Draw view into context
		CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
		CGContextDrawImage(ctx, drawRect, self.CGImage);
		
		// Create the new UIImage from the context
		UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
		
		// End the drawing
		UIGraphicsEndImageContext();
		
		return newImage;
	}

	-(CGSize) calculateNewSizeForCroppingBox:(CGSize)croppingBox {
		// Make the shortest side be equivalent to the cropping box.
		CGFloat newHeight, newWidth;
		if (self.size.width < self.size.height) {
			newWidth = croppingBox.width;
			newHeight = (self.size.height / self.size.width) * croppingBox.width;
		}
		else {
			newHeight = croppingBox.height;
			newWidth = (self.size.width / self.size.height) * croppingBox.height;
		}
		
		return CGSizeMake(newWidth, newHeight);
	}

	-(UIImage *) cropCenterAndScaleImageToSize:(CGSize)cropSize {
		UIImage *scaledImage = [self rescaleImageToSize:[self calculateNewSizeForCroppingBox:cropSize]];
		return [scaledImage cropImageToRect:CGRectMake((scaledImage.size.width - cropSize.width) / 2, (scaledImage.size.height - cropSize.height) / 2, cropSize.width, cropSize.height)];
	}

@end

#pragma mark -

@implementation UIImage (UXDrawing)

	-(void) addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
		CGContextBeginPath(context);
		CGContextSaveGState(context);
		
		if (radius == 0) {
			CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
			CGContextAddRect(context, rect);
		}
		else {
			CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
			CGContextScaleCTM(context, radius, radius);
			float fw = CGRectGetWidth(rect) / radius;
			float fh = CGRectGetHeight(rect) / radius;
			
			CGContextMoveToPoint(context, fw, fh / 2);
			CGContextAddArcToPoint(context, fw, fh, fw / 2, fh, 1);
			CGContextAddArcToPoint(context, 0, fh, 0, fh / 2, 1);
			CGContextAddArcToPoint(context, 0, 0, fw / 2, 0, 1);
			CGContextAddArcToPoint(context, fw, 0, fw, fh / 2, 1);
		}
		
		CGContextClosePath(context);
		CGContextRestoreGState(context);
	}	

	-(void) drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode {
		BOOL clip			= NO;
		CGRect originalRect = rect;
		if ((self.size.width != rect.size.width) || (self.size.height != rect.size.height) ) {
			clip = contentMode != UIViewContentModeScaleAspectFill && contentMode != UIViewContentModeScaleAspectFit;
			rect = [self convertRect:rect withContentMode:contentMode];
		}
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		if (clip) {
			CGContextSaveGState(context);
			CGContextAddRect(context, originalRect);
			CGContextClip(context);
		}
		
		[self drawInRect:rect];
		
		if (clip) {
			CGContextRestoreGState(context);
		}
	}

	-(void) drawInRect:(CGRect)rect radius:(CGFloat)radius {
		[self drawInRect:rect radius:radius contentMode:UIViewContentModeScaleToFill];
	}

	-(void) drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSaveGState(context);
		if (radius) {
			[self addRoundedRectToPath:context rect:rect radius:radius];
			CGContextClip(context);
		}
		
		[self drawInRect:rect contentMode:contentMode];
		
		CGContextRestoreGState(context);
	}

	-(void) drawInRect:(CGRect)rect asAlphaMaskForColor:(CGFloat[])color {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(context);
		
		CGContextTranslateCTM(context, 0.0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		rect.origin.y = rect.origin.y * -1;
		
		CGContextClipToMask(context, rect, self.CGImage);
		CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
		CGContextFillRect(context, rect);

		CGContextRestoreGState(context);
	}

	-(void) drawInRect:(CGRect)rect asAlphaMaskForGradient:(CGFloat[])colors {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(context);
		
		CGContextTranslateCTM(context, 0.0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		rect.origin.y = rect.origin.y * -1;
		
		CGContextClipToMask(context, rect, self.CGImage);
		[UIView drawLinearGradientInRect:rect colors:colors];

		CGContextRestoreGState(context);	
	}

@end

#pragma mark -

@implementation UIImage (UXReflection)

	-(UIImage *) addImageReflection:(CGFloat)reflectionFraction {
		int reflectionHeight = self.size.height * reflectionFraction;
		
		// create a 2 bit CGImage containing a gradient that will be used for masking the
		// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
		// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
		CGImageRef gradientMaskImage = NULL;
		
		// gradient is always black-white and the mask must be in the gray colorspace
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
		
		// create the bitmap context
		CGContextRef gradientBitmapContext = CGBitmapContextCreate(nil, 1, reflectionHeight, 8, 0, colorSpace, kCGImageAlphaNone);
		
		// define the start and end grayscale values (with the alpha, even though
		// our bitmap context doesn't support alpha the gradient requires it)
		CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
		
		// create the CGGradient and then release the gray color space
		CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
		CGColorSpaceRelease(colorSpace);
		
		// create the start and end points for the gradient vector (straight down)
		CGPoint gradientStartPoint = CGPointMake(0, reflectionHeight);
		CGPoint gradientEndPoint = CGPointZero;
		
		// draw the gradient into the gray bitmap context
		CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(grayScaleGradient);
		
		// add a black fill with 50% opacity
		CGContextSetGrayFillColor(gradientBitmapContext, 0.0, 0.5);
		CGContextFillRect(gradientBitmapContext, CGRectMake(0, 0, 1, reflectionHeight));
		
		// convert the context into a CGImageRef and release the context
		gradientMaskImage = CGBitmapContextCreateImage(gradientBitmapContext);
		CGContextRelease(gradientBitmapContext);
		
		// create an image by masking the bitmap of the mainView content with the gradient view
		// then release the  pre-masked content bitmap and the gradient bitmap
		CGImageRef reflectionImage = CGImageCreateWithMask(self.CGImage, gradientMaskImage);
		CGImageRelease(gradientMaskImage);
		
		CGSize size = CGSizeMake(self.size.width, self.size.height + reflectionHeight);
		
		UIGraphicsBeginImageContext(size);
		
		[self drawAtPoint:CGPointZero];
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextDrawImage(context, CGRectMake(0, self.size.height, self.size.width, reflectionHeight), reflectionImage);
		
		UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		CGImageRelease(reflectionImage);
		
		return result;
	}

@end
