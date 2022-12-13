######                                                                       ######
###### LISP Interpreter in Python3                                           ######
###### Implements the LISP used in Chaitin, The Unknowable, Springer, 1999   ######
###### a subset of the LISP used in Chaitin, The Limits of Mathematics, 1998 ######
###### Version dated Tuesday December 13, 2022                               ######
######                                                                       ######

print("LISP Interpreter Run")
print("")


global value             # dictionary giving values of atoms
value = {"nil":[]}       # nil is bound to empty list in initial dictionary


def eval(e):
     global value
     if isinstance(e, int) : return e   # integer constant
     if isinstance(e, str) :            # atom
          if e in value :
               return (value[e])                 # look up value of atom
          else:
               return(e)                         # no value yields self
     f = eval(e[0])                              # evalute function
     if isinstance(f,list) :                     # lambda expression
        body = f[2]
        variable = f[1]                          # list of parameters of lambda expression
        argument = e[1:]                         # list of arguments of lambda expression
        # list of values of arguments of lambda expression
        argument_value = [eval(argument[i]) for i in range(len(argument))]
        save_dictionary = {x:value[x] for x in value}   # copy dictionary
        for i in range(len(variable)) :          # bind
            value[variable[i]] = argument_value[i]
        valueofbody = eval(body)
        value = save_dictionary                  # unbind
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
            save_dictionary = {x:value[x] for x in value}          # save bindings
            value = {"nil":[]}                   # initial bindings
            save_value = eval(x)                 # evaluate argument
            value = save_dictionary              # restore bindings
            return save_value                    # return value
        case "display" :                         # display
            out("DSPL",x)
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
        case "*" | "-" | "=" | "<" | ">" |"<=" | ">=" | "cons" | "lambda" | "+" | "^" :
             return [token, get_exp(), get_exp()]
        case "define" :
             return [token, get_exp(), get_exp()]
        case "if"  :
             return [token, get_exp(), get_exp(), get_exp()]
        case "cadr"  :
             return ["car",["cdr", get_exp()]]
        case "caddr"  :
             return ["car",["cdr",["cdr",get_exp()]]]
        case "let"  :
        # let (f x y z) be e1 in e2
        # let f be e1 in e2
             f = get_exp()
             e1 = get_exp()
             e2 = get_exp()
             if isinstance(f,list) :
                 return [["'",["lambda",[f[0]],e2]], ["'",["lambda",f[1:],e1]]]
             else:
                 return [["'",["lambda",[f],e2]], e1]
        case "("  :
             lst = []
             while True :
                 next = get_exp()
                 if next == ")" :
                    return lst
                 lst += [next]
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
                 lst += [next]
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
             size_in_characters += 1
             for i in range(len(exp)) :
                 size_in_characters += size_it(exp[i]) + 1
        else :
             size_in_characters += len(str(exp))
    return size_in_characters


def delimiters(string):
   newstring = ""
   open_comments = 0
   for i in range(len(string)) :
       match (string[i]) :
          case "["  :
             open_comments += 1
             continue
          case "]"  :
             open_comments -= 1
             continue
       if open_comments > 0 :
          continue
       match (string[i]) :
          case "'" :
             newstring += " ' "
          case '"' :
             newstring += ' " '
          case "(" :
             newstring += " ( "
          case ")" :
             newstring += " ) "
          case "\n" :
             newstring += " "
          case _ :
             newstring += string[i]
   return newstring


def define(exp) :
    global value
    symbol = exp[1]
    definition = exp[2]
    if isinstance(symbol,list) :
        definition = ["lambda",symbol[1:],definition]
        symbol = symbol[0]
    value[symbol] = definition
    out("DEFN",symbol)
    out("VALU",definition)
    print("")
    print("")


#
# read eval print loop
#

import sys
input_string = sys.stdin.read()
print("MEXP input =")
print("")
print("")
print(input_string)
print("")
print("")
tokens = delimiters(input_string).split()
while len(tokens) != 0 :
    exp = out("SEXP",get_exp())
    if isinstance(exp,list) :
       if exp[0] == "define" :
          define(exp)
          continue
    out("VALU",eval(exp))
    print("")
    print("")
