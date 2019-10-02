#include <janet.h>
#include "hydrogen.h"

#define CONTEXT "cipher  "
#define OPSLIMIT 10000
#define MEMLIMIT 0
#define THREADS  1

#define OPSLIMIT_MAX 50000
#define MEMLIMIT_MAX 0
#define THREADS_MAX  1

static Janet password_keygen(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 0);

  uint8_t master_key[hydro_pwhash_MASTERKEYBYTES];
  hydro_pwhash_keygen(master_key);

  return janet_stringv((const uint8_t *)master_key, hydro_pwhash_MASTERKEYBYTES);
}

static Janet hash_password(int32_t argc, const Janet *argv) {
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

static Janet hash(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 1);

  const uint8_t *str = janet_getstring(argv, 0);

  uint8_t hash[hydro_hash_BYTES];
  hydro_hash_hash(hash, hydro_hash_BYTES, str, janet_string_length(str), CONTEXT, NULL);

  return janet_stringv((uint8_t *)hash, hydro_hash_BYTES);
}

static Janet encryption_key(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 0);

  uint8_t key[hydro_secretbox_KEYBYTES];

  hydro_secretbox_keygen(key);

  return janet_stringv(key, hydro_secretbox_KEYBYTES);
}

static Janet encrypt(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 2);

  const uint8_t *key = janet_getstring(argv, 0);
  const uint8_t *plaintext = janet_getstring(argv, 1);
  const uint8_t plaintext_len = janet_string_length(plaintext);
  const uint8_t ciphertext_len = hydro_secretbox_HEADERBYTES + plaintext_len;

  uint8_t ciphertext[ciphertext_len];
  hydro_secretbox_encrypt(ciphertext, plaintext, plaintext_len, 0, CONTEXT, key);

  return janet_stringv(ciphertext, ciphertext_len);
}

static Janet decrypt(int32_t argc, const Janet *argv) {
  janet_fixarity(argc, 2);

  const uint8_t *key = janet_getstring(argv, 0);
  const uint8_t *ciphertext = janet_getstring(argv, 1);
  const int32_t ciphertext_len = janet_string_length(ciphertext);
  const int32_t len = ciphertext_len - hydro_secretbox_HEADERBYTES;

  uint8_t decrypted[len];
  if (hydro_secretbox_decrypt(decrypted, ciphertext, ciphertext_len, 0, CONTEXT, key) == 0) {
    return janet_stringv(decrypted, len);
  } else {
    return janet_wrap_nil();
  }
}

static const JanetReg cfuns[] = {
  {"password-key", password_keygen, "(cipher/password-key)\n\nGenerates a key to hash and verify passwords."},
  {"hash-password", hash_password, "(cipher/hash-password password-key plaintext-password)\n\nHashes a plaintext password with the given password key."},
  {"verify-password", verify, "(cipher/verify password-key hashed-password plaintext-password)\n\nVerifies a plaintext password against a hashed one."},
  {"hash", hash, "(cipher/hash str)\n\nHashes a string."},
  {"encryption-key", encryption_key, "(cipher/encryption-key)\n\nGenerates a key to encrypt and decrypt strings."},
  {"encrypt", encrypt, "(cipher/encrypt key str)\n\nEncrypts a string."},
  {"decrypt", decrypt, "(cipher/decrypt key encrypted-str)\n\nDecrypts an encrypted string"},
  {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
  if (hydro_init() != 0) {
      abort();
  }

  janet_cfuns(env, "cipher", cfuns);
}
