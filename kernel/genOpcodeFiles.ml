(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *   INRIA, CNRS and contributors - Copyright 1999-2019       *)
(* <O___,, *       (see CREDITS file for the list of authors)           *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(** List of opcodes.

    It is used to generate the [coq_instruct.h], [coq_jumptbl.h] and
    [copcodes.ml] files.

    If adding an instruction, DON'T FORGET TO UPDATE coq_fix_code.c
    with the arity of the instruction and maybe coq_tcode_of_code.
*)
let opcodes =
  [|
    "ACC0";
    "ACC1";
    "ACC2";
    "ACC3";
    "ACC4";
    "ACC5";
    "ACC6";
    "ACC7";
    "ACC";
    "PUSH";
    "PUSHACC0";
    "PUSHACC1";
    "PUSHACC2";
    "PUSHACC3";
    "PUSHACC4";
    "PUSHACC5";
    "PUSHACC6";
    "PUSHACC7";
    "PUSHACC";
    "POP";
    "ENVACC1";
    "ENVACC2";
    "ENVACC3";
    "ENVACC4";
    "ENVACC";
    "PUSHENVACC1";
    "PUSHENVACC2";
    "PUSHENVACC3";
    "PUSHENVACC4";
    "PUSHENVACC";
    "PUSH_RETADDR";
    "APPLY";
    "APPLY1";
    "APPLY2";
    "APPLY3";
    "APPLY4";
    "APPTERM";
    "APPTERM1";
    "APPTERM2";
    "APPTERM3";
    "RETURN";
    "RESTART";
    "GRAB";
    "GRABREC";
    "CLOSURE";
    "CLOSUREREC";
    "CLOSURECOFIX";
    "OFFSETCLOSUREM2";
    "OFFSETCLOSURE0";
    "OFFSETCLOSURE2";
    "OFFSETCLOSURE";
    "PUSHOFFSETCLOSUREM2";
    "PUSHOFFSETCLOSURE0";
    "PUSHOFFSETCLOSURE2";
    "PUSHOFFSETCLOSURE";
    "GETGLOBAL";
    "PUSHGETGLOBAL";
    "MAKEBLOCK";
    "MAKEBLOCK1";
    "MAKEBLOCK2";
    "MAKEBLOCK3";
    "MAKEBLOCK4";
    "SWITCH";
    "PUSHFIELDS";
    "GETFIELD0";
    "GETFIELD1";
    "GETFIELD";
    "SETFIELD0";
    "SETFIELD1";
    "SETFIELD";
    "PROJ";
    "ENSURESTACKCAPACITY";
    "CONST0";
    "CONST1";
    "CONST2";
    "CONST3";
    "CONSTINT";
    "PUSHCONST0";
    "PUSHCONST1";
    "PUSHCONST2";
    "PUSHCONST3";
    "PUSHCONSTINT";
    "ACCUMULATE";
    "MAKESWITCHBLOCK";
    "MAKEACCU";
    "MAKEPROD";
    "BRANCH";
    "CHECKADDINT63";
    "ADDINT63";
    "CHECKADDCINT63";
    "CHECKADDCARRYCINT63";
    "CHECKSUBINT63";
    "SUBINT63";
    "CHECKSUBCINT63";
    "CHECKSUBCARRYCINT63";
    "CHECKMULINT63";
    "CHECKMULCINT63";
    "CHECKDIVINT63";
    "CHECKMODINT63";
    "CHECKDIVEUCLINT63";
    "CHECKDIV21INT63";
    "CHECKLXORINT63";
    "CHECKLORINT63";
    "CHECKLANDINT63";
    "CHECKLSLINT63";
    "CHECKLSRINT63";
    "CHECKADDMULDIVINT63";
    "CHECKLSLINT63CONST1";
    "CHECKLSRINT63CONST1";
    "CHECKEQINT63";
    "CHECKLTINT63";
    "LTINT63";
    "CHECKLEINT63";
    "LEINT63";
    "CHECKCOMPAREINT63";
    "CHECKHEAD0INT63";
    "CHECKTAIL0INT63";
    "ISINT";
    "AREINT2";
    "CHECKOPPFLOAT";
    "CHECKABSFLOAT";
    "CHECKCOMPAREFLOAT";
    "CHECKCLASSIFYFLOAT";
    "CHECKADDFLOAT";
    "CHECKSUBFLOAT";
    "CHECKMULFLOAT";
    "CHECKDIVFLOAT";
    "CHECKSQRTFLOAT";
    "CHECKFLOATOFINT63";
    "CHECKFLOATNORMFRMANTISSA";
    "CHECKFRSHIFTEXP";
    "CHECKLDSHIFTEXP";
    "CHECKNEXTUPFLOAT";
    "CHECKNEXTDOWNFLOAT";
    "STOP"
  |]

let pp_c_comment fmt =
  Format.fprintf fmt "/* %a */"

let pp_ocaml_comment fmt =
  Format.fprintf fmt "(* %a *)"

let pp_header isOcaml fmt =
  Format.fprintf fmt "%a"
    (fun fmt ->
       (if isOcaml then pp_ocaml_comment else pp_c_comment) fmt
         Format.pp_print_string)
    "DO NOT EDIT: automatically generated by kernel/genOpcodeFiles.ml"

let pp_with_commas fmt k =
  Array.iteri (fun n s ->
      Format.fprintf fmt "  %a%s@."
        k s
        (if n + 1 < Array.length opcodes
         then "," else "")
    ) opcodes

let pp_coq_instruct_h fmt =
  let line = Format.fprintf fmt "%s@." in
  pp_header false fmt;
  line "#pragma once";
  line "enum instructions {";
  pp_with_commas fmt Format.pp_print_string;
  line "};"

let pp_coq_jumptbl_h fmt =
  pp_with_commas fmt (fun fmt -> Format.fprintf fmt "&&coq_lbl_%s")

let pp_copcodes_ml fmt =
  pp_header true fmt;
  Array.iteri (fun n s ->
      Format.fprintf fmt "let op%s = %d@.@." s n
    ) opcodes

let usage () =
  Format.eprintf "usage: %s [enum|jump|copml]@." Sys.argv.(0);
  exit 1

let main () =
  match Sys.argv.(1) with
  | "enum" -> pp_coq_instruct_h Format.std_formatter
  | "jump" -> pp_coq_jumptbl_h Format.std_formatter
  | "copml" -> pp_copcodes_ml Format.std_formatter
  | _ -> usage ()
  | exception Invalid_argument _ -> usage ()

let () = main ()
