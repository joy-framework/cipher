#include <janet.h>
#include "hydrogen.h"

#define CONTEXT "cipher"
#define OPSLIMIT 10000
#define MEMLIMIT 0
#define THREADS  1

#define OPSLIMIT_MAX 50000
#define MEMLIMIT_MAX 0
#define THREADS_MAX  1

static Janet master_key(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 0);

  uint8_t master_key[hydro_pwhash_MASTERKEYBYTES];
  hydro_pwhash_keygen(master_key);

  return janet_stringv((const uint8_t *)master_key, hydro_pwhash_MASTERKEYBYTES);
}

static Janet hash(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 2);

  const uint8_t *master_key = janet_getstring(argv, 0);
  const uint8_t *password = janet_getstring(argv, 1);

  uint8_t stored[hydro_pwhash_STOREDBYTES];
  hydro_pwhash_create(stored, password, janet_string_length(password), master_key,
                      OPSLIMIT, MEMLIMIT, THREADS);

  return janet_stringv((const uint8_t *)stored, hydro_pwhash_STOREDBYTES);
}

static Janet verify(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 3);

  const uint8_t *master_key = janet_getstring(argv, 0);
  const uint8_t *hashed_password = janet_getstring(argv, 1);
  const uint8_t *plaintext_password = janet_getstring(argv, 2);

  if (hydro_pwhash_verify(hashed_password, plaintext_password, janet_string_length(plaintext_password), master_key,
                        OPSLIMIT_MAX, MEMLIMIT_MAX, THREADS_MAX) == 0) {
    return janet_wrap_true();
  } else {
    return janet_wrap_false();
  }
}

static const JanetReg cfuns[] = {
  {"master-key", master_key, "(cipher/master-key)\n\nGenerates a master key to hash and verify passwords."},
  {"hash", hash, "(cipher/hash master-key plaintext-password)\n\nHashes a plaintext password with the given master key."},
  {"verify", verify, "(cipher/verify master-key hashed-password plaintext-password)\n\nVerifies a plaintext password against a hashed one."},
  {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
  if (hydro_init() != 0) {
      abort();
  }

  janet_cfuns(env, "password", cfuns);
}
