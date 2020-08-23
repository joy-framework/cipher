(import jhydro :prefix "")


(def- context "cipher  ")
(def hex2bin util/hex2bin)
(def bin2hex util/bin2hex)
(def secure-compare util/=)


(defn password-key
  "Generates a new hydrogen key for hashing passwords"
  []
  (string (bin2hex (pwhash/keygen))))


(defn hash-password
  "Takes a password-key and a plaintext password"
  [password-key plaintext]
  (string (bin2hex (pwhash/create plaintext (hex2bin password-key)))))


(defn verify-password
  "Verifies a plaintext password against a hashed one"
  [password-key hashed plaintext]
  (pwhash/verify (hex2bin hashed) plaintext (hex2bin password-key)))


(defn hash
  "Takes a string and creates a generic hash"
  [str]
  (string (bin2hex (hash/hash hash/bytes str context))))


(defn encryption-key
  "Generates an encryption key"
  []
  (as-> (secretbox/keygen) ?
        (string ?)
        (bin2hex ?)
        (string ?)))


(defn encrypt
  "Encrypts a string with the given encryption-key"
  [encryption-key str]
  (let [encryption-key (hex2bin encryption-key)]
    (as-> str ?
          (secretbox/encrypt ? (length encryption-key) context encryption-key)
          (string ?)
          (bin2hex ?)
          (string ?))))


(defn decrypt
  "Decrypts a string with the given encryption-key"
  [encryption-key cipher-text]
  (let [encryption-key (hex2bin encryption-key)
        cipher-text (hex2bin cipher-text)]
    (as-> cipher-text ?
          (secretbox/decrypt ? (length encryption-key) context encryption-key)
          (string ?))))
