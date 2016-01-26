dotR <- file.path(Sys.getenv("HOME"), ".R")
if (!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, "Makevars")
if (!file.exists(M)) file.create(M)
cat("\nCXXFLAGS=-O3 -Wno-unused-variable -Wno-unused-function -Wno-unused-local-typedefs", 
    file = M, sep = "\n", append = TRUE)
cat("\nCXXFLAGS+=-flto -ffat-lto-objects", 
    file = M, sep = "\n", append = TRUE)
