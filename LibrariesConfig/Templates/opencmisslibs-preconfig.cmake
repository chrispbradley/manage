# Provides the necessary logic to preconfigure a program using an OpenCMISS library.
#

# Make sure we have a sufficient cmake version before doing anything else
cmake_minimum_required(VERSION @OPENCMISS_CMAKE_MIN_VERSION@ FATAL_ERROR)

# Compute the installation prefix relative to this file. It might be a mounted location or whatever.
get_filename_component(_OPENCMISS_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)

# Absolute path function
function(toAbsolutePaths LIST_VARNAME)
  set(RES )
  foreach(entry ${${LIST_VARNAME}})
    get_filename_component(abs_entry "${entry}" ABSOLUTE)
    list(APPEND RES "${abs_entry}")
  endforeach()
  set(${LIST_VARNAME} ${RES} PARENT_SCOPE)
endfunction()

# Append the OpenCMISS module path to the current module path
set(OPENCMISS_MODULE_PATH @OPENCMISS_MODULE_PATH_EXPORT@)
toAbsolutePaths(OPENCMISS_MODULE_PATH)
list(APPEND CMAKE_MODULE_PATH ${OPENCMISS_MODULE_PATH})

###########################################################################
# Set compilers in the preconfig using the toolchain mnemoic
#
if (DEFINED OPENCMISS_TOOLCHAIN)
  include(OCToolchainCompilers)
  setCMakeFullCompilersForToolchain(${OPENCMISS_TOOLCHAIN})
endif ()
