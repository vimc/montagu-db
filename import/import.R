source("R/common.R")
source("R/permissions.R")

con <- montagu_connection()
path <- "data"

import_common(con)

## 1. The permissions part; this is part of the database design and
## basically will not change I think.  The biggest difference is that
## the actual list of users will need changing.
import_permissions(con, path)
