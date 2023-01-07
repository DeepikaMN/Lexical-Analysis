/*Check for valid declarative statement. Intimate the erors to users*/
%{
    /*Definations*/
//  #include "parser.tab.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
// int yylval;
int linecount = 1;


#define BREAK 1
#define CONST 2
#define CONTINUE 3
#define DEFAULT 4
#define DOUBLE 5
#define ELSE 6
#define END 7
#define ENDFOR 8
#define ENDFUN 9
#define ENDWHILE 10
#define FOR 11
#define IF 12
#define INT 13
#define RETURN 14
#define STRUCT 15
#define TYPEDEF 16
#define UNION 17
#define VOID 18
#define WHILE 19

#define IDENTIFIER 20
#define SLC 21
#define MLCS 22
#define MLCE 23

#define LEQ 24
#define GEQ 25
#define EQEQ 26
#define NEQ 27
#define LOR 28
#define LAND 29
#define ASSIGN 30
#define PLUS 31
#define SUB 32
#define MULT 33
#define DIV 34
#define MOD 35
#define LESSER 36
#define GREATER 37
#define INCR 38
#define DECR 39

#define COMMA 40
#define SEMI 41

#define HEADER 42
#define MAIN 43

#define OUTPUT 44 
#define INPUT 45 
#define DEFINE 46

#define INT_CONST 47
#define DOUBLE_CONST 48

#define TYPE_SPEC 49

#define DQ 50
#define OBO 51
#define OBC 52
#define CBO 53
#define CBC 54
#define HASH 55

#define ARR 56
#define FUNC 57

#define NUM_ERR 58
#define UNKNOWN 59

#define STR_CONST 60
#define THEN 61
#define LEFT_SHIFT 62
#define RIGHT_SHIFT 63

%}

alpha [A-Za-z]
digit [0-9]
und [_]
space [ ]
tab [	]
line [\n]
at [@]
string \"(.^([%d]|[%f]|[%s]|[%c]))\"


/*Rules*/
%%

{space}* {}
{tab}* {}
{string} return STR_CONST;
{line} {linecount++;}

break return BREAK;
const return CONST;
continue return CONTINUE;
default return DEFAULT;
double return DOUBLE;
else return ELSE;
end return END;
endfor return ENDFOR;
endfun return ENDFUN;
endwhile return ENDWHILE;
for return FOR;
if return IF;
int return INT;
return return RETURN;
then return THEN;

struct return STRUCT;
typedef return TYPEDEF;
union return UNION;
void return VOID;
while return WHILE;
output return OUTPUT;
input return INPUT;
{alpha}({alpha}|{digit}|{und})* return IDENTIFIER;

"//" return SLC;
"/*" return MLCS;
"*/" return MLCE;
"<=" return LEQ;
">=" return GEQ;
"==" return EQEQ;
"!=" return NEQ;
"||" return LOR;
"&&" return LAND;
"=" return ASSIGN;
"+" return PLUS;
"-" return SUB;
"*" return MULT;
"/" return DIV;
"%" return MOD;
"<" return LESSER;
">" return GREATER;
"++" return INCR;
"--" return DECR;
"," return COMMA;
";" return SEMI;
"#include<stdio.h>" return HEADER;
"#include <stdio.h>" return HEADER;
"#include <math.h>" return HEADER;
"#include<math.h>" return HEADER;
"#include <stdlib.h>" return HEADER;
"#include<stdlib.h>" return HEADER;
"#include <string.h>" return HEADER;
"#include<strng.h>" return HEADER;
"main()" return MAIN;
{digit}+ return INT_CONST;
({digit}+)\.({digit}+) return DOUBLE_CONST;
"%d"|"%f"|"%u"|"%s" return TYPE_SPEC;
"\"" return DQ;
"(" return OBO;
")" return OBC;
"{" return CBO;
"}" return CBC;
"#" return HASH;
">>"  return RIGHT_SHIFT; 
"<<"  return LEFT_SHIFT;

":"		{  return(':'); }
"["		{  return('['); }
"]"		{  return(']'); }
"|"		{  return('|'); }
"&"		{  return('&'); }
"?"		{  return('?'); }

{alpha}({alpha}|{digit}|{und})*\[{digit}*\] return ARR;
{alpha}({alpha}|{digit}|{und})*\(({alpha}|{digit}|{und}|{space})*\) return FUNC;
({digit}+)\.({digit}+)\.({digit}|\.)* return NUM_ERR;
({digit}|{at})+({alpha}|{digit}|{und}|{at})* return UNKNOWN;

%%

struct node
{
	char token[100];
    	char attr[100];
	struct node *next;
};
struct hash
{
	struct node *head;
	int count;
};
struct hash hashTable[1000];
int eleCount = 1000;
struct node * createNode(char *token, char *attr)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	newnode->next = NULL;
	return newnode;
}
int hashIndex(char *token)
{
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void hashInsert(char *token, char *attr)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("-------------------------------------------------------------------");
    	printf("\nSNo \t|\tToken \t\t|\tToken Type \t\n");
        printf("-------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\t\n", myNode->attr);
            		myNode = myNode->next;
        	}
	}
   	return;
}


int main()
{
	int scan, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
    yyin = fopen("test2.c","r");
	printf("\n\n");
	scan = yylex();
	while(scan)
	{
		if(linecount == slcline)
		{
			scan = yylex();
			continue;
		}
		if(linecount!=dqline && dqline!=0)
		{
			if(dq%2!=0)
				printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<INCOMPLETE STRING at Line %d >>>>>>>>>>\n\n", dqline);
			dq=0;
		}
		if((scan>=1 && scan<=19 && scan == 61) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "KEYWORD");
		}
		if(scan==20 && mlc==0)
		{
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "IDENTIFIER");
		}
		if(scan==21)
		{
			printf("%s\t\t\tSingleline Comment\t\tLine %d\n", yytext, linecount);
			slcline = linecount;
		}
		if(scan==22 && mlc==0)
		{
			printf("%s\t\t\tMultiline Comment Start\t\tLine %d\n", yytext, linecount);
			mlcline = linecount;
			mlc = 1;
		}
		if(scan==23 && mlc==0)
		{
			printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<UNMATCHED MULTILINE COMMENT END %s at Line %d >>>>>>>>>>\n\n", yytext, linecount);
		}
		if(scan==23 && mlc==1)
		{
			mlc = 0;
			printf("%s\t\t\tMultiline Comment End\t\tLine %d\n", yytext, linecount);
		}
		if((scan>=24 && scan<=39) && mlc==0)
		{
			printf("%s\t\t\tOPERATOR\t\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "OPERATOR");
		}
		if((scan==40||scan==41||scan==50||(scan>=51 && scan<=55)) && mlc==0)
		{
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, linecount);
			if(scan==50)
			{
				dq++;
				dqline = linecount;
			}
			hashInsert(yytext, "SPECIAL SYMBOL");
		}
		if(scan==42 && mlc==0)
		{
			printf("%s\tHEADER\t\t\t\tLine %d\n",yytext, linecount);
		}
		if(scan==43 && mlc==0)
		{
			printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "IDENTIFIER");
		}
		if((scan==44 || scan==45) && mlc==0)
		{
			printf("%s\t\t\tPRE DEFINED FUNCTION\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "PRE DEFINED FUNCTION");
		}
		if(scan==46 && mlc==0)
		{
			printf("%s\t\t\tPRE PROCESSOR DIRECTIVE\t\tLine %d\n", yytext, linecount);
		}
		if(scan==47 && mlc==0)
		{
			printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "INTEGER CONSTANT");
		}
		if(scan==48 && mlc==0)
		{
			printf("%s\t\t\tFLOATING POINT CONSTANT\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "FLOATING POINT CONSTANT");
		}
		if(scan==49 && mlc==0)
		{
			printf("%s\t\t\tTYPE SPECIFIER\t\t\tLine %d\n", yytext, linecount);
		}
		if(scan==56 && mlc==0)
		{
			printf("%s\t\t\tARRAY\t\t\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "ARRAY");
		}
		if(scan==57 && mlc==0)
		{
			printf("%s\t\t\tUSER DEFINED FUNCTION\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "USER DEFINED FUNCTION");
		}
		if(scan==58 && mlc==0)
		{
			printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<CONSTANT ERROR %s at Line %d >>>>>>>>>>\n\n", yytext, linecount);
		}
		if(scan==59 && mlc==0)
		{
			printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<UNKNOWN TOKEN %s at Line %d >>>>>>>>>>\n\n", yytext, linecount);
		}
		if(scan==60 && mlc==0)
		{
			printf("%s\t\t\tSTRING CONSTANT\t\t\tLine %d\n", yytext, linecount);
			hashInsert(yytext, "STRING CONSTANT");
		}
		scan = yylex();
	}
	if(mlc==1)
		printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<UNMATCHED COMMENT STARTING at Line %d >>>>>>>>>>\n\n",mlcline);
	printf("\n");
	printf("\n\t############## SYMBOL TABLE ##############\t\t\n");
	display();
        printf("-------------------------------------------------------------------\n\n");
}




int yywrap(){
    return 1;
}

