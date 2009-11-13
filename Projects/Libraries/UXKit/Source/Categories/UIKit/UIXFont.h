
/*!
@project	UXKit
@header		UIXFont.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UIKit/UIKit.h>

/*!
@category UIFont (UIXFont)
@abstract
@discussion
*/
@interface UIFont (UIXFont)

	/*!
	@abstract Gets the height of a line of text with this font.
	@discussion Why this isn't part of UIFont is beyond me. This is the height 
	you would expect to get by calling sizeWithFont.
	*/
	-(CGFloat) lineHeight;

@end

/*!
.times lt mm: (TimesLTMM)
times new roman: (TimesNewRomanBoldItalic, TimesNewRomanItalic, TimesNewRoman, TimesNewRomanBold)
phonepadtwo: (PhonepadTwo)
hiragino kaku gothic pron w3: (HiraKakuProN-W3)
helvetica neue: (HelveticaNeueBold, HelveticaNeue)
trebuchet ms: (TrebuchetMSItalic, TrebuchetMSBoldItalic, TrebuchetMSBold, TrebuchetMS)
courier new: (CourierNewBoldItalic, CourierNewBold, CourierNewItalic, CourierNew)
arial unicode ms: (arialuni)
georgia: (Georgia, GeorgiaBold, GeorgiaBoldItalic, GeorgiaItalic)
zapfino: (Zapfino)
arial rounded mt bold: (ArialRoundedMTBold)
db lcd temp: (DB_LCD_Temp-Black)
verdana: (Verdana, VerdanaItalic, VerdanaBoldItalic, VerdanaBold)
american typewriter: (AmericanTypewriterCondensedBold, AmericanTypewriter)
helvetica: (HelveticaBoldOblique, Helvetica, HelveticaOblique, HelveticaBold)
lock clock: (LockClock)
courier: (CourierBoldOblique, CourierOblique)
hiragino kaku gothic pron w6: (HiraKakuProN-W6)
arial: (ArialItalic, ArialBold, Arial, ArialBoldItalic)
.helvetica lt mm: (HelveticaLTMM)
stheiti: (STHeiti, STXihei)
applegothic: (AppleGothicRegular)
marker felt: (MarkerFeltThin)
*/