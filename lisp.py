print("LISP Interpreter Run")
print("")


global value             # dictionary giving lists of values of atoms
value = {"nil":[[]]}     # nil is bound to empty list in initial dictionary


def eval(e):
     global value
     if isinstance(e, int) : return e   # integer constant
     if isinstance(e, str) :            # atom
          if e in value :
               if value[e] == [] :
                    return(e)                    # no value yields self
               else:
                    return (value[e])[0]         # look up first value of atom
          else:
               return(e)                         # no value yields self
     f = eval(e[0])                              # evalute function
     if isinstance(f,list) :                     # lambda expression
        body = f[2]
        variable = f[1]                          # list of parameters of lambda expression
        argument = e[1:]                         # list of arguments of lambda expression
        # list of values of arguments of lambda expression
        argument_value = [eval(argument[i]) for i in range(len(argument))]
        for i in range(len(variable)) :          # bind
            if variable[i] in value :            # save previous values
                value[variable[i]] = [argument_value[i]] + value[variable[i]]
            else :
                value[variable[i]] = [argument_value[i]]  # no previous values to save
        valueofbody = eval(body)
        for i in range(len(variable)) :          # unbind
            value[variable[i]] = (value[variable[i]])[1:] # remove first value in list of values
        return(valueofbody)
     if f == "quote": return e[1]                # quote literal
     if f == "'": return e[1]                    # quote literal
     if f == "lambda" : return(e)                # lambda expression literal
     if f == "if" :                              # if
         if eval(e[1]) == "true" :
             return(eval(e[2]))                  # then
         else:
             return(eval(e[3]))                  # else
     x = eval(e[1])
     if len(e) == 3: y = eval(e[2])
     match f:
        case "eval" :                            # eval
            save_values = value                  # save bindings
            value = {"nil":[[]]}                 # initial bindings
            save_value = eval(x)                 # evaluate argument
            value = save_values                  # restore bindings
            return save_value                    # return value
        case "display" :                         # display
            out("DISPLAY",x)
            return(x)                            # identity function
        case "length" :                          # length
            return(len(x))
        case "size" :                            # size
            return(size_it(x))
        case "+" :                               # plus
            return(x + y)
        case "-" :                               # minus
            if y <= x :
              return(x - y)
            else :
              return(0)
        case "*" :                               # times
            return(x * y)
        case "^" :                               # exponentiation
            return(x ** y)
        case "=" :                               # = predicate
            if x == y :
               return("true")
            else:
               return("false")
        case "<" :                               # < predicate
            if x < y :
               return("true")
            else:
               return("false")
        case "<=" :                              # <= predicate
            if x <= y :
               return("true")
            else:
               return("false")
        case ">" :                               # > predicate
            if x > y :
               return("true")
            else:
               return("false")
        case ">=" :                              # >= predicate
            if x >= y :
               return("true")
            else:
               return("false")
        case "atom" :                            # atom predicate
            if x == [] :
               return("true")
            if isinstance(x,list):
               return("false")
            else:
               return("true")
        case "car":                              # car
            return x[0]
        case "cdr" :                             # cdr
            return x[1:]
        case "cons"  :                           # cons
            return [x] +  y


def get_token() :
    global tokens
    save = tokens[0]
    tokens = tokens[1:]
    return save


def get_exp() : # get M-expression
    token = get_token()
    match token :
        case '"' :
             return get_exp2()
        case "car" | "cdr" | "atom" |"quote" | "'" | "display" | "eval" | "length"| "size" :
             return [token, get_exp()]
        case "*" | "-" | "=" | "<" | ">" |"<=" | ">=" | "cons" | "lambda" | "+" | "^" | "define"  :
             return [token, get_exp(), get_exp()]
        case "if"  :
             return [token, get_exp(), get_exp(), get_exp()]
        case "cadr"  :
             return ["car",["cdr", get_exp()]]
        case "caddr"  :
             return ["car",["cdr",["cdr",get_exp()]]]
        # let x be e1 in e2
        # let (f x) be e1 in e2
        case "let"  :
             function = get_exp()
             if isinstance(function,list) :
                 function_name = function[0]
                 function_arguments = function[1:]
                 body_of_function = get_exp()
                 expression_to_evaluate = get_exp()
                 return [["'",["lambda",[function_name],expression_to_evaluate]],
                         ["'",["lambda",function_arguments,body_of_function]]]
             else:
                 body_of_function = get_exp()
                 expression_to_evaluate = get_exp()
                 return [["'",["lambda",[function],expression_to_evaluate]],body_of_function]
        case "("  :
             lst = []
             while True :
                 next = get_exp()
                 if next == ")" :
                    return lst
                 else :
                    lst = lst + [next]
        case _:
             if token.isnumeric() :
                return int(token)
             return token


def get_exp2() :  # get S-expression
    token = get_token()
    match token :
        case "("  :
             lst = []
             while True :
                 next = get_exp2()
                 if next == ")" :
                    return lst
                 else :
                    lst = lst + [next]
        case _:
             if token.isnumeric() :
                return int(token)
             return token


def out(who,exp) :
    print(who,end=" ")
    out2(exp)
    print("")
    return exp


def out2(exp) :
    if exp == [] :
        print("()",end="")
    else :
        if isinstance(exp,list) :
             print ("(",end="")
             for i in range(len(exp)) :
                 out2(exp[i])
                 if i == len(exp) - 1 :
                     print (")",end="")
                 else :
                     print(" ",end="")
        else :
             print(exp,end="")


def size_it(exp) :
    size_in_characters = 0
    if exp == [] :
        return 2
    else :
        if isinstance(exp,list) :
             size_in_characters = size_in_characters + 1
             for i in range(len(exp)) :
                 size_in_characters = size_in_characters + size_it(exp[i]) + 1
        else :
             size_in_characters = size_in_characters + len(str(exp))
    return size_in_characters


def delimiters(string):
   newstring = ""
   i = 0
   while True :
       match (string[i]) :
          case "["  :
             open_comments = 1
             while open_comments != 0 :
                 i = i + 1
                 if string[i] == "]" :
                    open_comments = open_comments - 1
                 if string[i] == "[" :
                    open_comments = open_comments + 1
          case "'" :
             newstring = newstring + " ' "
          case '"' :
             newstring = newstring + ' " '
          case "(" :
             newstring = newstring + " ( "
          case ")" :
             newstring = newstring + " ) "
          case "\n" :
             newstring = newstring + " "
          case _ :
             newstring = newstring + string[i]
       i = i + 1
       if i == len(string) :
             return newstring


def define(exp) :
    global value
    symbol = exp[1]
    definition = exp[2]
    if isinstance(symbol,list) :
        definition = ["lambda",symbol[1:],definition]
        symbol = symbol[0]
    value[symbol] = [definition]
    out("DEFINE",symbol)
    out("VALUE",definition)
    print("")


#
# read eval print loop
#

import sys
input_string = sys.stdin.read()
print("echo input= ")
print("")
print(input_string)
tokens = delimiters(input_string).split()
while len(tokens) != 0 :
    exp = out("SEXP",get_exp())
    if isinstance(exp,list) :
       if exp[0] == "define" :
          define(exp)
          continue
    out("VALUE",eval(exp))
    print("")
