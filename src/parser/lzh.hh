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

class HelpNDocAPI_LZXstate {
public:
    HelpNDocAPI_LZXstate() { }
   ~HelpNDocAPI_LZXstate() { }
   
    decompressBlock(
        unsigned char * inpos ,
        unsigned char * outpos,
        int input_len ,
        int output_len) ;
};
