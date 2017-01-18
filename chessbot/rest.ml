open Types
open Lwt
open Wcs_message_t

let error default fmt = Log.error "Rest" default fmt

let message config req_msg =
  let username, password, workspace_id =
    (config.wcs_user, config.wcs_password, config.wcs_workspace_id)
  in
  let uri =
    Uri.of_string
      ("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/"^workspace_id^"/message?version=2016-07-11")
  in
  let headers =
    let h = Cohttp.Header.init () in
    let h = Cohttp.Header.add_authorization h (`Basic (username, password)) in
    let h = Cohttp.Header.add h "Content-Type" "application/json" in
    h
  in
  let msg = Wcs_message_j.string_of_message_request req_msg in
  let data = ((Cohttp.Body.of_string msg) :> Cohttp_lwt_body.t) in
  let call =
    Cohttp_lwt_unix.Client.post ~body:data ~headers uri >>= fun (resp, body) ->
      let code = resp |> Cohttp.Response.status |> Cohttp.Code.code_of_status in
      body |> Cohttp_lwt_body.to_string >|= fun body ->
        begin match code with
        | 200 -> body
        | _ -> error (Some "") (Format.sprintf "%d: %s" code body)
        end
  in
  let rsp = Lwt_main.run call in
  Format.eprintf "XXX %s XXX@." rsp;
  Wcs_message_j.message_response_of_string rsp
