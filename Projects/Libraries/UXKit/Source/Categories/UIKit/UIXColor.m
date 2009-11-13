
#import <UXKit/UIXColor.h>

#pragma mark Color Algorithms

#define MAX3(a, b, c) (a > b ? (a > c ? a : c) : (b > c ? b : c))
#define MIN3(a, b, c) (a < b ? (a < c ? a : c) : (b < c ? b : c))

void
RGBtoHSV(float r, float g, float b, float *h, float *s, float *v) {
	float min, max, delta;
	min		= MIN3(r, g, b);
	max		= MAX3(r, g, b);
	
	// v
	*v		= max;
	delta	= max - min;
	
	if (max != 0) {
		// s
		*s = delta / max;
	}
	else {
		// r = g = b = 0
		// s = 0, v is undefined
		*s = 0;
		*h = -1;
		return;
	}
	if (r == max) {
		// between yellow & magenta
		*h = (g - b) / delta;
	}
	else if ( g == max ) {
		// between cyan & yellow
		*h = 2 + (b - r) / delta;
	}
	else {
		// between magenta & cyan
		*h = 4 + (r - g) / delta;
	}
	
	// degrees
	*h *= 60;
	if (*h < 0) {
		*h += 360;
	}
}

void
HSVtoRGB( float *r, float *g, float *b, float h, float s, float v ) {
	int i;
	float f, p, q, t;
	if ( s == 0 ) {
		// achromatic (grey)
		*r = *g = *b = v;
		return;
	}
	// sector 0 to 5
	h	/= 60;
	i	= floor(h);
	
	// factorial part of h
	f	= h - i;
	p	= v * (1 - s);
	q	= v * (1 - s * f);
	t	= v * (1 - s * (1 - f) );
	
	switch (i) {
		case 0:
			*r = v;
			*g = t;
			*b = p;
			break;
		case 1:
			*r = q;
			*g = v;
			*b = p;
			break;
		case 2:
			*r = p;
			*g = v;
			*b = t;
			break;
		case 3:
			*r = p;
			*g = q;
			*b = v;
			break;
		case 4:
			*r = t;
			*g = p;
			*b = v;
			break;
		default:
			// case 5:
			*r = v;
			*g = p;
			*b = q;
			break;
	}
}

#pragma mark -

@implementation UIColor (UIXColor)

	+(UIColor *) colorWithHue:(CGFloat)h saturation:(CGFloat)s value:(CGFloat)v alpha:(CGFloat)a {
		CGFloat r, g, b;
		HSVtoRGB(&r, &g, &b, h, s, v);
		return [UIColor colorWithRed:r green:g blue:b alpha:a];
	}


	#pragma mark Copying

	-(UIColor *) copyWithAlpha:(CGFloat)newAlpha {
		const CGFloat *rgba = CGColorGetComponents(self.CGColor);
		CGFloat r = rgba[0];
		CGFloat g = rgba[1];
		CGFloat b = rgba[2];
		
		return [[UIColor colorWithRed:r green:g blue:b alpha:newAlpha] retain];
	}


	#pragma mark HSV Values

	-(UIColor *) multiplyHue:(CGFloat)hd saturation:(CGFloat)sd value:(CGFloat)vd {
		const CGFloat *rgba = CGColorGetComponents(self.CGColor);
		CGFloat r = rgba[0];
		CGFloat g = rgba[1];
		CGFloat b = rgba[2];
		CGFloat a = rgba[3];
		
		CGFloat h, s, v;
		RGBtoHSV(r, g, b, &h, &s, &v);
		
		h *= hd;
		v *= vd;
		s *= sd;
		
		HSVtoRGB(&r, &g, &b, h, s, v);
		
		return [UIColor colorWithRed:r green:g blue:b alpha:a];
	}

	-(UIColor *) addHue:(CGFloat)hd saturation:(CGFloat)sd value:(CGFloat)vd {
		const CGFloat *rgba = CGColorGetComponents(self.CGColor);
		CGFloat r = rgba[0];
		CGFloat g = rgba[1];
		CGFloat b = rgba[2];
		CGFloat a = rgba[3];
		
		CGFloat h, s, v;
		RGBtoHSV(r, g, b, &h, &s, &v);
		
		h += hd;
		v += vd;
		s += sd;
		
		HSVtoRGB(&r, &g, &b, h, s, v);
		
		return [UIColor colorWithRed:r green:g blue:b alpha:a];
	}

	-(CGFloat) hue {
		const CGFloat *rgba = CGColorGetComponents(self.CGColor);
		CGFloat h, s, v;
		RGBtoHSV(rgba[0], rgba[1], rgba[2], &h, &s, &v);
		return h;
	}

	-(CGFloat) saturation {
		const CGFloat *rgba = CGColorGetComponents(self.CGColor);
		CGFloat h, s, v;
		RGBtoHSV(rgba[0], rgba[1], rgba[2], &h, &s, &v);
		return s;
	}

	-(CGFloat) value {
		const CGFloat *rgba = CGColorGetComponents(self.CGColor);
		CGFloat h, s, v;
		RGBtoHSV(rgba[0], rgba[1], rgba[2], &h, &s, &v);
		return v;
	}


	#pragma mark Color Saturations

	-(UIColor *) highlight {
		return [self multiplyHue:1 saturation:0.4 value:1.2];
	}

	-(UIColor *) shadow {
		return [self multiplyHue:1 saturation:0.6 value:0.6];
	}

@end
