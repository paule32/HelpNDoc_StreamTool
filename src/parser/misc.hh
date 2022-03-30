// -------------------------------------------------------
// File: misc.hh
// Desc: parser for HelpNdoc.exe stream Tool 1.0
//
// Autor: Jens Kallup <kallup.jens@web.de>
// Copy : (c) 2022 by Jens Kallup
//
// only for private use !
// -------------------------------------------------------
#pragma once

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <strings.h>
#include <ctype.h>
#include <limits.h>
#include <sys/types.h>

#include <iostream>
#include <algorithm> 
#include <functional> 
#include <cctype>
#include <locale>

#include <stdexcept>
#include <exception>

#include <sstream>

#include <variant>
#include <vector>
#include <map>

#ifdef  YYDEBUG
inline constexpr int YYdebug = YYDEBUG;
#else
inline constexpr int YYdebug = 0;
#endif

//-- EXCEPTION HANDLERS ---------------------------------
class EyyErrorNo: public std::exception {
public:
    explicit EyyErrorNo(const char*        message) : msg_( message ) {}
    explicit EyyErrorNo(const std::string& message) : msg_( message ) {}
    virtual const char* what() const noexcept {
       return msg_.c_str();
    }
    virtual ~EyyErrorNo() noexcept {}
protected:
    std::string msg_;
};
class EyyErrorExceptionE: public std::exception {
    public:
    explicit EyyErrorExceptionE(const char*        message) : msg_( message ) {}
    explicit EyyErrorExceptionE(const std::string& message) : msg_( message ) {}
    virtual const char* what() const noexcept {
       return msg_.c_str();
    }
    virtual ~EyyErrorExceptionE() noexcept {}
protected:
    std::string msg_;
};

extern bool caseInsensitiveStringCompare( const std::string& str1, const std::string& str2 );

// trim from start
static inline std::string &ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(),
            std::not1(std::ptr_fun<int, int>(std::isspace))));
    return s;
}

// trim from end
static inline std::string &rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(),
            std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
    return s;
}

// trim from both ends
static inline std::string &trim(std::string &s) {
    return ltrim(rtrim(s));
}
