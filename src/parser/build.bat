flex  -o parser.lex.cc  -l parser.l
bison -o parser.tab.cc -vd parser.y

rem g++ -D_GLIBCXX_USE_CXX11_ABI=0 -std=c++14 -o parser.exe lexer.lex.c parser.tab.c -L/usr/lib -lfl -ly

g++ -std=c++17 -O2 -o parser.exe parser.lex.cc parser.tab.cc -LG:\msys64\usr\lib -lfl -ly
strip parser.exe