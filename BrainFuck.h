/* BrainFuck */

#import <Cocoa/Cocoa.h>

@interface BrainFuck : NSObject
{
    IBOutlet NSTextView *inputCode;
    IBOutlet NSTableView *memoryDisplay;
    IBOutlet NSTextView *outputText;
	
	BOOL isRunning;
	int programPosition, memoryPosition;
	int ciclos;
	
	// Para onde Ž copiado o codigo do programa
	int myCode[32768];
	// Memoria do programa
	NSMutableArray *myMemory;
}
- (IBAction)run:(id)sender;
- (void)limpaMemoria;
- (void)runStep;

@end
