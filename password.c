#include <janet.h>
#include "hydrogen.h"

static Janet master_key(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 0);

  return janet_wrap_nil();
}

static Janet hash(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 2);

  return janet_wrap_nil();
}

static Janet verify(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 3);

  return janet_wrap_nil();
}

static const JanetReg cfuns[] = {
  {"master-key", master_key, "(password/master-key)\n\nGenerates a master key to hash and verify passwords."},
  {"hash", hash, "(password/hash master-key plaintext-password)\n\nHashes a plaintext password with the given master key."},
  {"verify", verify, "(password/verify master-key hashed-password plaintext-password)\n\nVerifies a plaintext password against a hashed one."},
  {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
  janet_cfuns(env, "password", cfuns);
}
