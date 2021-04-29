let successful = ref 0
let failed = ref 0

let count_requests inner_handler request =
  try%lwt
    let%lwt response = inner_handler request in
    successful := !successful + 1;
    Lwt.return response

  with exn ->
    failed := !failed + 1;
    raise exn


let () =
  Dream.run
  @@ Dream.logger
  @@ count_requests
  @@ Dream.router [

    Dream.get "/"
      (fun _ ->
        Dream.html "Good morning, world!");

    Dream.get "/echo/:word"
      (fun request ->
        Dream.html (Dream.param "word" request));

    Dream.get "/count"
      (fun _ ->
        Dream.html (Printf.sprintf "Count 
        %3i success(s)!
        %3i failed(s)!" !successful !failed));

    Dream.post "/" Create.post;

  ]
  @@ Dream.not_found
