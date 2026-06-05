#' @title Wigits Object
#'
#' @description
#' WiGiTS file parsing and manipulation.
#' @examples
#' path <- system.file("extdata/oa", package = "tidywigits")
#' w <- Wigits$new(path)
#' dir1 <- tempdir()
#' #w$tidy()
#' #w$write(out_dir = dir1, format = "tsv", input_id = "input1", output_id = "out1")
#' x <- w$wrangle(out_dir = file.path(dir1, "out1"), format = "parquet", input_id = "run1")
#' #dbconn <- DBI::dbConnect(
#' #  drv = RPostgres::Postgres(),
#' #  dbname = "nemo",
#' #  user = "orcabus"
#' #)
#' #x <-
#' #  w$wrangle(
#' #    format = "db",
#' #    input_id = "runABC456",
#' #    dbconn = dbconn
#' #)
#' #DBI::dbDisconnect(dbconn)
#' @export
Wigits <- R6::R6Class(
  "Wigits",
  inherit = Workflow,
  public = list(
    #' @description Create a new Wigits object.
    #' @param path (`character(n)`)\cr
    #' Path(s) to Wigits results.
    initialize = function(path = NULL) {
      tools <- WIGITS_TOOLS
      super$initialize(
        name = "Wigits",
        path = path,
        tools = tools,
        metapkg = c("nemo", "tidywigits")
      )
    }
  ) # public end
)

#' WiGiTS Tools Supported
#'
#' List of all supported WiGiTS tools.
#'
#' @export
WIGITS_TOOLS <- list(
  alignments = Alignments,
  amber = Amber,
  bamtools = Bamtools,
  chord = Chord,
  cider = Cider,
  cobalt = Cobalt,
  cuppa = Cuppa,
  esvee = Esvee,
  isofox = Isofox,
  lilac = Lilac,
  linx = Linx,
  neo = Neo,
  peach = Peach,
  purple = Purple,
  sage = Sage,
  sigs = Sigs,
  teal = Teal,
  virusbreakend = Virusbreakend,
  virusinterpreter = Virusinterpreter
)
