
#' @importFrom clisymbols symbol
#' @importFrom crayon yellow

mark_exported <- function(names, exp) {
  paste0(
    ifelse(
      names %in% exp,
      paste0(yellow(symbol$star), " "),
      "  "
    ),
    names
  )
}

print_graph <- function(x, ...) {

  ## Get adjacency list format
  data <- get_graph(x, only_me = FALSE)

  ## Only keep our own functions
  data <- data[ names(data) %in% functions(x) ]

  ## Sort them
  data <- data[ sort(names(data)) ]

  if (!is.null(x$exports)) {
    for (i in seq_along(data)) {
      data[[i]] <- mark_exported(data[[i]], x$exports)
    }
    names(data) <- mark_exported(names(data), x$exports)
  }

  lapply(names(data), function(n) {
    cat(" ", tail_style(n), " ", arrow(), sep = "")

    funcs <- head_style(sort(unique(data[[n]])))
    funcs <- paste(funcs, collapse = ",")
    funcs <- strwrap(funcs, indent = 1, exdent = 6)
    funcs <- paste(funcs, collapse = "\n")

    cat(funcs, "\n", sep = "")
  })
}

fill_line <- function(x, chr = "-", width = getOption("width", 80)) {
  len <- width - nchar(x, type = "width") - 4
  if (len <= 0) {
    x
  } else {
    paste0(
      paste0(rep(chr, len), collapse = ""),
      " ", x,
      " ", symbol$line, symbol$line
    )
  }
}

#' @importFrom crayon green bold
#' @importFrom clisymbols symbol

header_style <- function(x) {
  bold(green(fill_line(x, symbol$line)))
}

#' @importFrom crayon green

tail_style <- function(x) {
  green(x)
}

#' @importFrom crayon blue yellow

head_style <- function(x) {
  vapply(
    x, "",
    FUN = function(xx) {
      if (grepl("^\\..*::", xx)) {
        yellow(xx)
      } else if (grepl("::", xx)) {
        blue(xx)
      } else {
        xx
      }
    }
  )
}

#' @importFrom crayon yellow
#' @importFrom clisymbols symbol

arrow <- function(x) {
  yellow(symbol$pointer)
}

#' Print method for a function map object.
#'
#' The object can be the map of an R file, a folder containing
#' R files, or an R package. It prints an adjacency list, nicely
#' formatted.
#'
#' @param x Function map to print
#' @param ... Additional arguments, ignored currently.
#' @return Printed object, invisibly.
#'
#' @method print function_map
#' @export

print.function_map <- function(x, ...) {

  cat(header_style("Function map"), "\n", sep = "")

  print_graph(x, ...)

  invisible(x)
}

#' @rdname print.function_map
#' @inheritParams print.function_map
#' @return Printed object, invisibly.
#' 
#' @method print function_map_rfile
#' @export

print.function_map_rfile <- function(x, ...) {

  head <- paste0("Map of R script '", x$rfile, "'")
  cat(header_style(head), "\n", sep = "")

  print_graph(x, ...)

  invisible(x)
}

#' @inheritParams print.function_map
#' @return Printed object, invisibly.
#'
#' @rdname print.function_map
#' @method print function_map_rfolder
#' @export

print.function_map_rfolder <- function(x, ...) {

  head <- paste0("Map of R folder '", x$rpath, "'")
  cat(header_style(head), "\n", sep = "")

  print_graph(x, ...)

  invisible(x)
}

#' @inheritParams print.function_map
#' @return Printed object, invisibly.
#'
#' @rdname print.function_map
#' @method print function_map_rpackage
#' @export

print.function_map_rpackage <- function(x, ...) {

  head <- paste0("Map of R package '", x$package, "'")
  cat(header_style(head), "\n", sep = "")

  print_graph(x, ...)

  invisible(x)

}
