(* 
 * This is a driver file for the homework. 
 *
 * Do not edit this file -- instead, edit hw1.ml.
 *)
open Printf

let main () = 
  let silent = ref false in 
  let args = [
    "--silent", Arg.Set silent, "do not display a prompt or reminder"
  ] in 
  Arg.parse args (fun _ -> ()) "" ; 

  if not !silent then begin 
    printf "Enter an IMP command (use . to end your command):\n" ;
    flush stdout ; 
  end ; 
  let lexbuf = Lexing.from_channel stdin in
  let imp_command = Parse.com Lex.initial lexbuf in
  if not !silent then begin 
    print_endline (Imp.find_include imp_command) ;
    print_endline (Imp.com_to_str imp_command) ; 
  end ; 
(*  let sigma_0 = Hw1.empty_state in 
  let sigma_n =
    try
      Hw1.eval_com imp_command sigma_0
    with Failure msg -> printf "%s" msg; sigma_0
  in
  ignore (sigma_n) ; 
  print_endline "" ; *)
  exit 0 
;;
main () ;;
