#include <fts.h>
#include <node.h>
#include <v8.h>
#include <string>

using ::v8::Arguments;
using ::v8::Context;
using ::v8::Function;
using ::v8::FunctionTemplate;
using ::v8::Handle;
using ::v8::HandleScope;
using ::v8::Local;
using ::v8::Object;
using ::v8::String;
using ::v8::Value;
using ::v8::Undefined;

using ::std::string;

Handle<Value> Walk(const Arguments& args) {
  String::Utf8Value utf8Path(Local<String>::Cast(args[0]));
  string path(*utf8Path);

  Local<Function> callback = Local<Function>::Cast(args[1]);
  Local<Value> callbackArgs[1] = {};
  Local<Object> context = Context::GetCurrent()->Global();

  int rootPathLength = path.length() + 1;
  char *rootPath = reinterpret_cast<char*>(malloc(sizeof(char) * rootPathLength));
  snprintf(rootPath, rootPathLength, "%s", path.data());
  char * const rootPaths[] = {rootPath, NULL};

  int options = FTS_PHYSICAL | FTS_NOCHDIR | FTS_NOSTAT | FTS_COMFOLLOW;
  FTS *tree = fts_open(rootPaths, options, NULL);
  if (tree != NULL) {
    FTSENT *entry;
    while ((entry = fts_read(tree)) != NULL) {
      if (entry->fts_level == 0)
        continue;

      bool isFile = entry->fts_info == FTS_NSOK;
      bool isDirectory =  entry->fts_info == FTS_D;
      if (!isFile && !isDirectory)
        continue;

      callbackArgs[0] = String::New(entry->fts_path);
      Local<Value> recurse = callback->Call(context, 1, callbackArgs);
      if (recurse->IsBoolean() && !recurse->BooleanValue())
        fts_set(tree, entry, FTS_SKIP);
    }
    fts_close(tree);
  }

  free(rootPath);

  return Undefined();
}

void init(Handle<Object> exports) {
  exports->Set(String::NewSymbol("walk"),
      FunctionTemplate::New(Walk)->GetFunction());
}

NODE_MODULE(walken, init)
