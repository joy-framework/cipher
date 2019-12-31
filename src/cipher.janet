(import jhydro :prefix "")


(def- context "cipher  ")


(defn password-key
  "Generates a new hydrogen key for hashing passwords"
  []
  (string (pwhash/keygen)))


(defn hash-password
  "Takes a password-key and a plaintext password"
  [password-key plaintext]
  (pwhash/create plaintext password-key))


(defn verify-password
  "Verifies a plaintext password against a hashed one"
  [password-key hashed plaintext]
  (pwhash/verify hashed plaintext password-key))


(defn hash
  "Takes a string and creates a generic hash"
  [str]
  (hash/hash hash/bytes str context))


(defn encryption-key
  "Generates an encryption key"
  []
  (string (secretbox/keygen)))


(defn encrypt
  "Encrypts a string with the given encryption-key"
  [encryption-key str]
  (secretbox/encrypt str (length encryption-key) context encryption-key))


(defn decrypt
  "Decrypts a string with the given encryption-key"
  [encryption-key cipher-text]
  (string (secretbox/decrypt cipher-text (length encryption-key) context encryption-key)))


