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

//-- HEADER IMPLEMENTATIONS ------------------------------
#include "misc.hh"

//-- FORWARD/EXTERN DECLARATIONS -------------------------
int yylex(); 
int yywrap() { return 1; }

extern int yyerror(const char*);

static std::stringstream myss;
static std::stringstream _page_ss;
static std::string       _page_name;
static std::string       _indent("    ");
static                        std::vector< std::string >   _page ;
static std::map< std::string, std::vector< std::string > > _pages;

// -------------------------------------------------
// stream out the _page data of the _pages map ...
// -------------------------------------------------
std::ostream& operator<<(std::ostream& os, std::vector< std::string >& li)
{
    for (const std::string& item : li)
    std::cout << item <<
    std::endl ;
    return os ;
}
%}

//-- SYMBOL SEMANTIC VALUES -----------------------------
%union {
  uint64_t    val_int64;
  char*       val_charp;
  char*       val_string;
};

%start program
//-- GRAMMAR RULES ---------------------------------------

%token <val_int64>  TOK_NUMBER

%token <val_string> TOK_ID
%token <val_string> TOK_CHAP
%token <val_string> TOK_CHAPSUB
%token <val_string> TOK_STRING

%%

program
    : /* empty */
    | program stmts {
        std::string cOc;
        std::cout << "begin" <<
        std::endl ;

        _indent.clear();
        _indent.append("    ");

        for (auto const& pd : _pages) {
            cOc.clear();
            cOc.append(_indent);
            
            if (caseInsensitiveStringCompare(pd.first,"@mainpage") == true) {
                cOc.append("mainpage;");
            }   else {
                cOc.append(pd.first);
            }
            
            std::cout << cOc <<
            std::endl ;
        }

        std::cout << "end."  <<
        std::endl <<
        std::endl ;
    }
    ;
    
stmts
    : mainpage
    ;

mainpage
    : TOK_CHAP {
        if (caseInsensitiveStringCompare($1,"@mainpage") == true) {
            _page_name = "@mainpage";
            
            _page_ss.str("");
            _page_ss << "procedure mainpage;" << std::endl;
            _page_ss << "begin"               << std::endl;
        }
        else {
            yyerror("expect @mainpage");
        }
    }
    chap_sub TOK_CHAP {
        if (caseInsensitiveStringCompare($4,"@end") == true) {
            _page_ss << "end;" ;
            _page.push_back(_page_ss.str());
            _pages[ _page_name ] = _page;
            
            std::cout << _pages[ _page_name ] << std::endl;
        }
        else {
            yyerror("expect @end");
        }
    }
    ;

chap_sub
    : TOK_CHAPSUB TOK_STRING {
        // replace " with '
        std::string qu($2);
        qu[ 0 ]           = '\'';
        qu[ qu.size()-1 ] = '\'';
        
        // clear
        myss.str(std::string(""));
        myss << "HndProjects.";
        
        _indent.clear();
        _indent.append("    ");
        _indent.append(myss.str());
        
        if (caseInsensitiveStringCompare($1, "\\settitle"     ) == true) { _page_ss << _indent << "SetProjectTitle("     << qu << ");"; goto scan1; } else
        if (caseInsensitiveStringCompare($1, "\\setauthor"    ) == true) { _page_ss << _indent << "SetProjectAuthor("    << qu << ");"; goto scan1; } else
        if (caseInsensitiveStringCompare($1, "\\setversion"   ) == true) { _page_ss << _indent << "SetProjectVersion("   << qu << ");"; goto scan1; } else
        if (caseInsensitiveStringCompare($1, "\\setcopyright" ) == true) { _page_ss << _indent << "SetProjectCopyright(" << qu << ");"; goto scan1; } else
        if (caseInsensitiveStringCompare($1, "\\setsummary"   ) == true) { _page_ss << _indent << "SetProjectSummary("   << qu << ");"; goto scan1; } else
        if (caseInsensitiveStringCompare($1, "\\setcomment"   ) == true) { _page_ss << _indent << "SetProjectComment("   << qu << ");"; goto scan1; }

        // clear
        myss.str(std::string(""));
        myss      << "expect:" <<
        std::endl << "  \\setAutor, \\setCopyright, \\setSummary, \\setTitle, \\setVersion." <<
        std::endl << "  \\getAutor, \\getCopyright, \\getSummary, \\getTitle, \\getVersion." <<
        std::endl ;
        
        yyerror(myss.str().c_str());
        scan1:
        _page_ss << std::endl;
    }
    | TOK_CHAPSUB TOK_ID {
        if (caseInsensitiveStringCompare($1, "\\gettitle"     ) == true) { _page_ss << _indent << $2 << " := GetProjectTitle;"    ; goto scan2; } else
        if (caseInsensitiveStringCompare($1, "\\getauthor"    ) == true) { _page_ss << _indent << $2 << " := GetProjectAuthor;"   ; goto scan2; } else
        if (caseInsensitiveStringCompare($1, "\\getversion"   ) == true) { _page_ss << _indent << $2 << " := GetProjectVersion;"  ; goto scan2; } else
        if (caseInsensitiveStringCompare($1, "\\getcopyright" ) == true) { _page_ss << _indent << $2 << " := GetProjectCopyright;"; goto scan2; } else
        if (caseInsensitiveStringCompare($1, "\\getsummary"   ) == true) { _page_ss << _indent << $2 << " := GetProjectSummary;"  ; goto scan2; } else
        if (caseInsensitiveStringCompare($1, "\\getcomment"   ) == true) { _page_ss << _indent << $2 << " := GetProjectComment;"  ; goto scan2; }
        
        // clear
        myss.str(std::string(""));
        myss      << "expect:" <<
        std::endl << "  \\setAutor, \\setCopyright, \\setSummary, \\setTitle, \\setVersion." <<
        std::endl << "  \\getAutor, \\getCopyright, \\getSummary, \\getTitle, \\getVersion." <<
        std::endl ;
        
        yyerror(myss.str().c_str());
        scan2:
        _page_ss << std::endl;
    }
    | chap_sub chap_sub
    | chap_sub
    ;

%%
