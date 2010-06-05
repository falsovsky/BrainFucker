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
		returnValue = [NSNumber numberWithInt:rowIndex];
	
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
	// inicializa o pc a 0
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
	int i,kl;
	
	// Cria uma NSString com o conteudo da NSTextView de Input
	NSString *codigo = [[inputCode textStorage] string];
	// Copia o codigo para um array de ints (space)
	// TODO: Meter isto a correr directamente da NSTextView ou do NSString
	// TODO: ou ent‹o ignorar logo tudo non-bf aqui
	for(i = 0; i < [codigo length]; i++) {
		space[spointer] = [codigo characterAtIndex:i];
		spointer++;
	}
	
	int len = spointer; // "tamanho" do programa
	
	spointer = 0; // pointer do codigo
	mpointer = 0; // pointer da memoria
	
	// TODO: A ideia Ž passar isto para um outro metodo para implementar
	// TODO: o Single-Step, etc.
	for (spointer = 0; spointer < len; spointer++) 
	{
		// Todas estas variaveis s‹o para conseguir escrever em ASCII
		// o valor da memoria apontada por mpointer - BLEH!!!
		
		// Apanha o valor da memoria apontada por mpointer
		NSNumber *memPos = [myMemory objectAtIndex:mpointer];
		unichar c = [memPos intValue]; // Passa o valor para um unichar

		// Variaveis temporarias para escrever na NSTextView
		// TODO: Tem de haver uma maneira mais simples de fazer isto
		NSString *str;
		NSAttributedString *string;
		NSTextStorage *storage;
		
		switch(space[spointer]) 
		{
			/* Adiciona um oo valor da memoria em mpointer */
			case '+':
				[myMemory replaceObjectAtIndex:mpointer withObject:
					[NSNumber numberWithInt:[memPos intValue]+1]];			
				break;
			/* Subtrai um ao valor da memoria em mpointer */
			case '-':
				[myMemory replaceObjectAtIndex:mpointer withObject:
					[NSNumber numberWithInt:[memPos intValue]-1]];	
				break;
			/* Incrementa mpointer */
			case '>':
				mpointer++;
				break;
			/* Subtrai mpointer */
			case '<':
				mpointer--;
				break;
			/* Imprime o valor na memoria em mpointer */
			case '.':
				// Mete a NSString com o valor do unichar c
				str = [NSString stringWithCharacters: &c length:1];
				// Cria preenche uma NSAttributedString com o valor da NSString
				string = [[NSAttributedString alloc] initWithString:str];
				// O storage fica com o conteudo actual da NSTextView de Output (Acho eu)
				storage = [outputText textStorage];
				[storage beginEditing];
				// Adiciona a string ao final do storage
				[storage appendAttributedString:string];
				[storage endEditing];
				break;
			/* Le o valor e guarda-o na posicao de memoria actual */
			case ',':
				// TODO: Ainda n‹o est‡ implementado
				break;
			/* Start loop */
			case '[':
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
		
		// Supostamente seleciona a linha da memoria actualmente escolhida
		// mas ta quieto oh preto...
		[memoryDisplay selectRow: mpointer byExtendingSelection: NO];
		// Refresh na gaja!
		[memoryDisplay reloadData];
	}
	
}


@end
