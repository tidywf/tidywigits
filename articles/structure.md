# Structure

Each WiGiTS tool has a single `schema.yaml` under
`inst/config/tools/<tool>/`. See
<https://tidywf.github.io/nemo/articles/structure.html> for a
walkthrough of the `Tool`/`Workflow`/`Config` class structure and schema
contents.

## Fan-out

Some files split into several output tables, declared under `outputs` in
their tool’s `schema.yaml` and written as `<prefix>_<tool>_<output>`:

| Tool     | File table   | Outputs                                             |
|:---------|:-------------|:----------------------------------------------------|
| bamtools | `wgsmetrics` | `wgsmetricsmain`, `wgsmetricsdp`, `wgsmetricshisto` |
| bamtools | `summary`    | `summarymain`, `summarydp`                          |
| bamtools | `exoncvg`    | `exoncvgmain`, `exoncvgperc`                        |
| bamtools | `genecvg`    | `genecvgmain`, `genecvgcvg`                         |
| cobalt   | `gcmed`      | `gcmedmain`, `gcmedbuckets`                         |
| sage     | `genecvg`    | `genecvgmain`, `genecvgcvg`                         |
