let full_html_of content = Printf.sprintf {|<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="utf8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdn.simplecss.org/simple.css">
  </head>
  <body>
    %s
  </body>
  <hr />
  <a href="/~me/">Yajima Soichi</a>
</html>
|} content

let full_html_of_md md =
  md |> Omd.of_string |> Omd.to_html |> full_html_of

let is_markdown : string -> bool = fun filename ->
  let len = String.length filename in
  if len < 3 then
    false
  else
    match filename.[len - 3], filename.[len - 2], filename.[len - 1] with
    | '.', 'm', 'd' -> true
    | _, _, _ -> false

let to_html_filename : string -> string = fun markdown_filename ->
  (Filename.chop_extension markdown_filename) ^ ".html"

(** [cp ~src_path ~dist_path] copies [src_path] to [dist_path]. *)
let cp ~(src_path:string) ~(dist_path:string) =
  let ic = open_in src_path in
  let s = ref "" in
  try
    while true do
      s := !s ^ (input_line ic) ^ "\n"
    done
  with End_of_file -> close_in ic;
  let oc = open_out dist_path in
  Printf.fprintf oc "%s" !s;
  close_out oc

(** [convert_md_to_html ~src_path ~dist_path] converts
    [src_path] markdown file to [dist_path] html file. *)
let convert_md_to_html ~(src_path:string) ~(dist_path:string) =
  let ic = open_in src_path in
  let s = ref "" in
  try
    while true do
      s := !s ^ (input_line ic) ^ "\n"
    done
  with End_of_file -> close_in ic;
  let html_content = full_html_of_md !s in
  let oc = open_out dist_path in
  Printf.fprintf oc "%s" html_content;
  close_out oc

let rec gensite ~(src_path:string) ~(dist_path:string) =
  let stats = Unix.stat src_path in
  match stats.st_kind with
  | S_DIR -> begin
      if not (Sys.file_exists dist_path) then
        Unix.mkdir dist_path 0o755;
      Sys.readdir src_path
      |> Array.iter begin fun filename ->
           let src_path = Filename.concat src_path filename in
           if is_markdown filename then
             let dist_name = to_html_filename filename in
             let dist_path = Filename.concat dist_path dist_name in
             gensite ~src_path ~dist_path
           else
             let dist_path = Filename.concat dist_path filename in
             gensite ~src_path ~dist_path
         end
    end
  | S_REG -> begin
      if is_markdown src_path then
        convert_md_to_html ~src_path ~dist_path
      else
        cp ~src_path ~dist_path
    end
  | _ -> failwith "Not implemented"

let () =
  gensite ~src_path:"./site_src" ~dist_path:"./dist"

