// %GROUP Sexp


// Lisp Interpreter in Java, G J Chaitin, 27 Dec 99

// To compile the interpreter, type
//    javac lisp.java


import java.applet.*;
import java.awt.*;
import java.awt.event.*;

import java.util.Stack;
import java.math.BigInteger;

public class lisp extends Applet implements ActionListener {

TextArea  mexp, dspl;
Button    evl_button, clr_button;
Checkbox  echo_chkbx;

    private long
    infinity = 999999999999999999L;
    private String buffer = null;
    private int pos;

    private Sexp
    obj_lst = null,
    nil = mk_atom(""), // create impossible atom for empty list ()
    nil2 = mk_atom("nil"), // alternate name for empty list ()
    true2 = mk_atom("true"), // create true
    false2 = mk_atom("false"), // create false
    one = new Sexp(BigInteger.valueOf(1)),
    zero = new Sexp(BigInteger.valueOf(0)),
    quote = mk_atom("'"),
    dbl_quote = mk_atom("\""),
    if_then_else = mk_atom("if"),
    lambda = mk_atom("lambda"),
    rparen = mk_atom(")"), // create right paren
    lparen = mk_atom("("), // create left paren
    time_err = mk_atom("impossible atom 1"), // create impossible atom for error return
    data_err = mk_atom("impossible atom 2"), // create impossible atom for error return
    out_of_time = mk_atom("out-of-time"),
    out_of_data = mk_atom("out-of-data"),
    let = mk_atom("let"),
    car = mk_atom("car"),
    cdr = mk_atom("cdr"),
    cadr = mk_atom("cadr"),
    caddr = mk_atom("caddr"),
    atom = mk_atom("atom"),
    cons = mk_atom("cons"),
    equal = mk_atom("="),
    fappend = mk_atom("append"),
    feval = mk_atom("eval"),
    ftry = mk_atom("try"),
    debug = mk_atom("debug"),
    size = mk_atom("size"),
    length = mk_atom("length"),
    display = mk_atom("display"),
    read_bit = mk_atom("read-bit"),
    read_exp = mk_atom("read-exp"),
    was_read = mk_atom("was-read"), // New! Undocumented!
    run_utm_on = mk_atom("run-utm-on"), // New! Undocumented!
    bits = mk_atom("bits"),
    plus = mk_atom("+"),
    times = mk_atom("*"),
    minus = mk_atom("-"),
    to_the_power = mk_atom("^"),
    leq = mk_atom("<="),
    geq = mk_atom(">="),
    lt = mk_atom("<"),
    gt = mk_atom(">"),
    success = mk_atom("success"),
    failure = mk_atom("failure"),
    no_time_limit = mk_atom("no-time-limit"),
    base10_to_2 = mk_atom("base10-to-2"),
    base2_to_10 = mk_atom("base2-to-10"),
    define = mk_atom("define");

    private Stack binary_data_stk   = new Stack();
    private Sexp  binary_data_lst   = nil;
    private Stack was_read_stk      = new Stack();
    private Sexp  was_read_lst      = nil;
    private Stack was_displayed_stk = new Stack();
    private Sexp  was_displayed_lst = nil;

    public void init() {

       evl_button = new Button("Run");
       evl_button.setBackground(Color.white);
       clr_button = new Button("Clear");
       clr_button.setBackground(Color.white);
       echo_chkbx = new Checkbox("Echo");
       echo_chkbx.setBackground(Color.white);
       mexp = new TextArea("Enter M-expressions here, hit Run", 10, 80);
       dspl = new TextArea("All output is here", 10, 80);
       setFont(new Font("Monospaced", Font.PLAIN, 12));
       add(evl_button);
       add(clr_button);
       add(mexp);
       add(echo_chkbx);
       add(dspl);
       evl_button.addActionListener(this);
       clr_button.addActionListener(this);

         time_err.err = true; // create impossible atom for error return
         data_err.err = true; // create impossible atom for error return

         // bind nil to ()
         nil2.vstk.pop();
         nil2.vstk.push(nil);

   } // end init

   public void actionPerformed(ActionEvent evt) {
          Button source = (Button)evt.getSource();
          if (source.getLabel().equals("Clear")) {
             mexp.setText("");
             return;
          }
          evl_button.setBackground(Color.red);
          dspl.setText("");
          run();
          evl_button.setBackground(Color.white);
   } // end actionPerformed


   private Sexp jn(Sexp x, Sexp y) {
         if (y.at && y != nil) return x;
         return new Sexp(x,y);
   }

   private Sexp mk_atom(String x) {
         Sexp o = obj_lst;
         while (o != null) {
            if (o.hd.pname.equals(x)) return o.hd;
            o = o.tl;
         }
         Sexp z = new Sexp(x);
         obj_lst = new Sexp(z,obj_lst);
         return z;
   }

// concatenate two lists
private Sexp append(Sexp x, Sexp y) {
   if (x.at) return y;
   if (y.at) return x;
   x = reverse(x);
   while (!x.at) {
      y = jn(x.hd,y);
      x = x.tl;
   }
   return y;
}

// evaluate list of expressions
private Sexp evalst(Sexp x, long d) {
   if (x.at) return nil;
   Sexp v = eval(x.hd,d);
   if (v.err) return v; // propagate error back up
   Sexp w = evalst(x.tl,d);
   if (w.err) return w; // propagate error back up
   return jn(v,w);
}

// push fresh bindings
private void push_env() {
   Sexp o = obj_lst;
   while (o != null) {
      o.hd.vstk.push(o.hd); // bind atom to self
      o = o.tl;
   }
   // bind nil to ()
   nil2.vstk.pop();
   nil2.vstk.push(nil);
}

// restore old bindings
private void pop_env() {
   Sexp o = obj_lst;
   while (o != null) {
      o.hd.vstk.pop();
      if (o.hd.vstk.empty())
      o.hd.vstk.push(o.hd); // bind atom to self
      o = o.tl;
   }
}

// evaluate expression e with assoc list a & depth limit d
private Sexp eval(Sexp e, long d) {
   if (e.at) return (Sexp) e.vstk.peek(); // look up binding
   Sexp f = eval(e.hd,d); // evaluate the function
   if (f.err) return f; // propagate error back up
   if (f == quote) return e.two(); // quote
   if (f == if_then_else) { // if then else
      Sexp p = eval(e.two(),d); // eval predicate
      if (p.err) return p; // propagate error back up
      if (p == false2) return eval(e.four(),d);
      return eval(e.three(),d); // anything not false considered true
   }
   // evaluate the arguments
   Sexp args = evalst(e.tl,d);
   if (args.err) return args; // propagate error back up
   Sexp x = args.hd, y = args.two(); // pick up first and second arg
   Sexp z = args.three(); // pick up third arg
   Sexp v;

   if (f == debug) {
         out("debug",x.toS());
         return x;
   } // end of debug

   if (f == size) return new Sexp(BigInteger.valueOf(x.toS().length()));

   if (f == length) return new Sexp(BigInteger.valueOf(count(x)));

   if (f == display) {
         if (was_displayed_stk.empty())
            out("display",x.toS());
         else
            was_displayed_lst = jn(x,was_displayed_lst);
         return x;
   } // end of display

   if (f == read_bit) return get_bit();

   if (f == read_exp) {
         // read to \n from binary data
         if (new_line2()) return data_err; // out of data ?
         v = get_exp("()"); // only parens are delimiters, no comments
         if (v == rparen) v = nil; // make sure it's a well-formed formula
         return v;
   } // end of read-exp

   if (f == was_read) return reverse(was_read_lst);

   if (f == bits) return to_bits(x);

   if (f == atom) if (x.at) return true2; else return false2;

   if (f == car)  return x.hd;

   if (f == cdr)  return x.tl;

   if (f == cons) return jn(x,y);

   if (f == equal) if (eq(x,y)) return true2; else return false2;

   if (f == fappend) return append(x,y);

   if (f == plus) return new Sexp(x.nval.add(y.nval));

   if (f == minus) return new Sexp(BigInteger.valueOf(0).max(x.nval.subtract(y.nval)));

   if (f == times) return new Sexp(x.nval.multiply(y.nval));

   if (f == leq) if (x.nval.compareTo(y.nval) != 1) return true2; else return false2;

   if (f == lt) if (x.nval.compareTo(y.nval) == -1) return true2; else return false2;

   if (f == geq) if (x.nval.compareTo(y.nval) != -1) return true2; else return false2;

   if (f == gt) if (x.nval.compareTo(y.nval) == 1) return true2; else return false2;

   if (f == to_the_power) return new Sexp(x.nval.pow(y.nval.intValue())); //wrong if y very large!

   if (f == base10_to_2) return to_base2(x.nval);

   if (f == base2_to_10) return new Sexp(to_base10(x));

   if (d == 0) return time_err;  // out of time error
   d = d - 1L; // decrement depth

   if (f == feval) {
         push_env();
         v = eval(x,d);
         pop_env();
         return v;
   } // end of eval

   if (f == ftry) {
         // try new-depth-limit exp binary-data
         binary_data_stk.push(binary_data_lst);
         binary_data_lst = z;
         was_read_stk.push(was_read_lst);
         was_read_lst = nil;
         was_displayed_stk.push(was_displayed_lst);
         was_displayed_lst = nil;
         // xx is new depth limit
         long xx = x.nval.longValue();
         if (x.nval.compareTo(BigInteger.valueOf(infinity)) == 1) xx = infinity;
         if (x == no_time_limit) xx = infinity;
         push_env();
         if (xx < d) // new depth limit tougher
            v = eval(y,xx);
         else       // old depth limit wins
            v = eval(y,d);
         pop_env();
         Sexp displayed = reverse(was_displayed_lst);
         binary_data_lst = (Sexp) binary_data_stk.pop();
         was_read_lst = (Sexp) was_read_stk.pop();
         was_displayed_lst = (Sexp) was_displayed_stk.pop();
         if (v == data_err) return
            jn(failure,jn(out_of_data,jn(displayed,nil))); // out of data stops here
         if (v != time_err) return
            jn(success,jn(v,jn(displayed,nil))); // no error
         // out of time
         if (xx < d) return // new depth limit tougher
            jn(failure,jn(out_of_time,jn(displayed,nil))); // do not propagate error back up
         else       // old depth limit wins
            return time_err; // propagate error back up to prev try
   } // end of try

   // otherwise must be function definition
         Sexp vars = f.two(), body = f.three();
         //  bind
         bind(vars,args);
         v = eval(body,d);
         // unbind
         unbind(vars);
         return v;

} // end of eval

private void bind(Sexp vars, Sexp args) {
   if (vars.at) return;
   bind(vars.tl, args.tl);
   if (vars.hd.at && !vars.hd.nmb)
   vars.hd.vstk.push(args.hd);
}

private void unbind(Sexp vars) {
   if (vars.at) return;
   if (vars.hd.at && !vars.hd.nmb)
   vars.hd.vstk.pop();
   unbind(vars.tl);
}

private long count(Sexp x) {
   long k = 0;
   while (!x.at) {
      k = k + 1L;
      x = x.tl;
   }
   return k;
}

private Sexp reverse(Sexp list) {
   Sexp v = nil;
   while (!list.at) {
      v = jn(list.hd,v);
      list = list.tl;
   }
   return v;
}

private boolean eq(Sexp x, Sexp y) {
   if (x.nmb && y.nmb) return x.nval.equals(y.nval);
   if (x.nmb || y.nmb) return false;
   if (x.at && y.at) return x == y;
   if (x.at || y.at) return false;
   return eq(x.hd,y.hd) && eq(x.tl,y.tl);
}

private Sexp get_lst() { // get list of s-exps from m-exp
   Sexp v = get();
   if (v == rparen) return nil;
   Sexp w = get_lst();
   return jn(v,w);
}

private String next_token2(String delimiters) { // skip comments
   while (true) {
      String t = next_token(delimiters); // get next token
      if (delimiters.indexOf('[') == -1) return t; // no comments
      if (!t.equals("[")) return t;
      // skip comment
      while (true) {
         t = next_token2(delimiters);
         if (t.equals("]")) break;
         // keep this from running past the end!
         if (pos == buffer.length() && t.equals(")")) return t;
      }
   }
} // end next_token2

private Sexp get() { // get single s-exp from m-exp
   // get next token; parens, brackets, quotes are delimiters
   String t = next_token2("()[]\'\""); // comments allowed
   Sexp a = null;
   if (!nval(t))
     a = mk_atom(t); // make token into atom
   else
     a = new Sexp(new BigInteger(t)); // make number

   if (a == lparen) return get_lst(); // explicit list

   // primitive functions with no arguments
   if (a == read_bit ||
       a == read_exp ||
       a == was_read) return jn(a,nil);

   // primitive function with one argument
   if (a == dbl_quote) // S-exp contained in M-exp !
       return get_exp("()[]\'\"");
       // parens, brackets, quotes are delimiters; comments allowed

   // primitive functions with one argument
   if (a == quote ||
       a == atom ||
       a == car ||
       a == cdr ||
       a == display ||
       a == debug ||
       a == size ||
       a == length ||
       a == base10_to_2 ||
       a == base2_to_10 ||
       a == feval ||
       a == bits) return jn(a,jn(get(),nil));

   // primitive functions with two arguments
   if (a == cons ||
       a == equal ||
       a == plus ||
       a == minus ||
       a == times ||
       a == to_the_power ||
       a == leq ||
       a == geq ||
       a == lt ||
       a == gt ||
       a == define ||
       a == fappend ||
       a == lambda) return jn(a,jn(get(),jn(get(),nil)));

   // primitive functions with three arguments
   if (a == if_then_else ||
       a == ftry) return jn(a,jn(get(),jn(get(),jn(get(),nil))));

   if (a == run_utm_on) { // cadr try no-time-limit 'eval read-exp
      Sexp v = get();
      v = jn(ftry,
          jn(no_time_limit,
          jn(jn(quote,
             jn(jn(feval,
                jn(jn(read_exp,nil),
                   nil)),
                nil)),
          jn(v,
             nil))));
      v = jn(cdr,jn(v,nil));
      v = jn(car,jn(v,nil));
      return v;
   }

   if (a == cadr) { // car of cdr
      Sexp v = get();
      v = jn(cdr,jn(v,nil));
      v = jn(car,jn(v,nil));
      return v;
   }

   if (a == caddr) { // car of cdr of cdr
      Sexp v = get();
      v = jn(cdr,jn(v,nil));
      v = jn(cdr,jn(v,nil));
      v = jn(car,jn(v,nil));
      return v;
   }

   if (a == let) { // let x be v in e
         Sexp x = get(), v = get(), e = get();
         if (!x.at) {
            v = jn(quote,
                jn(jn(lambda,
                   jn(x.tl,
                   jn(v,nil))), nil));
            x = x.hd;
         }
         // let (fxyz) be v in e
         return
         jn(jn(quote,
            jn(jn(lambda,
               jn(jn(x,nil),
               jn(e,nil))), nil)),
         jn(v,nil));
   } // end of let

   return a;

} // end get mexp

private boolean nval(String s) {
   int i = 0;
   while (i < s.length()) {
      char d = s.charAt(i);
      if (d < '0' || d > '9') return false;
      i = i + 1;
   }
   return true;
}

private BigInteger to_base10(Sexp s) {
   BigInteger n = BigInteger.valueOf(0);
   while (!s.at) {
      n = n.shiftLeft(1);
      if (!s.hd.pname.equals("0")) n = n.setBit(0);
      s = s.tl;
   }
   return n;
}

private Sexp to_base2(BigInteger n) {
   Sexp s = nil;
   while (!n.equals(BigInteger.valueOf(0))) {
      if (n.testBit(0))
         s = jn(one,s);
      else
         s = jn(zero,s);
      n = n.shiftRight(1);
   }
   return s;
}

private void new_line() { // read M-exp & add \n
   buffer = mexp.getText().concat("\n");
   pos = 0;
}

private boolean new_line2() { // read to \n from binary data
   StringBuffer str = new StringBuffer();
   int i;
   char ch;
   while (true) {
      i = get_char();
      if (i == -1) return true; // data exhausted
      ch = (char) i;
      str.append(ch);
      if (ch == '\n') break;
   }
   buffer = str.toString();
   pos = 0;
   return false; // data not exhausted
}

private String next_token(String delimiters) { // token from line buffer
   StringBuffer token = new StringBuffer();
   while (true) { // get characters in token
      char ch;
      if (pos == buffer.length()) ch = ')'; // supply unlimited!
      else ch = buffer.charAt(pos++);
      echo.append(ch);
      // keep only \n or printable ascii codes
      if (ch != 10 && (ch < 32 || ch >= 127)) continue;
      boolean is_delimiter = (delimiters.indexOf(ch) != -1);
      boolean is_white_space = (ch == ' ' || ch == '\n');
      boolean is_white_space_or_delimiter = (is_white_space || is_delimiter);
      if (token.length() == 0) { // token buffer empty
         if (is_white_space) continue;
         token.append(ch);
         if (is_delimiter) break;
      } // end token buffer empty
      else { // token buffer not empty
         if (!is_white_space_or_delimiter) token.append(ch);
         if (is_delimiter) {
            pos = pos - 1; // so we rescan it again next time
            echo.setLength(echo.length()-1);
         }
         if (is_white_space_or_delimiter) break;
      } // end token buffer not empty
   } // end get characters in token
   return token.toString();
} // end of next_token

StringBuffer echo; // used to accumulate one M-exp

private void run() { // run M-expressions

  new_line();

  int mexp_count = 0;
  while (true) { // loop thru M-exps

  echo = new StringBuffer();
  Sexp s = get();

  if (s == rparen && pos == buffer.length()) return; // ran off end
  if (mexp_count++ > 0) dspl.append("\n");

  String xxx = echo.toString();
  while (xxx.endsWith("\n")) xxx = xxx.substring(0,xxx.length()-1);
  while (xxx.startsWith("\n")) xxx = xxx.substring(1);
  if (echo_chkbx.getState()) dspl.append(xxx+"\n\n");

  if (s.bad()) {
     out("expression",s.toS());
     out("value","syntax error!");
     continue;
  } // end of bad syntax

  if (s.hd == define) {
    // define x to have value v
    // if x is (fxyz) defines f to have value &(xyz)v
    Sexp x = s.two();
    Sexp v = s.three();
    if (!x.at) {v = jn(lambda,jn(x.tl,jn(v,nil))); x = x.hd;}
    out("define",x.toS());
    out("value",v.toS());
    if (x.at && !x.nmb) {
       x.vstk.pop();
       x.vstk.push(v);
     }
     continue;
  } // end of definition

  // evaluate expression s
  out("expression",s.toS());
  String save_buffer; int save_pos; // evaling read-exp clobbers buffer, pos
  save_buffer = buffer; save_pos = pos;
  Sexp v = eval(s,infinity); // "infinite" depth limit
  buffer = save_buffer; pos = save_pos;
  if (v == data_err)
     out("value","out of data!");
  else
     out("value",v.toS());

  } // run each mexp

} // end of run

private Sexp get_bit() { // read bit from binary data
   if (binary_data_lst.at) return data_err; // out of data
   Sexp v = binary_data_lst.hd;
   binary_data_lst = binary_data_lst.tl;
   // anything not zero considered one
   if (!v.pname.equals("0")) v = one;
   was_read_lst = jn(v,was_read_lst);
   return v;
}

private Sexp to_bits(Sexp x) { // convert S-exp to bit string
    String str = x.toS().concat("\n");
    Sexp v = nil;
    int i = str.length();
    while (i > 0) {
       i = i - 1;
       int j = ((int) str.charAt(i)) % 256;
       int k = 0;
       while (k < 8) {
          if ((j % 2) != 0) v = jn(one,v);
          else              v = jn(zero,v);
          j = j >>> 1;
          k = k + 1;
       }
    }
    return v;
}

private int get_char() { // read character from binary data
  int k, v;
  k = 0; v = 0;
  while (k < 8) {
     Sexp b = get_bit();
     if (b.err) return -1; // out of data
     v = v << 1;
     if (b == one) v = v + 1;
     k = k + 1;
  }
  return v;
}

private Sexp get_list(String delimiters) { // get list of s-exps from binary data or m-exp
   Sexp v = get_exp(delimiters);
   if (v == rparen) return nil;
   Sexp w = get_list(delimiters);
   return jn(v,w);
}

private Sexp get_exp(String delimiters) { // get single s-exp from binary data or m-exp
   String t = next_token2(delimiters);
   Sexp a = null;
   if (!nval(t))
      a = mk_atom(t); // make token into atom
   else
      a = new Sexp(new BigInteger(t)); // make number
   if (a == lparen) return get_list(delimiters); // explicit list
   return a;
} // end get sexp

private void out(String xx, String yy) {
  String x = new String(xx);
  String y = new String(yy);
  while (y.length() > 0) {
       String left, right;
       left = (x + "            ").substring(0,12);
       if (y.length() <= 50) {right = y; y = "";}
                       else  {right = y.substring(0,50); y = y.substring(50);}
       dspl.append(left + right + "\n");
       x = "";
  }
} // end output routine

} // end lisp applet
