
context("All global calls")


test_that("including base functions", {

  src <- '
    f <- function() {
      utils::untar("foobar")
      stats::mad(1:10)
    }
  '
  f <- with_src(src, get_funcs_from_r_script(src))$f

  gc <- get_global_calls(f, "f")

  expect_equal(
    gc,
    data_frame(
      to = c("{", "::", "::", ":", "utils::untar", "stats::mad"),
      type = "call",
      line = c(2, 3, 4, 4, 3, 4),
      col1 = c(21, 12, 12, 19, 7, 7),
      col2 = c(21, 13, 13, 19, 18, 16)
    )
  )
})
