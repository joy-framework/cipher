(import tester :prefix "" :exit true)
(import build/cipher :as cipher)

(deftest
  (test "a master key is generated"
    (false? (nil? (cipher/master-key))))

  (test "a password is hashed and verified with the same master key"
    (let [plaintext-password "plaintext password"
          master-key (cipher/master-key)
          hashed-password (cipher/hash master-key plaintext-password)]
      (true? (cipher/verify master-key hashed-password plaintext-password))))

  (test "a password is hashed and NOT verified with the same master key"
    (let [plaintext-password "plaintext password"
          master-key (cipher/master-key)
          hashed-password (cipher/hash master-key plaintext-password)]
      (false? (cipher/verify master-key hashed-password "not the same")))))
