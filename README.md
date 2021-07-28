
## Scanner for a simplified Python using Flex


### Syntactic categories recognized

  * `IDENTIFIER` - An identifier must begin with an alphabetic character or an underscore and can then contain any number of alphanumeric characters and/or underscores, e.g. `foo`, `cat2`, `an_identifier`, `anotherIdentifier`.

  * `FLOAT` - A floating point number consists of zero or more numerical characters followed by a decimal point (i.e. `.`) followed by one or more numerical characters.  Examples are `3.1415`, `16.0`, `0.5`, `.66667`.  For this assignment, you only need to recognize *unsigned* floating point numbers (i.e. no negative numbers).  When a floating point number is recognized by your scanner, you should use a function like [`atof()`](https://www.cplusplus.com/reference/cstdlib/atof/) to parse it into a numerical value when printing it to `stdout`.

  * `INTEGER` - An integer consists of one or more numerical characters, e.g. `8`, `32`, `0`, `111`.  For this assignment, you only need to recognize *unsigned* integers (i.e. no negative numbers).  When an integer is recognized by your scanner, you should use a function like [`atoi()`](https://www.cplusplus.com/reference/cstdlib/atoi/) to parse it into a numerical value when printing it to `stdout`.

  * `BOOLEAN` - There are two boolean values in Python: `True` and `False`.  When a boolean value is recognized by your scanner, you should map it to either `1` or `0` or to a C++ `bool` value when printing it to `stdout`.

  * The following are keywords your scanner should recognize (along with the label of the corresponding syntactic category):
    * `AND` - The keyword `and`.
    * `BREAK` - The keyword `break`.
    * `DEF` - The keyword `def`.
    * `ELIF` - The keyword `elif`.
    * `ELSE` - The keyword `else`.
    * `FOR` - The keyword `for`.
    * `IF` - The keyword `if`.
    * `NOT` - The keyword `not`.
    * `OR` - The keyword `or`.
    * `RETURN` - The keyword `return`.
    * `WHILE` - The keyword `while`.

  * The following are operators your scanner should recognize (along with the label of the corresponding syntactic category):
    * `ASSIGN` - The operator `=`.
    * `PLUS` - The operator `+`.
    * `MINUS` - The operator `-`.
    * `TIMES` - The operator `*`.
    * `DIVIDEDBY` - The operator `/`.
    * `EQ` - The operator `==`.
    * `NEQ` - The operator `!=`.
    * `GT` - The operator `>`.
    * `GTE` - The operator `>=`.
    * `LT` - The operator `<`.
    * `LTE` - The operator `<=`.

  * The following are punctuation marks your scanner should recognize (along with the label of the corresponding syntactic category):
    * `LPAREN` - Left parenthesis `(`.
    * `RPAREN` - Right parenthesis `)`.
    * `COMMA` - Comma `,`.
    * `COLON` - Colon `:`.

  * `NEWLINE` - Python statements are delimited by newlines, so you must recognize newlines after statements.  For this assignment, you may assume that all statements span just a single line and are not broken over multiple lines (e.g. with backslashes).  When a newline is recognized, your scanner only needs to print a line containing the label `NEWLINE` without a value.

  * `INDENT` and `DEDENT` - In Python, indentation is used to group statements into blocks, so you must recognize when indentation increases and decreases.  See the next section for more on how this will work.  When indentation increases or decreases, your scanner only needs to print a line containing the corresponding label (i.e. `INDENT` or `DEDENT`) without a value.

## Handle indentation

In Python, indentation is used to group statements into blocks.  For example, all of the statements in an `if` block are indented one level further than the `if` statement itself, like below:
```python
if x > 0:
    a = 2
    b = 4
    c = 8
```
Such indentation is also used to group function bodies, loop bodies, etc., e.g.:
```python
def sum_to(n):
    s = 0
    i = 0
    while i < n:
        s = s + i
        i = i + 1

    return s
```
In the above example, note that the indentation level increases twice: once to indicate the body of the `sum_to()` function and a second time to indicate the body of the `while` loop.

Because of the way Python uses indentation, [it is not a context-free language](http://trevorjim.com/python-is-not-context-free/).  This makes things challenging if we hope to use a standard parser generator like [Bison](https://www.gnu.org/software/bison/) to create a parser for Python (which we will do in future assignments), since such parser generators generally operate only on context-free grammers.

Luckily, we can formulate our scanner in such a way as to allow us to use a context-free parser.  In particular, we can implement our scanner so that it keeps track of indentation levels in the code, emitting an `INDENT` token every time indentation increases a level and emitting a `DEDENT` token every time indentation decreases a level.  In essence, these `INDENT` and `DEDENT` tokens respectively play the same role as opening (`{`) and closing (`}`) braces in a language like C++, marking the beginning and end of a block of statements.

Your most challenging task in this assignment is to add rules to your scanner definition to keep track of indentation in the source code and to emit `INDENT` and `DEDENT` tokens when the indentation level changes.  This can be done using a stack, as described in the Python documentation:

https://docs.python.org/3/reference/lexical_analysis.html#indentation

For this assignment, you may treat spaces and tabs the same way, i.e. spaces and tabs can be used interchangeably for indentation in the source code and may even be combined in a single line of code.  In other words, for the purposes of this assignment, the following should all be considered as equivalent indentation:
  * 4 space characters
  * 4 tab characters
  * 2 space characters and 2 tab characters
  * 1 space, 1 tab, 1 space, and 1 tab
  * etc.

As an example of how this would work in practice, the code snippet at the beginning of this section containing the `if` statement should generate output like this when run through your scanner:
```
IF       if
...
COLON    :
NEWLINE
INDENT
...
INTEGER  8
NEWLINE
DEDENT
```

## 4. Implement a makefile to generate your scanner

Finally, you should create a makefile to generate an executable scanner from your definition.  You should write your scanner definition in a Flex file, e.g. `scanner.l`.  C++ library code containing a scanner generated from your definition can then be created like so:
```
flex -o scanner.cpp scanner.l
```
This will generate a C++ file named `scanner.cpp`, which will contain a scanning function with the following prototype:
```
void yylex();
```

The `yylex()` function will read source code from `stdin`.  To be able to run your scanner, you should write a simple application whose `main()` function calls `yylex()`.  If your main application is written in `main.cpp`, you can compile your executable scanner program like this:
```
g++ main.cpp scanner.cpp -o scan
```

Assuming you simply call `yylex()` in your `main()` function, you can pass source code into your scanner using input redirection in your terminal, e.g.:
```
./scan < p1.py
```

You should implement a makefile to perform the above compilation steps (i.e. running `flex` and `g++`) to generate an executable scanner that can be used as above.

## Testing

There are four simple Python programs you may use for testing your scanner included in the `testing_code/` directory.  Your scanner should be able to scan all of the syntax in each of these programs.  Example output for each program is provided in the `example_output/` directory.
