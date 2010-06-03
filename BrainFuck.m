#import "BrainFuck.h"

// Makes an NSArray work as an NSTableDataSource.
@implementation NSMutableArray (NSTableDataSource)

// just returns the item for the right row
- (id)tableView:(NSTableView *) aTableView
objectValueForTableColumn:(NSTableColumn *) aTableColumn
				 row:(int) rowIndex
{
	NSString *returnValue;

	if ([[aTableColumn identifier] isEqualToString:@"1"])
		returnValue = [NSString stringWithFormat:@"%i", [NSNumber numberWithInt:rowIndex]];
		//returnValue = [NSNumber numberWithInt:rowIndex];
	
	if ([[aTableColumn identifier] isEqualToString:@"2"])
		returnValue = [self objectAtIndex:rowIndex];
	
	if ([[aTableColumn identifier] isEqualToString:@"3"])
	{
		NSNumber *valor = [self objectAtIndex:rowIndex];
		unichar c = [valor intValue];
		NSString *str = [NSString stringWithCharacters: &c length:1];		
		returnValue = str;
	}

	return returnValue;
}

// just returns the number of items we have.
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [self count];  
}
@end

@implementation BrainFuck

- (void)awakeFromNib
{
	pc = 0;
	myMemory = [[NSMutableArray alloc] initWithCapacity:32768];
	[self limpaMemoria];
	// Liga o myMemory ao memoryDisplay
	[memoryDisplay setDataSource: myMemory];
	
}

- (void)limpaMemoria
{
	int i;
	
	[myMemory removeAllObjects];
	for(i=0; i < 32768; i++)
	{
		[myMemory addObject:[NSNumber numberWithInt:0]];
		//space[i] = 0;
	}
	[memoryDisplay reloadData];
}

- (IBAction)run:(id)sender
{
	[self limpaMemoria];
	int spointer = 1,mpointer;
	int i,len,kl;
	NSString *codigo = [[inputCode textStorage] string];
	NSMutableString *curChar;
	
	for(i = 0; i < [codigo length]; i++) {
		//NSLog(@"%c", [codigo characterAtIndex:i]);
		space[spointer] = [codigo characterAtIndex:i];
		spointer++;
	}
	
	len = spointer;
	spointer = 0;
	mpointer = 0;
	for (spointer = 0; spointer < len; spointer++) 
	{
		curChar = @"";
		NSNumber *memPos = [myMemory objectAtIndex:mpointer];
		unichar c = [memPos intValue];
		NSString *str;
		NSAttributedString *string;
		NSTextStorage *storage;
		//NSLog(@"#%i - '%c', MemPos: %i, MemVal: %d", spointer, space[spointer], mpointer, [memPos intValue]);
		switch(space[spointer]) 
		{
			/* Increment pointer value */
			case '+':
				[myMemory replaceObjectAtIndex:mpointer withObject:
					[NSNumber numberWithInt:[memPos intValue]+1]];			
				//memory[mpointer]++;
				break;
				/* Decrement pointer value */
			case '-':
				[myMemory replaceObjectAtIndex:mpointer withObject:
					[NSNumber numberWithInt:[memPos intValue]-1]];	
				//memory[mpointer]--;
				break;
				/* Increment pointer */
			case '>':
				mpointer++;
				break;
				/* Decrement pointer */
			case '<':
				mpointer--;
				break;
				/* Print current pointer value */
			case '.':
				/*
				curChar = [NSMutableString stringWithFormat:@"%c",[memPos charValue]];
				NSLog(@"BENFICA: %S\n",curChar);
				outputT = [outputText stringValue];
				outputT = [NSMutableString stringWithFormat:@"%s%s",outputT,curChar];
				[outputText setStringValue:curChar];
				//[this stringWithFormat:@"%c" , [memPos charValue]];
				NSLog(@"\nViva o MEU BENFICA: %@\n",curChar);
				//[outputText insertText:curChar];
                //[outputText setNeedsDisplay:YES];
                //[outputText displayIfNeeded];
				*/
				//NSNumber *valor = [self objectAtIndex:rowIndex];
				str = [NSString stringWithCharacters: &c length:1];
				string = [[NSAttributedString alloc] initWithString:str];
				storage = [outputText textStorage];
				[storage beginEditing];
				[storage appendAttributedString:string];
				[storage endEditing];
				//putchar(memory[mpointer]);
				break;
				/* Read value and store in current pointer */
			case ',':
				//memory[mpointer] = getchar();
				break;
				/* Start loop */
			case '[':
				//if (memory[mpointer] == 0) {
				if ([memPos intValue] == 0)
				{
					/* Find matching ] */
					spointer++;
					/* If kl == 0 and space[pointer] == ']' we found
					* the matching brace */
					while (kl > 0 || space[spointer] != ']') 
					{
						if (space[spointer] == '[') kl++;
						if (space[spointer] == ']') kl--;
						/* Go in right direction */
						spointer++;
					}
				}
				break;
				/* End loop */
			case ']':
				//if (memory[mpointer] != 0) {
				if ([memPos intValue] != 0)
				{
					/* Find matching [ */
					spointer--;
					while (kl > 0 || space[spointer] != '[')
					{
						if (space[spointer] == '[') kl--;
						if (space[spointer] == ']') kl++;
						/* Go left */
						spointer--;
					}
					spointer--;
				}
				break;
			}
		[memoryDisplay selectRow: mpointer byExtendingSelection: NO];
		[memoryDisplay reloadData];
		}
	
}


@end
