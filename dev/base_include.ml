
(* File to include to get some Coq facilities under the ocaml toplevel.
   This file is loaded by include.ml *)

(* We only assume that the variable COQTOP is set *)
let src_dir =
  let coqtop = try Sys.getenv "COQTOP" with Not_found -> "." in
  let coqtop = 
    if Sys.file_exists coqtop then 
      coqtop
    else begin
      print_endline ("Cannot find the sources in "^coqtop);
      print_string "Where are they ? ";
      read_line ()
    end 
  in
  let add_dir dl = 
    Topdirs.dir_directory (List.fold_left Filename.concat "" dl) 
  in
  List.iter add_dir
    [ [ "config" ]; [ "dev" ]; [ "lib" ]; [ "kernel" ]; [ "library" ]; 
      [ "pretyping" ]; [ "parsing" ]; [ "proofs" ]; [ "tactics" ];
      [ "toplevel" ] ];
  coqtop
;;
(* Now Coq_config.cmi is accessible *)
Topdirs.dir_directory Coq_config.camlp4lib;;

#use "top_printers.ml";;

#install_printer  (* identifier *) prid;;
#install_printer  (* section_path *)  prsp;;

(* parsing of terms *)

let parse_com   = Pcoq.parse_string Pcoq.Command.command;;
let parse_tac = Pcoq.parse_string Pcoq.Tactic.tactic;;

(* For compatibility reasons *)
let parse_ast = parse_com;;

(* build a term of type constr without type-checking or resolution of 
   implicit syntax *)

let raw_constr_of_string s = 
  Astterm.dbize_cci Evd.empty (unitize_env (Global.context()))
    (parse_ast s);;

let e s    = 
   constr_of_com Evd.empty (Global.env()) (parse_ast s);;

(* Get the current goal *)

let getgoal x = top_goal_of_pftreestate (get_pftreestate x);;

let get_nth_goal n = nth_goal_of_pftreestate n (get_pftreestate ());;
let current_goal () = get_nth_goal 1;;

let pf_e gl s = 
    constr_of_com (project gl) (pf_env gl) (parse_ast s);;
