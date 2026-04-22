#include <windows.h>
#include <shellapi.h>

#include <string>
#include <vector>

#include "deps/nowide/convert.hpp"


int main(int, char **);

INT WINAPI WinMain(HINSTANCE /*hInstance*/, HINSTANCE /*hPrevInstance*/, PSTR /*lpCmdLine*/, INT /*nCmdShow*/)
{
  int argc = 0;
  LPWSTR *argvWide = CommandLineToArgvW(GetCommandLineW(), &argc);
  if (argvWide == nullptr || argc <= 0) {
    return main(0, nullptr);
  }

  std::vector<std::string> utf8Args;
  utf8Args.reserve((size_t)argc);
  for (int i = 0; i < argc; ++i) {
    utf8Args.push_back(nowide::narrow(argvWide[i]));
  }

  std::vector<char *> argv;
  argv.reserve((size_t)argc + 1);
  for (std::string &arg : utf8Args) {
    argv.push_back(arg.empty() ? const_cast<char *>("") : arg.data());
  }
  argv.push_back(nullptr);

  int exit_result = main(argc, argv.data());
  LocalFree(argvWide);
  return exit_result;
}
