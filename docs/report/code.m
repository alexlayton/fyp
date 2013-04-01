
//Example 1
#import <Foundation/Foundation.h>

@interface HelloWorld : NSObject
+ (void)hello1;
- (void)hello2;
@end

@implementation HelloWorld
+ (void)hello1 
{
	NSLog(@"Hello, World");
}
- (void)hello2 
{
	NSLog(@"Hello, World");
}
@end

int main(void) 
{
	[HelloWorld hello1];
    HelloWorld *hw = [[HelloWorld alloc] init];
	[hw hello2];
}

//example 2
@protocol ADelegate <NSObject>
- (void)aDelegateMethod;
@end

@interface A : NSObject
@property (nonatomic, weak) id<ADelegate> delegate;
- (void)start;
@end

@interface B : NSObject <ADelegate>
@end

@implementation B
- (void)aDelegateMethod
{
	NSLog(@"Hello, World");
}
@end

int main(void) 
{
	A *aObj = [[A alloc] init];
	B *bObj = [[B alloc] init];
	a.delegate = b; //register b as a's delegate
	[a start]; //on some even [delegate aDelegateMethod] is called
}


//example 3
<key>UIBackgroundModes</key>
	<array>
		<string>location</string>
	</array>
<key>Required background modes</key>
	<array>
		<string>Appregistersforlocationupdates</string>
	</array>