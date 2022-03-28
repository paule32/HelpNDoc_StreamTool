%{
// -------------------------------------------------------
// File: parser.l
// Desc: parser for HelpNdoc.exe stream Tool 1.0
//
// Autor: Jens Kallup <kallup.jens@web.de>
// Copy : (c) 2022 by Jens Kallup
//
// only for private use !
// -------------------------------------------------------
#include "misc.hh"

#define YYDEBUG 0

#include "parser.tab.hh"

// Forward declerations ----------------------------------
void Number();
void HexaNumber();
void count(void);

int yyerror(const char*);

int line_row  = 1;
int line_col  = 1;

std::vector<char> tmpvec;

void handle_str();

// HelpNdoc API related ----------------------------------
// --------------------------------------------------------------
// this acts as a lister for a object function arguments.
// --------------------------------------------------------------
class HelpNDocAPI_FunctionArgument {
public:
    // constructor's:
    HelpNDocAPI_FunctionArgument() { }
};

// --------------------------------------------------------------
// this class stands for a single type :
// --------------------------------------------------------------
class HelpNDocAPI_Type {
public:
};

// --------------------------------------------------------------
// this class stands for a single object :
// --------------------------------------------------------------
class HelpNDocAPI_Object {
private:
    std::string func_name;
    std::vector< HelpNDocAPI_FunctionArgument > args;
public:
    // constructor's:
    HelpNDocAPI_Object(const char* func) :func_name(std::move(func)) { }
    HelpNDocAPI_Object(std::string func) :func_name(std::move(func)) { }
    
    // destructor:
    ~HelpNDocAPI_Object() { }
};

// --------------------------------------------------------------
// this is the main class of all objects that are available
// in the current version of HelpNDoc 7.9.1 ...
// --------------------------------------------------------------
class HelpNDocAPI {
private:
    // List of objects:
    std::vector< HelpNDocAPI_Object > HndUtils;                // Various utility methods.
    std::vector< HelpNDocAPI_Object > HndBuilds;               // Properties and methods for Builds.
    std::vector< HelpNDocAPI_Object > HndBuildsEx;             // Additional properties and methods for Builds.
    std::vector< HelpNDocAPI_Object > HndBuildsMeta;           // Access to builds meta data.
    std::vector< HelpNDocAPI_Object > HndBuildsMetaEx;         // Additional methods related to builds meta data.
    std::vector< HelpNDocAPI_Object > HndBuildsStatus;         // Handle relationship between builds and statuses.
    std::vector< HelpNDocAPI_Object > HndBuildsStatusEx;       // Additional methods to handle relationship between builds and statuses.
    std::vector< HelpNDocAPI_Object > HndBuildsTags;           // Handle relationship between builds and tags.
    std::vector< HelpNDocAPI_Object > HndBuildsTagsEx;         // Additional methods to handle relationship between builds and tags.
    std::vector< HelpNDocAPI_Object > HndDictionaries;         // Manage dictionaries and live spell check.
    std::vector< HelpNDocAPI_Object > HndEditor;               // Create and manage a topic editor.
    std::vector< HelpNDocAPI_Object > HndEditorHelper;         // Additional methods to manage a topic editor.
    std::vector< HelpNDocAPI_Object > HndJsSearchEngine;       // Methods to manage the JavaScript search engine.
    std::vector< HelpNDocAPI_Object > HndKeywords;             // Properties and methods for keywords.
    std::vector< HelpNDocAPI_Object > HndKeywordsMeta;         // Access to topics meta data.
    std::vector< HelpNDocAPI_Object > HndLibraryItems;         // Properties and methods for library items.
    std::vector< HelpNDocAPI_Object > HndLibraryItemsEx;       // Additional properties and methods for library items.
    std::vector< HelpNDocAPI_Object > HndLibraryItemsCache;    // Library items cache.
    std::vector< HelpNDocAPI_Object > HndLibraryItemsMeta;     // Access to library items meta data.
    std::vector< HelpNDocAPI_Object > HndProjects;             // Properties and methods for projects.
    std::vector< HelpNDocAPI_Object > HndProjectsEx;           // Additional properties and methods for projects.
    std::vector< HelpNDocAPI_Object > HndProjectsMeta;         // Access to project meta data.
    std::vector< HelpNDocAPI_Object > HndProjectsMetaEx;       // Additional methods to access project meta data.
    std::vector< HelpNDocAPI_Object > HndStatus;               // Properties and methods for Statuses.
    std::vector< HelpNDocAPI_Object > HndTags;                 // Properties and methods for Tags.
    std::vector< HelpNDocAPI_Object > HndTemplates;            // Properties and methods for Templates.
    std::vector< HelpNDocAPI_Object > HndTemplatesEx;          // Additional properties and methods for Templates.
    std::vector< HelpNDocAPI_Object > HndTopics;               // Create, edit and manage topics within the current project.
    std::vector< HelpNDocAPI_Object > HndTopicsEx;             // Additional properties and methods for Topics.
    std::vector< HelpNDocAPI_Object > HndTopicsKeywords;       // Handle relationship between topics and keywords.
    std::vector< HelpNDocAPI_Object > HndTopicsKeywordsEx;     // Additional properties and methods to handle relationship between topics and keywords.
    std::vector< HelpNDocAPI_Object > HndTopicsMeta;           // Access to topics meta data.
    std::vector< HelpNDocAPI_Object > HndTopicsProperties;     // Handle relationship between topics and properties.
    std::vector< HelpNDocAPI_Object > HndTopicTags;            // Handle relationship between topics and tags.
    
    // Global types:
    std::vector< HelpNDocAPI_Type   > THndBuildInfo;
    std::vector< HelpNDocAPI_Type   > THndBuildInfoArray;
    std::vector< HelpNDocAPI_Type   > THndDictionaryInfo;

    // availabel members:
    std::vector< std::string > HndUtils_FunctionNames = {
        {"FilterAlphaNumericString"}, // Filter a string to make it alpha-numeric only. Converts accented characters too.
        {"HexToTColor"},      // Converts an hexadecimal value to a TColor
        {"HTMLDecode"},       // Converts a string that has been HTML-encoded into a decoded string.
        {"HTMLEncode"},       // Converts a string into an HTML-encoded string.
        {"HTMLEscape"},       // Escape HTML entities so that they can be included in HTML text or attribute.
        {"HTMLToText"},       // Converts a HTML content to simple text without any tags.
        {"IdnEncode"},        // Performs a International Domain Name (IDNA) Punycode encoding.
        {"IdnDecode"},        // Performs a International Domain Name (IDNA) Punycode decoding.
        {"JSEncode"},         // Encodes a string for use in a JavaScript string literal.
        {"JSEscapeQuote"},    // Escape single and double quotes in a JavaScript string literal.
        {"TColorToHex"},      // Converts a TColor string value to a heaxadecimal string.
        {"UrlEncode"},        // Performs a URL percent encoding.
        {"UrlDecode"}         // Performs a URL percent decoding.
    };
public:
    // constructor
    HelpNDocAPI() {
        for (const std::string& name : HndUtils_FunctionNames)
            HndUtils.push_back(name);
    }
};
static class HelpNDocAPI HelpNDocAPI_Instance;

// ---------------------------------------
// max include files for $include macro:
// ---------------------------------------
# define MAX_INCLUDE_DEPTH 10
YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];

static int include_stack_ptr = 0;
%}

%option noyywrap
%option caseless

DIGIT       [0-9\.]
HEXALETTER  [a-fA-F]
HEXANUMBER  [0][x](({DIGIT}|{HEXALETTER})+)
NUM         {DIGIT}+
WS          [ \t\n\r]*
ID          [a-z_]+[a-zA-Z0-9_]*
REMS1       ((\/\/.*)|(\&\&.*)|(\/\/.*\n*)|(\&\&.*\n*))*
REMS2       ((\/\*\*\/)|(\/\*(\n*|.*)\*\/))*
REMSER      {WS}{REMS1}|{REMS2}{WS}
FILENAME    \"(([a-zA-Z]\:\\[ a-zA-Z0-9\_\.\\]*)|([a-zA-Z]\:[ a-zA-Z0-9\_\.\\]*)|([ a-zA-Z0-9\_\.\\])*)\"

%x COMMENTS

%x TOK_INCLUDE
%x TOK_MAINPAGE

%x TOK_SUB_AUTOR
%x TOK_SUB_TITLE
%x TOK_SUB_VERSION
%x TOK_SUB_COPYRIGHT
%x TOK_SUB_SUMMARY

%%

\/\/(.*|.*\n)     { count(); BEGIN(INITIAL); }

\/\*              { count(); BEGIN(COMMENTS); }
<COMMENTS>\*\/    { count(); BEGIN(INITIAL);  }
<COMMENTS>\n      { count(); }
<COMMENTS>.       { count(); }

{NUM}        { count();     Number(); return TOK_NUMBER; }
{HEXANUMBER} { count(); HexaNumber(); return TOK_NUMBER; }

\$"include"([ \t]+) { count(); BEGIN(TOK_INCLUDE); }
\$[iI]+([ \t]+)     { count(); BEGIN(TOK_INCLUDE); }

\@"mainpage" { count(); printf("-> mainpage"); BEGIN(TOK_MAINPAGE); }
\@"end"      { yyerror("@end does not enclose a block statement."); }

<TOK_INCLUDE>{FILENAME}           {
	count();
	printf("inc: %s\n", yytext);
	
    // ---------------------------------
    // default max include are 10 files:
    // ---------------------------------
    if (include_stack_ptr >= MAX_INCLUDE_DEPTH) {
      fprintf(stderr, "Includes nested too deeply");
      exit(1);
    }

    include_stack[include_stack_ptr++] = YY_CURRENT_BUFFER;

    // ---------------------------------
    // remove first, and last qoute ...
    // ---------------------------------
    std::string f(yytext);
    f.erase(0,1);
    f.erase(f.size() - 1);
    
    char *buffer = (char*) malloc(128);
          buffer = &(f[0]);

    if (!(yyin = fopen(buffer, "r"))) {
        sprintf(buffer,"file not: %s found.", yytext);
        yyerror(buffer);
    }
    
    // ---------------------------------
    // parse the $include "file" :
    // ---------------------------------
    yy_switch_to_buffer(
    yy_create_buffer(yyin, YY_BUF_SIZE));

	BEGIN(INITIAL);
}

<TOK_MAINPAGE>\\"autor"           { count(); tmpvec.clear(); printf("--> autor  : "); BEGIN(TOK_SUB_AUTOR);     }
<TOK_MAINPAGE>\\"title"           { count(); tmpvec.clear(); printf("--> title  : "); BEGIN(TOK_SUB_TITLE);     }
<TOK_MAINPAGE>\\"version"         { count(); tmpvec.clear(); printf("--> version: "); BEGIN(TOK_SUB_VERSION);   }
<TOK_MAINPAGE>\\"copyright"       { count(); tmpvec.clear(); printf("--> copyr  : "); BEGIN(TOK_SUB_COPYRIGHT); }
<TOK_MAINPAGE>\\"summary"         { count(); tmpvec.clear(); printf("--> summary: "); BEGIN(TOK_SUB_SUMMARY);   }

<TOK_MAINPAGE>\@"end" { count(); printf("-> end\n"); BEGIN(INITIAL); }
<TOK_MAINPAGE>.       { count(); }

<TOK_SUB_AUTOR><TOK_MAINPAGE>     { count(); }
<TOK_SUB_AUTOR>\n                 { count(); handle_str(); BEGIN(TOK_MAINPAGE); }
<TOK_SUB_AUTOR>.                  { count(); tmpvec.push_back(*yytext); }

<TOK_SUB_TITLE><TOK_MAINPAGE>     { count(); }
<TOK_SUB_TITLE>\n                 { count(); handle_str(); BEGIN(TOK_MAINPAGE); }
<TOK_SUB_TITLE>.                  { count(); tmpvec.push_back(*yytext); }

<TOK_SUB_VERSION><TOK_MAINPAGE>   { count(); }
<TOK_SUB_VERSION>\n               { count(); handle_str(); BEGIN(TOK_MAINPAGE); }
<TOK_SUB_VERSION>.                { count(); tmpvec.push_back(*yytext); }

<TOK_SUB_COPYRIGHT><TOK_MAINPAGE> { count(); }
<TOK_SUB_COPYRIGHT>\n             { count(); handle_str(); BEGIN(TOK_MAINPAGE); }
<TOK_SUB_COPYRIGHT>.              { count(); tmpvec.push_back(*yytext); }

<TOK_SUB_SUMMARY><TOK_MAINPAGE>   { count(); }
<TOK_SUB_SUMMARY>\n               { count(); handle_str(); BEGIN(TOK_MAINPAGE); }
<TOK_SUB_SUMMARY>.                { count(); tmpvec.push_back(*yytext); }


[-+*/\,\.\=] {
    count();
    printf("op: %s\n", yytext);
    return *yytext;
}

[ \t]*              { count(); }
[\n]*               { count(); }

<<EOF>>             {
    // ----------------------------------------------
    // check, if end of file, is it in main document,
    // terminate parser session; else: return back to
    // previously file ...
    // ----------------------------------------------
    if (--include_stack_ptr < 0) {
        yyterminate();
    }   else {
        yy_delete_buffer( YY_CURRENT_BUFFER);
        yy_switch_to_buffer(
        include_stack[ include_stack_ptr ]);
    }
}

.		;

%%
//-- FUNCTION DEFINITIONS ---------------------------------

// --------------------------------
// console error output:
// --------------------------------
int yyerror(const char *p) {
    printf("Error: %d:%d: %s\n",
        line_row,
        line_col,p);
    exit(1);
}

// --------------------------------
// convert string to int64
// --------------------------------
void Number () {
    yylval.val_int64 = atol(yytext);
}

// --------------------------------
// convert hex string to int64
// --------------------------------
void HexaNumber () {
    yylval.val_int64 = (unsigned int) strtol(yytext, (char **)NULL, 16);
}

// --------------------------------
// count character position:
// --------------------------------
void count(void)
{
    int i;
    for (i = 0; yytext[i] != '\0'; i++) {
	    if (yytext[i] == '\n')  { line_col  = 0; ++line_row; } else
	    if (yytext[i] == '\t')  { line_col += 1;             } else line_col++;
    }
}

// --------------------------------
// trim trailing space from tmpvec
// --------------------------------
void handle_str()
{
    std::string id;
	
    for (char value: tmpvec)
    id +=  value;
	
    ltrim(id);
    std::cout << id << std::endl;
}

// --------------------------------
// application entry point:
// --------------------------------
int main(int argc, char **argv)
{
    int result = 0;

    printf("helpndoc (c) 2022 IBE-Software\n");
    printf("all rights reserved.\n\n");

    if (argc < 2) {
        printf("no file given.\n");
        return 1;
    }

    if (!(yyin = fopen(argv[1],"r"))) {
        fprintf(stderr,"error: can't find input \"%s\" "
        "file !\nuse default stdin.\n",argv[1]);
        yyset_in(stdin);
    }   yyset_in(yyin);

    result = yylex();
	
    fclose(yyin);
    return result;
}
