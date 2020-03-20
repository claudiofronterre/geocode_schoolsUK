# LOAD REQUIRED PACKAGES AND FUNCTIONS -----------------------------------------
if (!require("pacman")) install.packages("pacman")
pkgs = c("package1", "package2") # package names
pacman::p_load(pkgs, character.only = T)

source("R/functions.R")

# LOAD DATA --------------------------------------------------------------------


# DATA PREPARATION -------------------------------------------------------------

