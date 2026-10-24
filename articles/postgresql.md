# PostgreSQL

## Schema generation

Write each oncoanalyser version’s tables, dump the schema, then merge by
hand.

- OA v1

``` r

dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "tidywigits",
  user = "user1"
)
oa <- Wigits$new("nogit/oa_v1")
oa$run(format = "db", input_id = "oa_run_v1", dbconn = dbconn)
DBI::dbDisconnect(dbconn)
```

``` shell
pg_dump --schema-only tidywigits > schema_oa_v1.txt
dropdb --force tidywigits
createdb tidywigits
```

- OA v2

``` r

dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "tidywigits",
  user = "user1"
)
oa <- Wigits$new("nogit/oa_v2")
oa$run(format = "db", input_id = "oa_run_v2", dbconn = dbconn)
DBI::dbDisconnect(dbconn)
```

``` shell
pg_dump --schema-only tidywigits > schema_oa_v2.txt
dropdb --force tidywigits
```

- Diff the two dumps and merge manually into
  `inst/database/postgresql/schema1.sql`.

## Database creation

``` shell
createdb tidywigits
psql tidywigits < inst/database/postgresql/schema1.sql
```

### Result

``` text
select * from pg_catalog.pg_tables where schemaname='public';
 schemaname │          tablename          │ tableowner │ tablespace │ hasindexes │ hasrules │ hastriggers │ rowsecurity
════════════╪═════════════════════════════╪════════════╪════════════╪════════════╪══════════╪═════════════╪═════════════
 public     │ amber_contaminationtsv      │ user       │ ¤          │ f          │ f        │ f           │ f
 public     │ alignments_dupfreq          │ user       │ ¤          │ f          │ f        │ f           │ f
 public     │ virusinterpreter_annotated  │ user       │ ¤          │ f          │ f        │ f           │ f
(X rows)
```
