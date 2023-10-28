//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <libgit2dart/libgit2dart_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) libgit2dart_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "Libgit2dartPlugin");
  libgit2dart_plugin_register_with_registrar(libgit2dart_registrar);
}
