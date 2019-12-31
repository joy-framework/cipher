(import tester :prefix "" :exit true)
(import ../src/cipher :as cipher)

(deftest
  (test "a master key is generated"
    (false? (nil? (cipher/password-key))))

  (test "a password is hashed and verified with the same key"
    (let [plaintext-password "plaintext password"
          password-key (cipher/password-key)
          hashed-password (cipher/hash-password password-key plaintext-password)]
      (true? (cipher/verify-password password-key hashed-password plaintext-password))))

  (test "a password is hashed and NOT verified with the same key"
    (let [plaintext-password "plaintext password"
          password-key (cipher/password-key)
          hashed-password (cipher/hash-password password-key plaintext-password)]
      (false? (cipher/verify-password password-key hashed-password "not the same"))))

  (test "hashing a string"
    (let [str "a string"]
      (true? (= (cipher/hash str) (cipher/hash str)))))

  (test "encryption key is generated"
    (false? (nil? (cipher/encryption-key))))

  (test "a string is encrypted and decrypted"
    (let [key (cipher/encryption-key)
          str "hello world"
          cipher-text (cipher/encrypt key str)
          plaintext (cipher/decrypt key cipher-text)]
      (true? (= str plaintext))))

  (test "a string is encrypted and decrypted with the same key should not be a different value"
    (let [key (cipher/encryption-key)
          str "testing a longer string"
          cipher-text (cipher/encrypt key str)]
      (false? (= "testing a longer str" (cipher/decrypt key cipher-text))))))
