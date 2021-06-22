%{
    //PROLOGUE
    #include <vector> //easy way for arrays
    #include <set> //keeping track of identifiers. no duplicates in set
    #include <iostream>
    #include <stack>
    //template <class Type, class Container = deque<Type> > class stack;
    //std::template<class T, class Container = deque<T>> class stack;
    struct word {
        std::string category;
        std::string lexeme;
    };
    std::vector<struct word> words;
    std::set<std::string> identifiers;
    std::stack<int> stack;
    bool error = false;
    void save_word(std::string lexeme, std::string category) {
        struct word word = {lexeme = lexeme, category = category };
        words.push_back(word);
    }
%}
%option yylineno
%option noyywrap
%%

%{
    //Goes at the top of yylex
    stack.push(0);
    int indent_level = 1;
%}
^\n {
    
}
\n {
    save_word("", "NEWLINE");
    REJECT;
}

^#.*\n {

}
[ ] {

}
\n[ \t]* {
    indent_level = yyleng/4;
    /* std::cout <<"yylineno: " << yylineno << std::endl;
    std::cout <<"   yyleng: " << yyleng << std::endl;
    std::cout << "  indent_level: " << indent_level <<std::endl; */
    if(indent_level > stack.top()) {
        stack.push(indent_level);
        save_word("", "INDENT");
    }
    else {
        while(stack.top() > indent_level) {
            stack.pop();
            save_word("", "DEDENT");
        }
    }

}


"True" {
    save_word(yytext, "BOOLEAN");
}
"False" {
    save_word(yytext, "BOOLEAN");
}
"and" {
    save_word(yytext, "AND");
}
"break" {
    save_word(yytext, "BREAK");
}
"def" {
    save_word(yytext, "DEF");
}
"elif" {
    save_word(yytext, "ELIF");
}
"else" {
    save_word(yytext, "ELSE");
}
"for" {
    save_word(yytext, "FOR");
}
"if" {
    save_word(yytext, "IF");
}
"not" {
    save_word(yytext, "NOT");
}
"or" {
    save_word(yytext, "OR");
}
"return" {
    save_word(yytext, "RETURN");
}
"while" {
    save_word(yytext, "WHILE");
}
"=" {
    save_word(yytext, "EQUALS");
}
"+" {
    save_word(yytext, "PLUS");
}
"-" {
    save_word(yytext, "MINUS");
}
"*" {
    save_word(yytext, "TIMES");
}
"/" {
    save_word(yytext, "DIVIDEBY");
}
"==" {
    save_word(yytext, "EQ");
}
"!=" {
    save_word(yytext, "NEQ");
}
">" {
    save_word(yytext, "GT");
}
">=" {
    save_word(yytext, "GTE");
}
"<" {
    save_word(yytext, "LT");
}
"<=" {
    save_word(yytext, "LTE");
}
":" {
    save_word(yytext, "COLON");
}
"(" {
    save_word(yytext, "LPAREN");
}
")" {
    save_word(yytext, "RPAREN");
}
"," {
    save_word(yytext, "COMMA");
}
[a-zA-Z_][a-zA-Z_$0-9]* { 
    save_word(yytext, "IDENTIFIER");
    identifiers.insert(yytext);
}
[0-9]*\.[0-9]+ {
    save_word((yytext), "FLOAT");
}
[0-9]* {
    save_word((yytext), "INTEGER");
}
<<EOF>> {
    if(error) {
        return 1;
    }
    return 0;
}

. {
    std::cerr << "Invalid symbol on line " << yylineno << ": " <<yytext << std::endl;
    error = true;
}

%%
int main() {
    if(!yylex()) {
        for(int i = 0; i < words.size(); i++) {
            if(words[i].category == "INTEGER") {
                std::cout << atoi(words[i].lexeme.c_str()) << "\t\t" << words[i].category << std::endl;
                
            }
            else if(words[i].category == "FLOAT") {
                std::cout << atof(words[i].lexeme.c_str()) << "\t\t" << words[i].category << std::endl;
            }
            else {
                std::cout << words[i].lexeme << "\t\t" << words[i].category << std::endl;
            }
        }
        if(!stack.empty()) {
            while(stack.top() > 0) {
                stack.pop();
                std::cout << "DEDENT" << std::endl;
            }
        }
    }
}