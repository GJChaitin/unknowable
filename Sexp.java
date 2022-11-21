import java.util.Stack;
import java.math.BigInteger;

class Sexp { // class of S-expressions

   public Sexp hd = null, tl = null;
   public boolean at, nmb, err = false;
   public String pname = null;
   public BigInteger nval = null;
   public Stack vstk = null;
   private StringBuffer str = null;

   public Sexp(Sexp h, Sexp t) { // first creation method
      at = false;
      nmb = false;
      hd = h; tl = t;
      pname = new String("");
      nval = BigInteger.valueOf(0);
      vstk = null;
   } // end normal Sexp creation

   public Sexp(String s) { // second creation method
      at = true;
      nmb = false;
      pname = new String(s);
      nval = BigInteger.valueOf(0);
      hd = this; // hd & tl of atom is atom
      tl = this;
      vstk = new Stack();
      vstk.push(this); // atom bound to self initially
   } // end atom creation

   public Sexp(BigInteger n) { // third creation method
      at = true;
      nmb = true;
      nval = n;
      pname = n.toString();
      hd = this; // hd & tl of atom is atom
      tl = this;
      vstk = new Stack();
      vstk.push(this); // binding will never change
   } // end number creation

   public Sexp two() { return this.tl.hd; }
   public Sexp three() { return this.tl.tl.hd; }
   public Sexp four() { return this.tl.tl.tl.hd; }

   public boolean bad() { // test for well-formed formula
      if (at) return pname.equals(")");
      return hd.bad() || tl.bad();
   } // end wff check

   public String toS() { // Convert Sexp to String
      str = new StringBuffer();
      toS2(this);
      String str2 = str.toString();
      str = null;
      return str2;
   } // toS

   private void toS2(Sexp x) { // print it
      if (x.at && !x.pname.equals("")) { // pname "" is nil !
         str.append(x.pname);
         return;
      }
      str.append('(');
      while (!x.at) {
         toS2(x.hd);
         x = x.tl;
         if (!x.at)
         str.append(' ');
      }
      str.append(')');
   } // toS2

} // end Sexp class
