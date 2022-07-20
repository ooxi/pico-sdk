# build the auto gen config headers

set(header_content "// AUTOGENERATED FROM PICO_CONFIG_HEADER_FILES and then PICO_<PLATFORM>_CONFIG_HEADER_FILES\n// DO NOT EDIT!\n")
string(TOUPPER ${PICO_PLATFORM} PICO_PLATFORM_UPPER)

macro(add_header_content_from_var VAR)
    set(header_content "${header_content}\n\n// based on ${VAR}:\n")
    foreach(var IN LISTS ${VAR})
        set(header_content "${header_content}\n#include \"${var}\"")
    endforeach()
endmacro()

# PICO_CMAKE_CONFIG: PICO_CONFIG_HEADER_FILES, List of extra header files to include from pico/config.h for all platforms, type=list, default="", group=pico_base
add_header_content_from_var(PICO_CONFIG_HEADER_FILES)

# PICO_CMAKE_CONFIG: PICO_CONFIG_RP2040_HEADER_FILES, List of extra header files to include from pico/config.h for rp2040 platform, type=list, default="", group=pico_base
# PICO_CMAKE_CONFIG: PICO_CONFIG_HOST_HEADER_FILES, List of extra header files to include from pico/config.h for host platform, type=list, default="", group=pico_base
add_header_content_from_var(PICO_${PICO_PLATFORM_UPPER}_CONFIG_HEADER_FILES)

file(GENERATE
        OUTPUT  ${CMAKE_BINARY_DIR}/generated/pico_base/pico/config_autogen.h
        CONTENT "${header_content}"
        )

configure_file( ${CMAKE_CURRENT_LIST_DIR}/include/pico/version.h.in ${CMAKE_BINARY_DIR}/generated/pico_base/pico/version.h)

foreach(DIR IN LISTS PICO_INCLUDE_DIRS)
    target_include_directories(pico_base_headers SYSTEM INTERFACE ${DIR})
endforeach()
