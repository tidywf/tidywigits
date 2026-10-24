#' WiGiTS S3 Sync Excludes
#'
#' Trailing `--exclude` globs applied after the schema-derived includes when
#' syncing a WiGiTS run (see [s3sync()]). `aws s3 sync` filters are ordered and
#' last-match wins, so these carve files back out of the includes.
#'
#' @export
WIGITS_SYNC_EXCLUDE <- c(
  "*.esvee.prep.fragment_length.tsv",
  "*.esvee.prep.disc_stats.tsv",
  "*.esvee.prep.junction.tsv",
  "*.esvee.phased_assembly.tsv",
  "*.esvee.assembly.tsv",
  "*.esvee.breakend.tsv",
  "*.esvee.alignment.tsv"
)

#' @title Wigits Object
#'
#' @description
#' WiGiTS file parsing and manipulation.
#' @examples
#' path <- system.file("extdata/oa", package = "tidywigits")
#' w <- Wigits$new(path)
#' x <- w$run(output_dir = file.path(tempdir(), "out1"), format = "parquet", input_id = "run1")
#' @include Alignments.R Amber.R Bamtools.R Chord.R Cider.R Cobalt.R Cuppa.R
#' @include Esvee.R Isofox.R Lilac.R Linx.R Neo.R Peach.R Purple.R Qsee.R
#' @include Sage.R Sigs.R Teal.R Virusbreakend.R Virusinterpreter.R
#' @export
Wigits <- R6::R6Class(
  "Wigits",
  cloneable = FALSE,
  inherit = Workflow,
  public = list(
    #' @field sync_exclude (`character(n)`)\cr
    #' Trailing `aws s3 sync` excludes, see [WIGITS_SYNC_EXCLUDE].
    sync_exclude = WIGITS_SYNC_EXCLUDE,
    #' @description Create a new Wigits object.
    #' @param path (`character(n)`)\cr
    #' Path(s) to Wigits results.
    initialize = function(path = NULL) {
      super$initialize(
        name = "Wigits",
        path = path,
        tools = WIGITS_TOOLS,
        metapkg = c("nemo", "tidywigits")
      )
    }
  )
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
  qsee = Qsee,
  sage = Sage,
  sigs = Sigs,
  teal = Teal,
  virusbreakend = Virusbreakend,
  virusinterpreter = Virusinterpreter
)

#' WiGiTS Tool Colours
#'
#' CSS colours for WiGiTS tools, used for the tool pills in
#' [nemo::nemo_schema_reactable()]. Other tools fall back to grey.
#'
#' @export
WIGITS_TOOL_COLOURS <- c(
  alignments = "#6366f1", # indigo
  amber = "#ffbf00",
  bamtools = "#0ea5e9", # sky
  chord = "#dc143c", # crimson
  cider = "#b5651d",
  cobalt = "#0047ab",
  cuppa = "#10b981", # emerald (green tea)
  esvee = "#ec4899", # hot pink
  isofox = "#f97316", # fox orange
  lilac = "#c8a2c8",
  linx = "#eab308", # gold (lynx eyes)
  neo = "#84cc16", # neon lime
  peach = "#ffb07c",
  purple = "#8e44ad",
  qsee = "#06b6d4", # cyan
  sage = "#87a96b",
  sigs = "#f43f5e", # rose
  teal = "#008080",
  virusbreakend = "#7c3aed", # violet
  virusinterpreter = "#22c55e" # toxic green
)
