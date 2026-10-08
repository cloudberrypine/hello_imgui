#ifndef __EMSCRIPTEN__

#include "hello_imgui/internal/whereami/whereami.h"
#include "hello_imgui/internal/whereami/whereami_cpp.h"

namespace
{
    // whereami returns -1 when it cannot tell the path: on macOS when the
    // executable's file is gone (deleted or moved while it runs), as
    // realpath fails. The path is empty then; writing path[length] with a
    // length of -1 wrote a zero byte before the allocation, into whatever
    // the heap kept there, on every call.
    std::string pathString(int (*getPath)(char* out, int capacity, int* dirname_length))
    {
        int length = getPath(NULL, 0, NULL);
        if (length <= 0)
            return std::string();
        std::string result((size_t)length, '\0');
        if (getPath(&result[0], length, NULL) != length)
            return std::string();
        return result;
    }
}

std::string wai_getExecutablePath_string()
{
    return pathString(wai_getExecutablePath);
}

std::string wai_getModulePath_string()
{
    return pathString(wai_getModulePath);
}

namespace
{
    std::string dirname(const std::string& str)
    {
        size_t found;
        found=str.find_last_of("/\\");
        std::string dirname = str.substr(0,found);
        return dirname;
    }
}

std::string wai_getExecutableFolder_string()
{
    return dirname(wai_getExecutablePath_string());
}

#endif
