%{
// -------------------------------------------------------
// File: parser.l
// Desc: parser for HelpNdoc.exe stream Tool 1.0
//       With this tool, You can create HTML Help file on
//       the command line console.
//
// Autor: Jens Kallup <kallup.jens@web.de>
// Copy : (c) 2022 by Jens Kallup
//
// only for private use !
// -------------------------------------------------------
#define YYDEBUG 1

# include "misc.hh"
# include "parser.tab.hh"

// Forward declerations ----------------------------------
void Number();
void HexaNumber();
void count(void);

int yyerror(const char*);

int line_row = 1;
int line_col = 1;

std::vector<char> tmpvec;

extern void init_buffer();

void handle_str();

// HelpNdoc API related ----------------------------------
namespace HelpNDoc_Version7_9_1 {
// --------------------------------------------------------------
// type's for an argument of a single function ...
// --------------------------------------------------------------
using HelpNDocAPI_ArgumentType = std::variant<
    int,                // is integer
    double,             // is double
    std::string         // is std::string
>;
using HelpNDocAPI_ArgumentMap = std::map<
    int,                // argument no.
    HelpNDocAPI_ArgumentType
>;
// --------------------------------------------------------------
// this class stands for a single object :
// --------------------------------------------------------------
class HelpNDocAPI_Object {
private:
    std::map<
        std::string,              // function name
        HelpNDocAPI_ArgumentMap   // arguments
    > Functions;
public:
    // constructor's:
    //HelpNDocAPI_Object(                           // ctor
    //    const char* func,                         // function name
    //    HelpNDocAPI_ArgumentMap args) {           // arguments
    //    Functions [ std::string(func) ] = args;
    //}
    HelpNDocAPI_Object(std::string func) { }
    
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
    std::vector< HelpNDocAPI_Object > HndTopicsTags;           // Handle relationship between topics and tags.
    
    // Global types:
    std::vector< HelpNDocAPI_Object > THndBuildInfo;
    std::vector< HelpNDocAPI_Object > THndBuildInfoArray;
    std::vector< HelpNDocAPI_Object > THndDictionaryInfo;

    // placeholder's:
    static std::string _String ;
    static std::string _Bool   ;
    static std::string _Integer;
    static std::string _TColor ;
    
    HelpNDocAPI_ArgumentMap result_map = { {0, _String}, { 1, _String } };
    
    // -----------------------------------------
    // HndUtils:
    // Various utility methods.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndUtils_FunctionNames = {
        // Filter a string to make it alpha-numeric only. Converts accented characters too.
        {std::string("FilterAlphaNumericString"), {
            { 0, _String },   // 0 = the result parameter: String
            { 1, _String },   // 1 = aStr
            { 2, _Bool   },   // 2 = const doKeepSpaces
            { 3, _Bool   },   // 3 = const doKeepUnderscore
            { 4, _Bool   }    // 4 = const doKeepDash
            }
        },
        
        {std::string("HexToTColor"  ), result_map },    // Converts an hexadecimal value to a TColor
        {std::string("HTMLDecode"   ), result_map },    // Converts a string that has been HTML-encoded into a decoded string.
        {std::string("HTMLEncode"   ), result_map },    // Converts a string into an HTML-encoded string.
        {std::string("HTMLEscape"   ), result_map },    // Escape HTML entities so that they can be included in HTML text or attribute,
        {std::string("HTMLToText"   ), result_map },    // Converts a HTML content to simple text without any tags.
        {std::string("IdnEncode"    ), result_map },    // Performs a International Domain Name (IDNA) Punycode encoding.
        {std::string("IdnDecode"    ), result_map },    // Performs a International Domain Name (IDNA) Punycode decoding.
        {std::string("JSEncode"     ), result_map },    // Encodes a string for use in a JavaScript string literal.
        {std::string("JSEscapeQuote"), result_map },    // Escape single and double quotes in a JavaScript string literal.
        {std::string("TColorToHex"  ), result_map },    // Converts a TColor string value to a heaxadecimal string.
        {std::string("TColorToHex"  ), {                // Converts a TColor string value to a heaxadecimal string.
            { 0, _String },   // 0 = the result parameter: String
            { 1, _String }    // 1 = TColor
            }
        },
        {std::string("UrlEncode"    ), result_map },    // Performs a URL percent encoding.
        {std::string("UrlDecode"    ), result_map }     // Performs a URL percent decoding.
    };
    
    // -----------------------------------------
    // HndBuilds:
    // Properties and methods for Builds.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndBuilds_FunctionNames = {
        {std::string("CreateBuild"         ), result_map },
        {std::string("DeleteAllBuilds"     ), result_map },
        {std::string("DeleteBuild"         ), result_map },
        {std::string("GetBuildEnabled"     ), result_map },
        {std::string("GetBuildFirst"       ), result_map },
        {std::string("GetBuildFirstOfKind" ), result_map },
        {std::string("GetBuildKind"        ), result_map },
        {std::string("GetBuildLast"        ), result_map },
        {std::string("GetBuildList"        ), result_map },
        {std::string("GetBuildName"        ), result_map },
        {std::string("GetBuildNext"        ), result_map },
        {std::string("GetBuildOrder"       ), result_map },
        {std::string("GetBuildOutput"      ), result_map },
        {std::string("GetBuildWithName"    ), result_map },
        {std::string("MoveBuildAfter"      ), result_map },
        {std::string("MoveBuildBefore"     ), result_map },
        {std::string("MoveBuildFirst"      ), result_map },
        {std::string("MoveBuildLast"       ), result_map },
        {std::string("SetBuildEnabled"     ), result_map },
        {std::string("SetBuildKind"        ), result_map },
        {std::string("SetBuildName"        ), result_map },
        {std::string("SetBuildOutput"      ), result_map },
        {std::string("SetBuildTemplate"    ), result_map }
    };
    
    // -----------------------------------------
    // HndBuildsEx:
    // Additional properties and methods for Builds.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndBuildsEx_FunctionNames = {
        {std::string("DuplicateBuild"             ), result_map },
        {std::string("GetBuildListFilteredByName" ), result_map },
        {std::string("GetBuildTemplateOrDefault"  ), result_map },
        {std::string("GetValidBuildOutput"        ), result_map }
    };
    
    // -----------------------------------------
    // HndBuildsMetaEx:
    // Additional methods related to builds meta data.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndBuildsMetaEx_FunctionNames = {
        {std::string("GetChmButtonVisibilityHex"           ), result_map },
        {std::string("GetChmNavigationPaneStyleHex"        ), result_map },
        {std::string("GetProjectDateTimeFormatOverrides"   ), result_map },
        {std::string("GetProjectSettingsOverrides"         ), result_map },
        {std::string("ResetProjectDateTimeFormatOverrides" ), result_map },
        {std::string("ResetProjectSettingsOverrides"       ), result_map },
        {std::string("SetProjectDateTimeOverrides"         ), result_map },
        {std::string("SetProjectSettingsOverrides"         ), result_map }
    };
    
    // -----------------------------------------
    // HndBuildsStatus:
    // Handle relationship between builds and statuses.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndBuildsStatus_FunctionNames = {
        {std::string("AreBuildAndStatusAssociated"   ), result_map },
        {std::string("AssociateBuildWithStatus"      ), result_map },
        {std::string("DissociateAllForStatus"        ), result_map },
        {std::string("DissociateAllForBuild"         ), result_map },
        {std::string("DissociateBuildFromStatus"     ), result_map },
        {std::string("GetStatusAssociatedWithBuild"  ), result_map },
        {std::string("GetBuildsAssociatedWithStatus" ), result_map }
    };
    
    // -----------------------------------------
    // HndBuildsStatusEx:
    // Additional methods to handle relationship between builds and statuses
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndBuildsStatusEx_FunctionNames = {
        {std::string("IsTopicIncludedInBuild" ), result_map }
    };
    
    // -----------------------------------------
    // HndBuildsTags:
    // Handle relationship between builds and tags.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndBuildsTags_FunctionNames = {
        {std::string("AreBuildAndTagAssociated"   ), result_map },
        {std::string("AssociateBuildWithTag"      ), result_map },
        {std::string("DissociateAllForTag"        ), result_map },
        {std::string("DissociateAllForBuild"      ), result_map },
        {std::string("DissociateBuildFromTag"     ), result_map },
        {std::string("GetTagsAssociatedWithBuild" ), result_map },
        {std::string("GetBuildsAssociatedWithTag" ), result_map }
    };
    
    // -----------------------------------------
    // HndBuildsTagsEx:
    // Additional methods to handle relationship between builds and tags.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndBuildsTagsEx_FunctionNames = {
        {std::string("ConditionAdd"           ), result_map },
        {std::string("ConditionInvert"        ), result_map },
        {std::string("ConditionRemove"        ), result_map },
        {std::string("ConditionReset"         ), result_map },
        {std::string("IsTopicIncludedInBuild" ), result_map }
    };
    
    
    // -----------------------------------------
    // HndEditor:
    // Create and manage a topic editor.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndEditor_FunctionNames = {
        {std::string("ApplyStyleToSelection"              ), result_map },
        {std::string("Clear"                              ), result_map },
        {std::string("ConvertParagraphBreaksToLineBreaks" ), result_map },
        {std::string("ConvertSelectionToSnippet"          ), result_map },
        {std::string("CreateTemporaryEditor"              ), result_map },
        {std::string("CreateTemporaryReportHelper"        ), result_map },
        {std::string("CreateTemporaryViewer"              ), result_map },
        {std::string("DestroyTemporaryEditor"             ), result_map },
        {std::string("DestroyTemporaryReportHelper"       ), result_map },
        {std::string("DestroyTemporaryViewer"             ), result_map },
        {std::string("GetAnchorList"                      ), result_map },
        {std::string("GetContentAsHtml"                   ), result_map },
        {std::string("GetContentAsStream"                 ), result_map },
        {std::string("GetContentAsText"                   ), result_map },
        {std::string("GetCurrentAnchorName"               ), result_map },
        {std::string("GetCurrentItem"                     ), result_map },
        {std::string("GetCurrentPictureAltText"           ), result_map },
        {std::string("GetCurrentPictureBackColor"         ), result_map },
        {std::string("GetCurrentPictureHeight"            ), result_map },
        {std::string("GetCurrentPictureMarginLeftRight"   ), result_map },
        {std::string("GetCurrentPictureMarginTopBottom"   ), result_map },
        {std::string("GetCurrentPicturePadding"           ), result_map },
        {std::string("GetCurrentPictureVAlign"            ), result_map },
        {std::string("GetCurrentPictureWidth"             ), result_map },
        {std::string("GetUsedLibraryItems"                ), result_map },
        {std::string("InsertAnchorBeforeCurrentItem"      ), result_map },
        {std::string("InsertCondition"                    ), result_map },
        {std::string("InsertContentFromHTML"              ), result_map },
        {std::string("InsertFile"                         ), result_map },
        {std::string("InsertFileFromLibraryItem"          ), result_map },
        {std::string("InsertHyperLinkToTopicId"           ), result_map },
        {std::string("InsertHyperLinkToUrl"               ), result_map },
        {std::string("InsertLibraryItem"                  ), result_map },
        {std::string("InsertLibraryItemContent"           ), result_map },
        {std::string("InsertPageBreakBeforeCurrentItem"   ), result_map },
        {std::string("InsertStream"                       ), result_map },
        {std::string("InsertTopicContent"                 ), result_map },
        {std::string("IsEmpty"                            ), result_map },
        {std::string("MoveCaret"                          ), result_map },
        {std::string("MoveCaretTo"                        ), result_map },
        {std::string("MoveCarretToEnd"                    ), result_map },
        {std::string("ProcessConditionalsForCurrentBuild" ), result_map },
        {std::string("RemoveCurrentAnchor"                ), result_map },
        {std::string("ReplaceLibraryItems"                ), result_map },
        {std::string("SetAsTopicContent"                  ), result_map },
        {std::string("SetContent"                         ), result_map },
        {std::string("SetCurrentCellsAlignment"           ), result_map },
        {std::string("SetCurrentPictureAltText"           ), result_map },
        {std::string("SetCurrentPictureBackColor"         ), result_map },
        {std::string("SetCurrentPictureHeight"            ), result_map },
        {std::string("SetCurrentPictureMarginLeftRight"   ), result_map },
        {std::string("SetCurrentPictureMarginTopBottom"   ), result_map },
        {std::string("SetCurrentPicturePadding"           ), result_map },
        {std::string("SetCurrentPictureVAlign"            ), result_map },
        {std::string("SetCurrentPictureWidth"             ), result_map },
        {std::string("SyntaxHighlightSelection"           ), result_map },
        {std::string("TogglePageBreak"                    ), result_map },
        {std::string("UpdateLibraryItem"                  ), result_map }
    };
    
    
    // -----------------------------------------
    // HndProjects:
    // Properties and methods for projects.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndProjects_FunctionNames = {
        {std::string("BackupProject"                   ), result_map },
        {std::string("CloseProject"                    ), result_map },
        {std::string("CopyProject"                     ), result_map },
        {std::string("DeleteProject"                   ), result_map },
        {std::string("GetProjectAuthor"                ), result_map },
        {std::string("GetProjectBusy"                  ), result_map },
        {std::string("GetProjectCharset"               ), result_map },
        {std::string("GetProjectCharsetAsHtml"         ), result_map },
        {std::string("GetProjectClosing"               ), result_map },
        {std::string("GetProjectComment"               ), result_map },
        {std::string("GetProjectCopyright"             ), result_map },
        {std::string("GetProjectCreating"              ), result_map },
        {std::string("GetProjectCssContent"            ), result_map },
        {std::string("GetProjectId"                    ), result_map },
        {std::string("GetProjectLanguage"              ), result_map },
        {std::string("GetProjectLanguageCode"          ), result_map },
        {std::string("GetProjectLanguageCodeAsHtml"    ), result_map },
        {std::string("GetProjectName"                  ), result_map },
        {std::string("GetProjectNeverSaved"            ), result_map },
        {std::string("GetProjectOpenning"              ), result_map },
        {std::string("GetProjectTitle"                 ), result_map },
        {std::string("GetProjectVersion"               ), result_map },
        {std::string("ImportTableOfContentsForProject" ), result_map },
        {std::string("LockResource"                    ), result_map },
        {std::string("MoveProject"                     ), result_map },
        {std::string("NewProject"                      ), result_map },
        {std::string("OpenProject"                     ), result_map },
        {std::string("SaveProject"                     ), result_map },
        {std::string("SetProjectAuthor"                ), result_map },
        {std::string("SetProjectCharset"               ), result_map },
        {std::string("SetProjectComment"               ), result_map },
        {std::string("SetProjectCopyright"             ), result_map },
        {std::string("SetProjectDefaultTopic"          ), result_map },
        {std::string("SetProjectLanguage"              ), result_map },
        {std::string("SetProjectModified"              ), result_map },
        {std::string("SetProjectNeverSaved"            ), result_map },
        {std::string("SetProjectSummary"               ), result_map },
        {std::string("SetProjectTitle"                 ), result_map },
        {std::string("SetProjectVersion"               ), result_map },
        {std::string("UnlockResource"                  ), result_map },
        {std::string("VacuumProject"                   ), result_map }
    };
    
    // -----------------------------------------
    //
    //
    // availabel members ...
    // -----------------------------------------
    #if 0
    {std::string(""    ), {
    {std::string(""    ), {
    {std::string(""    ), {
    
    {std::string(""    ), {
    #endif

    // -----------------------------------------
    // HndBuildInfo:
    // Information about a specific build.
    // availabel members ...
    // -----------------------------------------
    std::map< std::string, HelpNDocAPI_ArgumentMap > HndBuildInfo_FunctionNames = {
        // Unique identifier of the build.
        {std::string("Id"), {
            { 0, _String }    // 0 = the result parameter: String
            }
        },
        // Kind of the build: code, chm, epub, html, kindle, pdf, qthelp, word
        {std::string("Kind"), {
            { 0, _String }    // 0 = the result parameter: String
            }
        },
        // Name of the build.
        {std::string("Name"), {
            { 0, _String }    // 0 = the result parameter: String
            }
        },
        // Is the build enabled ?
        {std::string("Enabled"), {
            { 0, _Bool }      // 0 = the result parameter: Boolean
            }
        },
        // Order of the build in the list. Greater will be built later.
        {std::string("Order"), {
            { 0, _Integer }   // 0 = the result parameter: Integer
            }
        },
        // Output path of the build.
        {std::string("Output"), {
            { 0, _String }    // 0 = the result parameter: String
            }
        },
        //Template name used for this build.
        {std::string("Template"), {
            { 0, _String }    // 0 = the result parameter: String
            }
        }
    };
public:
    // constructor
    HelpNDocAPI() {
        //HelpNDocAPI_ArgumentMap Arguments;
        //Arguments[ 1 ] = 1;
        
    //    for (const std::string& name : HndUtils_FunctionNames)
    //        HndUtils.push_back(name.first);
    }
};  // class HelpNDocAPI

// placeholders, to save disk space
std::string  HelpNDocAPI::_String  = std::string( "string"  );
std::string  HelpNDocAPI::_Bool    = std::string( "bool"    );
std::string  HelpNDocAPI::_Integer = std::string( "Integer" );
std::string  HelpNDocAPI::_TColor  = std::string( "TColor"  );

static class HelpNDocAPI HelpNDocAPI_Instance;

}   // namespace: HelpNDoc_Version7_9_1

// ---------------------------------------
// max include files for $include macro:
// ---------------------------------------
# define MAX_INCLUDE_DEPTH 10
YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];

static int include_stack_ptr = 0;

static bool progressFile = false;    // stdin, or file ? (for the progress bar)
static int  progressMax  = 1;        // maximum of progress value (file lines)
static int  progressPos  = 1;        // current position cursor for progress bar
%}

%option noyywrap
%option caseless

DIGIT       [0-9\.]
LETTER      [a-zA-Z]
HEXALETTER  [a-fA-F]
HEXANUMBER  [0][x](({DIGIT}|{HEXALETTER})+)
NUM         {DIGIT}+
WS          [ \t\n\r]*
ID          [a-z_]+[a-zA-Z0-9_]*
REMS1       ((\/\/.*)|(\&\&.*)|(\/\/.*\n*)|(\&\&.*\n*))*
REMS2       ((\/\*\*\/)|(\/\*(\n*|.*)\*\/))*
REMSER      {WS}{REMS1}|{REMS2}{WS}
FILE1       [ a-zA-Z0-9\_\.\\]*
FILENAME    \"(({LETTER}\:\\{FILE1})|({LETTER}\:{FILE1})|({FILE1})*)\"
STRING      (\"(.*)\")+

%x COMMENTS
%x TOK_INCLUDE

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

\@{ID} {
    count();
    yylval.val_string = (char *) malloc(strlen(yytext)+1); strcpy(
    yylval.val_string, yytext);
    return TOK_CHAP;
}

\\{ID} {
    count();
    yylval.val_string = (char *) malloc(strlen(yytext)+1); strcpy(
    yylval.val_string, yytext);
    return TOK_CHAPSUB;
}

{STRING} {
    count();
    yylval.val_string = (char *) malloc(strlen(yytext)+1); strcpy(
    yylval.val_string, yytext);
    return TOK_STRING;
}

{ID} {
    count();
    yylval.val_string = (char *) malloc(strlen(yytext)+1); strcpy(
    yylval.val_string, yytext);
    return TOK_ID;
}

<TOK_INCLUDE>{STRING}           {
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

.   {   yyerror("syntax error."); }

%%
//-- FUNCTION DEFINITIONS ---------------------------------

// --------------------------------
// console error output:
// --------------------------------
int yyerror(const char *p)
{
    std::stringstream ss;
    ss << "Error: "
       << std::dec << line_row << ":"
       << std::dec << line_col << ": "
       << p        << std::endl ;
       
    throw EyyErrorExceptionE(ss.str());
    return 0;
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

// ------------------------------------------------------
// convert two strings to lower case, then
// compare two strings of equal case-insensitive.
// return true, if they equal
// ------------------------------------------------------
bool caseInsensitiveStringCompare(
    const std::string& str1,
    const std::string& str2)
{
    std::string str1Cpy( str1 );
    std::string str2Cpy( str2 );
    
    std::transform( str1Cpy.begin(), str1Cpy.end(), str1Cpy.begin(), ::tolower );
    std::transform( str2Cpy.begin(), str2Cpy.end(), str2Cpy.begin(), ::tolower );
    
    return ( str1Cpy == str2Cpy );
}
std::string UpperCase(const std::string& str)
{
    std::string cp( str );
    std::transform( cp.begin(), cp.end(), cp.begin(), ::toupper );
    return cp;
}
std::string LowerCase(const std::string& str)
{
    std::string cp( str );
    std::transform( cp.begin(), cp.end(), cp.begin(), ::tolower );
    return cp;
}

// --------------------------------
// application entry point:
// --------------------------------
int main(int argc, char **argv)
{
    int  result = 0;

    // --------------------------------------------------
    // copyright banner - please dont remove it.
    // --------------------------------------------------
    std::cout << "helpconv (c) 2022 Jens Kallup <kallup.jens@web.de>" <<
    std::endl << "all rights reserved." <<
    std::endl <<
    std::endl ;

    try {
        // --------------------------------------------------
        // argument must given, for file name; else stdin :
        // --------------------------------------------------
        if (argc < 2) {
            std::cout << "no file given." <<
            std::endl ;
            return 1;
        }

        //std::vector< std::string > args(argv, argv + argc);
        //for (const std::string& item : args)
        //std::cout << item << std::endl;
    
        // --------------------------------------------------
        // I use the C version of "flex + bison", so we have
        // to use old C functions to parse the source file :
        // --------------------------------------------------
        if (!(yyin = fopen(argv[1],"r"))) {
            std::cerr << "error: can't find input file: "
                      << argv[1]
                      <<
            std::endl << "use default stdin." <<
            std::endl ;

            yyset_in(stdin);
        }   else {
            int ch = 0;

            // get line numbers
            std::cout << "read up file(s) ..." <<
            std::endl ;
            
            progressMax = 1;
            fseek(yyin,0,SEEK_SET);
            while ((ch  = fgetc(yyin)) != EOF) {
                if (ch == '\n')
                progressMax++;
            }
            fseek(yyin,0,SEEK_SET);
            
            std::cout << "lines: "   <<
            std::dec  << progressMax <<
            std::endl ;
            
            yyset_in(yyin);
            progressFile = true;
        }

        std::cout << std::endl;
        
        // ------------------------------------
        // print banner COC - Code of Conduct:
        // ------------------------------------
        std::stringstream   coc; coc
        << "// This file was created automatically."         << std::endl
        << "// PLEASE DON'T EDIT IT."                        << std::endl
        << "// "                                             << std::endl
        << "// (c) 2022 by Jens Kallup <kallup.jens@web.de>" << std::endl
        << "// All rights reserved,"                         << std::endl
        << "// "                                             << std::endl
        << "// only for private use !!!"                     << std::endl;
        
        std::string coc1("// ");
        std::string coc2("// ");
        
        coc1.insert(3, 74, '-');
        coc2.insert(3, 74, '-');
        
        std::cout << coc1 << std::endl << coc.str();
        std::cout << coc2 << std::endl;

        // ------------------------------------
        // start grammar parser:
        // ------------------------------------
        if (!(result = yyparse()))
        throw EyyErrorNo("SUCCESS");
    }
    catch (const EyyErrorNo& e) {
        std::cout << e.what() <<
        std::endl ;
        result = 0;
    }
    catch (const EyyErrorExceptionE& e) {
        std::cout << "FAILURE." <<
        std::endl << e.what()   <<
        std::endl ;
        result = 1;
    }
    catch (const std::exception& e) {
        std::cout << "FAILURE." <<
        std::endl ;
        std::cout << "a standard exception was caught:" <<
        std::endl << e.what();
        result = 1;
    }
    catch (...) {
        std::cout << "FAILURE." <<
        std::endl ;
        std::cout << "unknown exception occurr." <<
        std::endl ;
        result = 1;
    }
    
    fclose(yyin);
    return result;
}
