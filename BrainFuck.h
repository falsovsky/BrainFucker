/* BrainFuck */

#import <Cocoa/Cocoa.h>

@interface BrainFuck : NSObject
{
    IBOutlet NSTextView *inputCode;
    IBOutlet NSTableView *memoryDisplay;
    IBOutlet NSTextView *outputText;
	
	int space[32768];
	//int memory[32768];
	NSMutableArray *myMemory;
	int pc; // Program Counter
}
- (IBAction)run:(id)sender;
- (void)limpaMemoria;
@end
