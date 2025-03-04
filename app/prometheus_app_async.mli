(** Report metrics for Prometheus.
    See: https://prometheus.io/

    Notes:

    - This module is intended to be used by applications that export Prometheus metrics.
      Libraries should only link against the `Prometheus` module.

    - This module automatically initialises itself and registers some standard collectors relating to
      GC statistics, as recommended by Prometheus.

    - This module does not depend on [Unix], and so can be used in unikernels.
 *)

module TextFormat_0_0_4 : sig
  val output : Prometheus_async.CollectorRegistry.snapshot Fmt.t
end
(** Format a snapshot in Prometheus's text format, version 0.0.4. *)

module Cohttp : sig
  val callback :
    body:Cohttp_async.Body.t -> 'a ->
    Cohttp.Request.t -> Cohttp_async.Server.response Async.Deferred.t
end
(** A Cohttp callback for a web-server that exposes the Prometheus metrics. *)
