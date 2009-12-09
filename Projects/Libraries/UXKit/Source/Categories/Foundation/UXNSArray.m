
#import <UXKit/UXNSArray.h>
#import <UXKit/UXGlobal.h>

@implementation NSArray (UXNSArray)

	-(void) perform:(SEL)selector {
		NSEnumerator *e = [[[self copy] autorelease] objectEnumerator];
		for (id delegate; delegate = [e nextObject]; ) {
			if ([delegate respondsToSelector:selector]) {
				[delegate performSelector:selector];
			}
		}
	}

	-(void) perform:(SEL)selector withObject:(id)p1 {
		NSEnumerator *e = [[[self copy] autorelease] objectEnumerator];
		for (id delegate; delegate = [e nextObject]; ) {
			if ([delegate respondsToSelector:selector]) {
				NSMethodSignature *sig = [delegate methodSignatureForSelector:selector];
				NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
				[invo setTarget:delegate];
				[invo setSelector:selector];
				[invo setArgument:&p1 atIndex:2];
				[invo invoke];
			}
		}
	}

	-(void) perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
		NSEnumerator *e = [[[self copy] autorelease] objectEnumerator];
		for (id delegate; delegate = [e nextObject]; ) {
			if ([delegate respondsToSelector:selector]) {
				NSMethodSignature *sig = [delegate methodSignatureForSelector:selector];
				NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
				[invo setTarget:delegate];
				[invo setSelector:selector];
				[invo setArgument:&p1 atIndex:2];
				[invo setArgument:&p2 atIndex:3];
				[invo invoke];
			}
		}
	}

	-(void) perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
		NSEnumerator *e = [[[self copy] autorelease] objectEnumerator];
		for (id delegate; delegate = [e nextObject]; ) {
			if ([delegate respondsToSelector:selector]) {
				NSMethodSignature *sig = [delegate methodSignatureForSelector:selector];
				NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
				[invo setTarget:delegate];
				[invo setSelector:selector];
				[invo setArgument:&p1 atIndex:2];
				[invo setArgument:&p2 atIndex:3];
				[invo setArgument:&p3 atIndex:4];
				[invo invoke];
			}
		}
	}

	#pragma mark -

	-(id) objectWithValue:(id)value forKey:(id)key {
		for (id object in self) {
			id propertyValue = [object valueForKey:key];
			if ([propertyValue isEqual:value]) {
				return object;
			}
		}
		return nil;
	}

	-(id) objectWithClass:(Class)cls {
		for (id object in self) {
			if ([object isKindOfClass:cls]) {
				return object;
			}
		}
		return nil;
	}

	-(BOOL) containsObject:(id)object withSelector:(SEL)selector {
		for (id item in self) {
			if ([item performSelector:selector withObject:object]) {
				return TRUE;
			}
		}
		return FALSE;
	}

@end

#pragma mark -

@implementation NSMutableArray (UXNSMutableArray)

	-(void) addNonEmptyString:(NSString *)string {
		if ((nil != string) && !UXIsEmptyString(string)) {
			[self addObject:string];
		}
	}

@end

#pragma mark -

@implementation NSMutableArray (UXQueue)

	-(void) enqueue:(id)anObject {
		[self insertObject:anObject atIndex:0];
	}

	-(id) dequeue {
		id anObject = [[self lastObject] retain];
		[self removeLastObject];
		return [anObject autorelease];
	}

@end
