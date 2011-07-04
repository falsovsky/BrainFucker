/* BrainFuck */

#import <Cocoa/Cocoa.h>

@interface BrainFuck : NSObject
{
    IBOutlet NSTextView *inputCode;
    IBOutlet NSTableView *memoryDisplay;
    IBOutlet NSTextView *outputText;
	IBOutlet NSButton *runButton;
	IBOutlet NSButton *stepoutButton;
	IBOutlet NSDrawer *myDrawer;
	
	BOOL isRunning;
	BOOL inCycle;
	int programPosition, memoryPosition;
	int ciclos;
	
	// Para onde Ž copiado o codigo do programa
	int myCode[32768];
	int codeLength;
	// Memoria do programa
	NSMutableArray *myMemory;
}

- (IBAction)run:(id)sender;
- (IBAction)singleStep:(id)sender;
- (IBAction)stepOut:(id)sender;

- (void)limpaMemoria;
- (void)doStep;
- (BOOL)isBrainFuckCode:(char)c;

@end
