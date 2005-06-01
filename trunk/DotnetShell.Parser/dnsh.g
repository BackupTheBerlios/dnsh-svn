options
{
        language="CSharp";
        namespace="NModule.Dependency.Parser";
}

class DnshParser extends Parser;

options {
        k=3;
}

tokens {
	PROFILE="profile";
	GLOBAL="global";
	USING="using";
	MODULE="module";
	PREFIX="prefix";
	IF="if";
	ELSE="else";
	RETURN="return";
	OPTION="option";
	ALIAS="alias";
	SET="set";
	GET="get";
	EXTERNAL="external";
	EXPORT="export";
	SOURCE="source";
}

top_level:
	profile_directive
	| using_directive
	| module_directive
	| prefix_directive
	| function_block
	| option_block
	| global_block
	;

profile_directive:
	PROFILE STRING SC!;

using_directive:
	(global_metadata_directive)? USING NAMESPACE SC!;

global_metadata_directive:
	LBRACKET! GLOBAL RBRACKET!;

module_directive:
	MODULE NAMESPACE SC!;

prefix_directive:
	PREFIX ID SC!;

function_block:
	(metadata_declarations)*
	ID arg_list
	LBRACE!
		internal_block
	RBRACE!
	;

metadata_declarations:
	LBRACKET! metadata_declaration (COMMA! metadata_declaration)* RBRACKET!
	;

metadata_declaration:
	ID (ARG_LIST)?
	;

option_block:
	OPTION LPAREN! STRING RPAREN!
	LBRACE!
	  (alias_declaration)*
	RBRACE!
	;

alias_declaration:
	ALIAS lvalue EQ rvalue SC!
	;

global_block:
	GLOBAL (LPAREN STRING RPAREN)?
	LBRACE!
		internal_block
	RBRACE!
	;

internal_block:
	option_call
	| expression
	;

option_call:
	OPTION SET STRING STRING SC!
 	| OPTION GET STRING SC!
	;

expression:
	assignment_expression
	| if_expression
	| shell_expression
	| method_expression
	| math_expression
	;

assignment_expression:
	lvalue EQOP rvalue SC!
	;

if_expression:
	IF LPAREN! if_conditionals RPAREN!
	LBRACE!
		internal_block
	RBRACE!
	(elseif_expression)*
	(else_expression)?
	;

elseif_expression:
	ELSE IF LPAREN! if_conditionals RPAREN!
	LBRACE!
		internal_block
	RBRACE!
	;

else_expression:
	ELSE
	LBRACE!
		internal_block
	RBRACE!
	;

if_conditionals:
	LPAREN! (if_conditional)* RPAREN!
	;

if_conditional:
	cvalue COP cvalue
	;

cvalue:
	VAR
	| STRING
	| method_expression
	| LPAREN! if_conditional RPAREN!
	;


shell_expression:
	source_expression
	| export_expression
	| external_expression
	| external_call_expression
	;

source_expression:
	SOURCE LPAREN! STRING RPAREN! SC!
	;

export_expression:
	EXPORT LPAREN! STRING RPAREN! SC!
	;

external_expression:
	LBRACKET! EXTERNAL RBRACKET! shell_assignment_expression
	;

external_call_expression:
	AT ID arg_list SC!
	;

method_expression:
	ID LPAREN! ARG_LIST RPAREN! SC!
	;

math_expression:
	( math_value MOP math_value
	| LPAREN math_expression RPAREN
	)* SC!
	;

math_value:
	ID
	| NUM_TYPE
	;

shell_assignment_value:
  assignment_expression
	| lvalue EQ shell_expression;

lvalue:
	ID
	| method_expression
	;



DnshLexer extends Lexer;

COP:
	(AND|OR|XOR|BAND|BOR|BXOR|NEQ|EQ|LS|LTE|GT|GTE|BSL|BSR)
	;

EQOP:
	(ASSN|ASBSL|ASBSR|ASPL|ASMN|ASMUL|ASDIV|ASBA|ASBO|ASBX|ASBN)
	;


