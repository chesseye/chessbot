open Wcs_message_t

let wcs wcs_user wcs_password wcs_workspace_id (inputv: string) =
  let req_msg =
    { req_input = { cin_text = inputv };
      req_alternate_intents = false;
      req_context = None;
      req_entities = None;
      req_intents = None;
      req_output = None; }
  in
  let resp =
    Rest.message wcs_user wcs_password wcs_workspace_id req_msg
  in
  resp


let main () =
  let conf = Config.init () in
  Format.printf "Welcome to chess bot@.";
  let wcs =
    let open Config in
    wcs conf.wcs_user conf.wcs_password conf.wcs_workspace_id
  in
  let resp = wcs "coucou" in
  Format.printf "RESP = %s" (Wcs_message_j.string_of_message_response resp)


let () = main ()
