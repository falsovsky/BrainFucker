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
		returnValue = [[NSNumber numberWithInt:rowIndex] stringValue];
	
	if ([[aTableColumn identifier] isEqualToString:@"2"])
		returnValue = [self objectAtIndex:rowIndex];
	
	if ([[aTableColumn identifier] isEqualToString:@"3"])
	{
		NSNumber *myVal = [self objectAtIndex:rowIndex];
		unichar myChar = [myVal intValue];
		NSString *myStr = [NSString stringWithCharacters: &myChar length:1];		
		returnValue = myStr;
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

/*
 Esta função é chamada no arranque do programa
*/
- (void)awakeFromNib
{
	myMemory = [[NSMutableArray alloc] initWithCapacity:32768];
	
	// Inicializa o NSMutableArray com NSNumbers a 0
	int i;
	for(i=0; i < 32768; i++)
	{
		[myMemory addObject:[NSNumber numberWithInt:0]];
	}
	
	// Liga o myMemory ao memoryDisplay
	[memoryDisplay setDataSource: myMemory];
}

/*
 Mete o conteudo da memoria todo a 0
*/
- (void)limpaMemoria
{
	int i;
	for(i=0; i < 32768; i++)
	{
		[myMemory replaceObjectAtIndex:i withObject:
			[NSNumber numberWithInt:0]];
	}
	[memoryDisplay reloadData];
}

- (IBAction)run:(id)sender
{
	[self limpaMemoria];
	
	isRunning = YES;
	programPosition = 1;
	int i;
	
	// Cria uma NSString com o conteudo da NSTextView de Input
	NSString *myInput = [[inputCode textStorage] string];
	// Copia o codigo para um array de ints (myCode)
	// TODO: Meter isto a correr directamente da NSTextView ou do NSString
	// TODO: ou então ignorar logo tudo non-bf aqui
	for(i = 0; i < [myInput length]; i++) {
		myCode[programPosition] = [myInput characterAtIndex:i];
		programPosition++;
	}
	
	int programLen = programPosition; // "tamanho" do programa
		
	for (programPosition = 0; programPosition < programLen; programPosition++) 
	{
		[self runStep];
	}
	
	isRunning = NO;
}

- (void)runStep
{
	// Todas estas variaveis são para conseguir escrever em ASCII
	// o valor da memoria apontada por mpointer - BLEH!!!
	
	// Apanha o valor da memoria em memoryPosition
	NSNumber *memValue = [myMemory objectAtIndex:memoryPosition];
	unichar memChar = [memValue intValue]; // Passa o valor para um unichar
	
	// Variaveis temporarias para escrever na NSTextView
	// TODO: Tem de haver uma maneira mais simples de fazer isto
	NSString *memCharStr;
	NSAttributedString *memAttrStr;
	NSTextStorage *myOut;
	
	switch(myCode[programPosition]) 
	{
		/* Adiciona um oo valor da memoria em mpointer */
		case '+':
			[myMemory replaceObjectAtIndex:memoryPosition withObject:
				[NSNumber numberWithInt:[memValue intValue]+1]];			
			break;
		/* Subtrai um ao valor da memoria em mpointer */
		case '-':
			[myMemory replaceObjectAtIndex:memoryPosition withObject:
				[NSNumber numberWithInt:[memValue intValue]-1]];	
			break;
		/* Incrementa mpointer */
		case '>':
			memoryPosition++;
			break;
		/* Subtrai mpointer */
		case '<':
			memoryPosition--;
			break;
		/* Imprime o valor na memoria em mpointer */
		case '.':
			// Mete a NSString com o valor do unichar c
			memCharStr = [NSString stringWithCharacters: &memChar length:1];
			// Cria preenche uma NSAttributedString com o valor da NSString
			memAttrStr = [[NSAttributedString alloc] initWithString:memCharStr];
			// O storage fica com o conteudo actual da NSTextView de Output (Acho eu)
			myOut = [outputText textStorage];
			[myOut beginEditing];
			// Adiciona a string ao final do storage
			[myOut appendAttributedString:memAttrStr];
			[myOut endEditing];
			break;
		/* Le o valor e guarda-o na posicao de memoria actual */
		case ',':
			// TODO: Ainda não está implementado
			break;
		/* Start loop */
		case '[':
			if ([memValue intValue] == 0)
			{
				/* Find matching ] */
				programPosition++;
				/* If ciclos == 0 and myCode[programPosition] == ']' we found
				* the matching brace */
				while (ciclos > 0 || myCode[programPosition] != ']') 
				{
					if (myCode[programPosition] == '[') ciclos++;
					if (myCode[programPosition] == ']') ciclos--;
					/* Go in right direction */
					programPosition++;
				}
			}
			break;
		/* End loop */
		case ']':
			if ([memValue intValue] != 0)
			{
				/* Find matching [ */
				programPosition--;
				while (ciclos > 0 || myCode[programPosition] != '[')
				{
					if (myCode[programPosition] == '[') ciclos--;
					if (myCode[programPosition] == ']') ciclos++;
					/* Go left */
					programPosition--;
				}
				programPosition--;
			}
			break;
	}
	
	// Supostamente seleciona a linha da memoria actualmente escolhida
	// mas ta quieto oh preto...
	[memoryDisplay selectRow: memoryPosition byExtendingSelection: NO];
	// Refresh na gaja!
	[memoryDisplay reloadData];
	
}

@end
