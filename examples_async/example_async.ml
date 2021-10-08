(** Run this with [example.native --listen-prometheus=9090].
    View the metrics with:

    curl http://localhost:9090/metrics
   *)
open Core_kernel
open Async

module Metrics = struct
  open Prometheus_async

  let namespace = "MyProg"
  let subsystem = "main"

  let ticks_counted_total =
    let help = "Total number of ticks counted" in
    Counter.v ~help ~namespace ~subsystem "ticks_counted_total"
end

let counter () =
  print_endline "Tick!";
  Prometheus_async.Counter.inc_one Metrics.ticks_counted_total

let main () =
  every Time.Span.second counter;
  let%bind _server = Cohttp_async.Server.create
    ~on_handler_error:`Raise
    (Tcp.Where_to_listen.of_port 9090)
    Prometheus_app_async.Cohttp.callback
  in
  let%bind () = Deferred.never () in
  return ()

let () =
  let open Command.Let_syntax in
  Log.Global.set_level `Debug;
        Command.async
          ~summary:"Call the materialize endpoint"
          [%map_open
            let () = Log.Global.set_level_via_param () in
            fun () -> main ()]
  |> Command.run
