# Bundle assets / macOS and iOS app version
function(hello_imgui_apple_bundle_add_files_from_folder app_name assets_folder location_in_bundle)
    file(GLOB_RECURSE assets ${assets_folder}/*.*)
    list(FILTER assets EXCLUDE REGEX "(^|/)\\.DS_Store$")
    foreach(exclude_regex ${ARGN})
        list(FILTER assets EXCLUDE REGEX "${exclude_regex}")
    endforeach()
    target_sources(${app_name} PRIVATE ${assets})
    foreach(asset ${assets})
        file(RELATIVE_PATH asset_relative ${assets_folder} ${asset})
        get_filename_component(asset_dir ${asset_relative} DIRECTORY)
        set_source_files_properties(
            ${asset}
            PROPERTIES
            MACOSX_PACKAGE_LOCATION ${location_in_bundle}/${asset_dir}
        )
    endforeach()
endfunction()

function(hello_imgui_apple_bundle_add_files_from_folder_non_recursive app_name assets_folder location_in_bundle)
    file(GLOB assets ${assets_folder}/*.*)
    list(FILTER assets EXCLUDE REGEX "(^|/)\\.DS_Store$")
    target_sources(${app_name} PRIVATE ${assets})
    foreach(asset ${assets})
        file(RELATIVE_PATH asset_relative ${assets_folder} ${asset})
        get_filename_component(asset_dir ${asset_relative} DIRECTORY)
        set_source_files_properties(
                ${asset}
                PROPERTIES
                MACOSX_PACKAGE_LOCATION ${location_in_bundle}/${asset_dir}
        )
    endforeach()
endfunction()

# Add resources through CMake's bundle RESOURCE property. With the Xcode
# generator this creates the native "Copy Bundle Resources" build phase.
function(hello_imgui_apple_bundle_add_resources_from_folder_non_recursive app_name assets_folder)
    file(GLOB assets ${assets_folder}/*.*)
    list(FILTER assets EXCLUDE REGEX "(^|/)\\.DS_Store$")
    target_sources(${app_name} PRIVATE ${assets})
    set_property(TARGET ${app_name} APPEND PROPERTY RESOURCE ${assets})
endfunction()

function(hello_imgui_bundle_assets_from_folder app_name assets_folder)
    # app_settings contains build metadata and platform resources. Platform
    # customizers add the relevant files separately at the bundle root.
    hello_imgui_apple_bundle_add_files_from_folder(
        ${app_name} ${assets_folder} "Resources/assets" "/app_settings/")
endfunction()


function(hello_imgui_bundle_assets_from_folder_non_recursive app_name assets_folder)
    hello_imgui_apple_bundle_add_files_from_folder_non_recursive(${app_name} ${assets_folder} "Resources/assets")
endfunction()
