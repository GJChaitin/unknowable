######                                                                       ######
###### LISP INTERPRETER IN PYTHON3                                           ######
###### Implements the LISP used in Chaitin, The Unknowable, Springer, 1999   ######
###### a subset of the LISP used in Chaitin, The Limits of Mathematics, 1998 ######
###### Version dated Tuesday December 14, 2022                               ######
###### NO ERROR CHECKING!!! ASSUMES INPUT IS VALID LISP!!!                   ######
###### This greatly simplifies the Python3 code                              ######
######                                                                       ######

print("LISP Interpreter Run")
print("")


global tokens            # tokenized M-expression input to LISP interpreter
                         # [list of tokens for entire input file]          

global value             # dictionary giving values of atoms
value = {"nil":[]}       # nil is bound to empty list in initial dictionary


def eval(e):             # evaluate expression e, returns value of e
     global value
     if e == [] : return []             # empty list constant
     if isinstance(e, int) : return e   # integer constant
     if isinstance(e, str) :            # atom
          if e in value : 
               return (value[e])                 # look up value of atom
          else:
               return(e)                         # no value yields self 
     f = eval(e[0])                              # evalute function
     if isinstance(f,list) :                     # must be lambda expression
        p = f[1]                                 # list of parameters of function
#           f[2]                                 # body of function 
        v = e[1:]                                # list of function argument expressions  
        # replace argument expressions by argument values
        v = [eval(v[i]) for i in range(len(v))]  
        save_dictionary = {x:value[x] for x in value}   # copy dictionary
        for i in range(len(p)) :                 # bind
            value[p[i]] = v[i] 
        value_of_body = eval(f[2])               # evaluate body of function
        value = save_dictionary                  # unbind        
        return(value_of_body) 
     match f:
        case "quote":   return e[1]              # quote literal
        case "'":       return e[1]              # quote literal
        case "lambda" : return(e)                # lambda expression literal
        case "if" :                              # if 
           if eval(e[1]) == "true" :        
               return(eval(e[2]))                # then
           else:
               return(eval(e[3]))                # else
     # evaluate arguments of f 
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
 

def get_token() : # get next token from input
                  # [side-effect: eats up the list of tokens]
    global tokens
    save = tokens[0]
    tokens = tokens[1:] 
    return save 


def get_exp() : # get next M-expression from input and convert to S-expression
                # [side-effect: eats up the list of tokens]
    token = get_token()
    match token :
        case '"' :                             # switching to S-expression input?
             return get_exp2()      
        case "car" | "cdr" | "atom" |"quote" | "'" | "display" | "eval" | "length"| "size" :
             return [token, get_exp()]                        # has one argument
        case "*" | "-" | "=" | "<" | ">" |"<=" | ">=" | "cons" | "lambda" | "+" | "^" :
             return [token, get_exp(), get_exp()]             # has two arguments
        case "define" :
             return [token, get_exp(), get_exp()]
        case "if"  :
             return [token, get_exp(), get_exp(), get_exp()]  # has three arguments
        case "cadr"  :
             return ["car",["cdr", get_exp()]]                # expand macro
        case "caddr"  :
             return ["car",["cdr",["cdr",get_exp()]]]         # expand macro
        case "let"  :                                  
        # let (f x y z) be e1 in e2                           # expand macro
        # let f be e1 in e2
             f = get_exp()           
             e1 = get_exp()       
             e2 = get_exp() 
             if isinstance(f,list) :
                 return [["'",["lambda",[f[0]],e2]], ["'",["lambda",f[1:],e1]]]
             else:
                 return [["'",["lambda",[f],e2]], e1]
        case "("  :                                           # read list
             lst = []
             while True :
                 next = get_exp()
                 if next == ")" : 
                    return lst
                 lst += [next]
        case _:                                               # atom
             if token.isnumeric() :  
                return int(token)                             # convert token to number
             return token                                     # no conversion
                                                              # stays as string of characters
  

def get_exp2() :  # get S-expression from input 
    # no implicit parentheses, no macro expansion 
    # [side-effect: eats up the list of tokens]
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
 
 
def out(who,exp) : # output LISP expression
    print(who,end=" ")
    out2(exp)
    print("")
    return exp


def out2(exp) :    # recursive subroutine to output S-expression
    if exp == [] : 
        print("()",end="")              # print empty list
    else :
        if isinstance(exp,list) :       # print list
             print ("(",end="")         # begin list with (
             for i in range(len(exp)) :
                 out2(exp[i])           # print sublist
                 if i == len(exp) - 1 :
                     print (")",end="") # end list with )
                 else :
                     print(" ",end="")  # separate sublists with a single blank
        else :
             print(exp,end="")          # print atom


def size_it(exp) : # size in characters of LISP expression
    size_in_characters = 0
    if exp == [] :                
        return 2                                   # empty list
    else :
        if isinstance(exp,list) :                  # size of list
             size_in_characters += 1
             for i in range(len(exp)) :
                 size_in_characters += size_it(exp[i]) + 1
        else :
             size_in_characters += len(str(exp))   # size of atom
    return size_in_characters


def delimiters(string): # add blank space around delimiters so can tokenize at blanks
   newstring = ""       # returns a new, expanded character string
   open_comments = 0
   for i in range(len(string)) :
       match (string[i]) :             # eliminate [[[nested comments]]]
          case "["  :
             newstring += " "          # replace by blank
             open_comments += 1
             continue
          case "]"  :
             newstring += " "          # replace by blank
             open_comments -= 1
             continue
       if open_comments > 0 : 
          newstring += " "             # replace comment by blanks
          continue
       match (string[i]) :             # add blank space around delimiter?
          case "'" :
             newstring += " ' "        # ' delimiter
          case '"' :
             newstring += ' " '        # " delimiter
          case "(" :
             newstring += " ( "        # ( delimiter
          case ")" :
             newstring += " ) "        # ) delimiter
          case "\n" :                  
             newstring += " "          # replace new line character by blank
          case _ :
             newstring += string[i]    # retain character, no blank space to add
   return newstring

    
def define(exp) :                     # set value of atom "permanently"
    global value                      # cannot be done within an expression
                                      # only works at top level of read eval print loop
    # define (f x y z) to be e        # function definition
    # define f to be e                # define value of variable
    f = exp[1]
    e = exp[2]
    if isinstance(f,list) : 
        e = ["lambda",f[1:],e] 
        f = f[0]
    value[f] = e
    out("DEFN",f)
    out("VALU",e)
    print("")
    print("")
    

########################
#                      # 
# read eval print loop #
#                      # 
########################

import sys
input_string = sys.stdin.read()    # read the input all at once
print("MEXP input =")
print("")
print("")
print(input_string)                # echo input
print("")
print("")
                                           # add blanks around delimiters and
tokens = delimiters(input_string).split()  # tokenize input string at blanks
                                           # converts character string into list of tokens
while len(tokens) != 0 :
    exp = out("SEXP",get_exp())    # get next M-expression from input
                                   # [side-effect: eats up the list of tokens]
                                   # convert to S-expression and outputs
    if isinstance(exp,list) :
       if exp != [] :
          if exp[0] == "define" :  # is it a definition?
             define(exp)
             continue
    out("VALU",eval(exp))          # is it an expression to evaluate?
    print("")
    print("")
