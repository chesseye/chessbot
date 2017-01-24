let () =
  begin try
    while true do
      let line = input_line stdin in
      Format.printf "TEXT %s@." line
    done
  with End_of_file -> ()
  end
