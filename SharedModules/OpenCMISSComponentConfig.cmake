##
# <COMP>_SHARED
# -------------
#
# This flag determines if the specified component should be build as shared library rather than a static library.
# The default is :cmake:`NO` for all components except Iron and Zinc.
#
# .. default:: NO
foreach(COMPONENT ${OPENCMISS_COMPONENTS})
    set(_VALUE OFF)
    if (${COMPONENT} IN_LIST OPENCMISS_COMPONENTS_SHARED_BY_DEFAULT)
        set(_VALUE ON)
    endif()
    set(${COMPONENT}_SHARED ${_VALUE})  # "Build all libraries of ${COMPONENT} as shared"
endforeach()

##
# OC_COMPONENTS_SYSTEM
# --------------------
#
# Global setting to control use of system components. Possible values:
# 
#     :DEFAULT: Holds only for the components specified in OPENCMISS_COMPONENTS_SYSTEM_BY_DEFAULT (Config/Variables.cmake)
#     :NONE: The OpenCMISS build system exclusively builds components from its own repositories
#     :ALL: Enable search for any component on the system 
#
# .. default:: DEFAULT
set(OC_COMPONENTS_SYSTEM DEFAULT)

##
# OC_SYSTEM_<COMP>
# ----------------
#
# Many libraries are also available via the default operating system package managers or
# downloadable as precompiled binaries.
# This flag determines if the respective component may be searched for on the local machine, i.e. the local environment.
#
# As there are frequent incompatibilities with pre-installed packages due to mismatching versions, these flags can be set 
# to favor own component builds over consumption of local packages.
# 
# The search scripts for local packages (CMake: :cmake:`find_package` command and :path:`Find<COMP>.cmake` scripts)
# are partially unreliable; CMake is improving them continuously and we also try to keep our own written ones
# up-to-date and working on many platforms. This is another reason why the default policy is to
# rather build our own packages than tediously looking for binaries that might not even have the
# right version and/or components.
#
# See also: OC_COMPONENTS_SYSTEM_ and the :cmake:`OPENCMISS_COMPONENTS_SYSTEM_BY_DEFAULT` variable in :path:`<manage>/SharedModules/OCVariables.cmake`.
#
# .. default:: OPENCMISS_COMPONENTS_SYSTEM_BY_DEFAULT
foreach(COMPONENT ${OPENCMISS_COMPONENTS})
    # Look for some components on the system first before building
    set(_VALUE OFF)
    if (${COMPONENT} IN_LIST OPENCMISS_COMPONENTS_SYSTEM_BY_DEFAULT)
        set(_VALUE ON)
    endif()
    # All local enabled? Set to local search.
    if (OC_COMPONENTS_SYSTEM STREQUAL NONE)
        set(OC_SYSTEM_${COMPONENT_NAME} OFF)
    elseif (OC_COMPONENTS_SYSTEM STREQUAL ALL)
        set(OC_SYSTEM_${COMPONENT_NAME} ON)
    endif ()
    # Set all individual components build types to shared if the global BUILD_SHARED_LIBS is set
    set(OC_SYSTEM_${COMPONENT} ${_VALUE})  # "Allow ${COMPONENT} to be used from local environment/system"
    unset(_VALUE)
endforeach()

##
# OC_USE_<COMP>
# -------------
#
# For every OpenCMISS component, this flag determines if the respective component is to be used by the build environment.
# This means it's searched for at configuration stage and built if not found.
#
# The list of possible components can be found in the :cmake:`OPENCMISS_COMPONENTS` variable in :path:`<manage>/Config/Variables.cmake`.
#
# .. caution::
#    There is no advanced logic implemented to check if a custom selection of components breaks the overall build - e.g.
#    if you disable OC_USE_LIBXML2 and there is no LibXML2 installed on your system, other components requiring LIBXML2 will
#    not build correctly.
#
# See also OC_SYSTEM_<COMP>_ and the :cmake:`OPENCMISS_COMPONENTS_DISABLED_BY_DEFAULT` variable in :path:`<manage>/Config/Variables.cmake`.
foreach(COMPONENT ${OPENCMISS_COMPONENTS})
    set(_VALUE ON)
    if (${COMPONENT} IN_LIST OPENCMISS_COMPONENTS_DISABLED_BY_DEFAULT)
        set(_VALUE OFF)
    endif()
    # Use everything but the components in OPENCMISS_COMPONENTS_DISABLED_BY_DEFAULT
    set(OC_USE_${COMPONENT} ${_VALUE})  # "Enable use/build of ${COMPONENT}"
    unset(_VALUE)
endforeach()

##
# OPENCMISS_DEPENDENCIES_ONLY
# ---------------------------
#
# If you want to compile the dependencies for iron/zinc only, enable this setting.
# This flag is useful for setting up sdk installations or continuous integration builds.
#
# .. caution::
#     You can also disable building Iron or Zinc using the component variables, e.g. OC_USE_IRON=NO.
#     However, this is considered a special top-level flag, which also causes any components that are
#     exclusively required by e.g. Iron will not be build.
#
# See also OC_USE_<COMP>_
#
# .. default:: NO
if (NOT DEFINED OPENCMISS_DEPENDENCIES_ONLY)
    set(OPENCMISS_DEPENDENCIES_ONLY NO)  # "Build dependencies only (no Iron or Zinc)"
endif ()

##
# OPENCMISS_LIBRARIES_ONLY
# ------------------------
#
# If you want to compile only iron or zinc, enable this setting.  The dependencies will not be built
# with this option set.
#
# See also OC_USE_<COMP>_
#
if (NOT DEFINED OPENCMISS_LIBRARIES_ONLY)
    set(OPENCMISS_LIBRARIES_ONLY NO)  # "Build only Iron or Zinc (no dependencies)"
endif ()
