(** User Mathematica initialization file **)

(* polynomial depression (generalization of completing the square)
from http://mathematica.stackexchange.com/a/23059 *)
Depress[poly_] := Depress[poly, First@Variables[poly]]
Depress[poly_, x_] /; PolynomialQ[poly, x] := Module[{n = Exponent[poly, x], x0},
        x0 = -Coefficient[poly, x, n - 1]/(n Coefficient[poly, x, n]);
                Normal[Series[poly, {x, x0, n}]]]
