	// line number tracking
%option yylineno
%option nounistd
	// define reentrant scanner
	//%option 8bit reentrant noyywrap

%{
#pragma warning( disable: 4996)
#include <stdio.h>
#include <string.h>
#include "DBG.h"
#include "crowbar.h"
#include "y.tab.h"

int
yywrap(void)
{
    return 1;
}
static void
increment_line_number(void)
{
    crb_get_current_interpreter()->current_line_number++;
}
%}
%start COMMENT STRING_LITERAL_STATE
%%
<INITIAL>"function"     {printf("Line:%d | Lex12(keyword)-->function\n\n",yylineno);return FUNCTION;}
<INITIAL>"if"           {printf("Line:%d | Lex12(keyword)-->if\n\n",yylineno);return IF;}
<INITIAL>"else"         {printf("Line:%d | Lex12(keyword)-->else\n\n",yylineno);return ELSE;}
<INITIAL>"elsif"        {printf("Line:%d | Lex12(keyword)-->elseif\n\n",yylineno);return ELSIF;}
<INITIAL>"while"        {printf("Line:%d | Lex12(keyword)-->while\n\n",yylineno);return WHILE;}
<INITIAL>"for"          {printf("Line:%d | Lex12(keyword)-->for\n\n",yylineno);return FOR;}
<INITIAL>"return"       {printf("Line:%d | Lex12(keyword)-->return\n\n",yylineno);return RETURN_T;}
<INITIAL>"break"        {printf("Line:%d | Lex12(keyword)-->break\n\n",yylineno);return BREAK;}
<INITIAL>"continue"     {printf("Line:%d | Lex12(keyword)-->continue\n\n",yylineno);return CONTINUE;}
<INITIAL>"null"         {printf("Line:%d | Lex12(keyword)-->null\n\n",yylineno);return NULL_T;}
<INITIAL>"true"         {printf("Line:%d | Lex12(keyword)-->true\n\n",yylineno);return TRUE_T;}
<INITIAL>"false"        {printf("Line:%d | Lex12(keyword)-->false\n\n",yylineno);return FALSE_T;}
<INITIAL>"global"       {printf("Line:%d | Lex12(keyword)-->global\n\n",yylineno);return GLOBAL_T;}
<INITIAL>"("            {printf("Line:%d | Lex10(operand)-->(\n\n",yylineno);return LP;}
<INITIAL>")"            {printf("Line:%d | Lex10(operand)-->)\n\n",yylineno);return RP;}
<INITIAL>"{"            {printf("Line:%d | Lex13(bracket)-->{\n\n",yylineno);return LC;}
<INITIAL>"}"            {printf("Line:%d | Lex13(bracket)-->}\n\n",yylineno);return RC;}
<INITIAL>";"            {printf("Line:%d | Lex14(punctuation)-->;\n\n",yylineno);return SEMICOLON;}
<INITIAL>","            {printf("Line:%d | Lex14(punctuation)-->,\n\n",yylineno);return COMMA;}
<INITIAL>"&&"           {printf("Line:%d | Lex11(LogicOp)-->&&\n\n",yylineno);return LOGICAL_AND;}
<INITIAL>"||"           {printf("Line:%d | Lex11(LogicOp)-->||\n\n",yylineno);return LOGICAL_OR;}
<INITIAL>"="            {printf("Line:%d | Lex10(Operand)-->=\n\n",yylineno);return ASSIGN;}
<INITIAL>"=="           {printf("Line:%d | Lex11(LogicOp)-->==\n\n",yylineno);return EQ;}
<INITIAL>"!="           {printf("Line:%d | Lex11(LogicOp)-->!=\n\n",yylineno);return NE;}
<INITIAL>">"            {printf("Line:%d | Lex11(LogicOp)-->>\n\n",yylineno);return GT;}
<INITIAL>">="           {printf("Line:%d | Lex11(LogicOp)-->>=\n\n",yylineno);return GE;}
<INITIAL>"<"            {printf("Line:%d | Lex11(LogicOp)--><\n\n",yylineno);return LT;}
<INITIAL>"<="           {printf("Line:%d | Lex11(LogicOp)--><=\n\n",yylineno);return LE;}
<INITIAL>"+"            {printf("Line:%d | Lex10(Operand)-->+\n\n",yylineno);return ADD;}
<INITIAL>"-"            {printf("Line:%d | Lex10(Operand)-->-\n\n",yylineno);return SUB;}
<INITIAL>"*"            {printf("Line:%d | Lex10(Operand)-->*\n\n",yylineno);return MUL;}
<INITIAL>"/"            {printf("Line:%d | Lex10(Operand)-->/\n\n",yylineno);return DIV;}
<INITIAL>"%"            {printf("Line:%d | Lex10(Operand)-->%%\n\n",yylineno);return MOD;}
<INITIAL>[A-Za-z_][A-Za-z_0-9]* {
    yylval.identifier = crb_create_identifier(yytext);
    return IDENTIFIER;
}
<INITIAL>([1-9][0-9]*)|"0" {
    Expression  *expression = crb_alloc_expression(INT_EXPRESSION);
    sscanf(yytext, "%d", &expression->u.int_value);
    yylval.expression = expression;
    return INT_LITERAL;
}
<INITIAL>[0-9]+\.[0-9]+ {
    Expression  *expression = crb_alloc_expression(DOUBLE_EXPRESSION);
    sscanf(yytext, "%lf", &expression->u.double_value);
    yylval.expression = expression;
    return DOUBLE_LITERAL;
}
<INITIAL>\" {
    crb_open_string_literal();
    BEGIN STRING_LITERAL_STATE;
}
<INITIAL>[ \t] ;
<INITIAL>(\r)?\n {increment_line_number();}
<INITIAL>#     BEGIN COMMENT;
<INITIAL>.      {
    char buf[LINE_BUF_SIZE];

    if (isprint(yytext[0])) {
        buf[0] = yytext[0];
        buf[1] = '\0';
    } else {
        sprintf(buf, "0x%02x", (unsigned char)yytext[0]);
    }

    crb_compile_error(CHARACTER_INVALID_ERR,
                      STRING_MESSAGE_ARGUMENT, "bad_char", buf,
                      MESSAGE_ARGUMENT_END);
}
<COMMENT>\n     {
    increment_line_number();
    BEGIN INITIAL;
}
<COMMENT>.      ;
<STRING_LITERAL_STATE>\"        {
    Expression *expression = crb_alloc_expression(STRING_EXPRESSION);
    expression->u.string_value = crb_close_string_literal();
    yylval.expression = expression;
    BEGIN INITIAL;
    return STRING_LITERAL;
}
<STRING_LITERAL_STATE>\n        {
    crb_add_string_literal('\n');
    increment_line_number();
}
<STRING_LITERAL_STATE>\\\"      crb_add_string_literal('"');
<STRING_LITERAL_STATE>\\n       crb_add_string_literal('\n');
<STRING_LITERAL_STATE>\\t       crb_add_string_literal('\t');
<STRING_LITERAL_STATE>\\\\      crb_add_string_literal('\\');
<STRING_LITERAL_STATE>.         crb_add_string_literal(yytext[0]);
%%
