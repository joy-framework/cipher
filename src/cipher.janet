(import jhydro :prefix "")


(def- context "cipher  ")
(def- mapping {"A" 10 "B" 11 "C" 12 "D" 13 "E" 14 "F" 15
               "a" 10 "b" 11 "c" 12 "d" 13 "e" 14 "f" 15})


(defn- char-to-hex [str]
  (let [arr (partition 1 str)
        a (get mapping (get arr 0) (scan-number (get arr 0)))
        b (get mapping (get arr 1) (scan-number (get arr 1)))
        output (+ b (* a 16))]
    (string/from-bytes output)))


(defn- str-to-hex [str]
  (as-> str ?
        (string ?)
        (partition 2 ?)
        (map char-to-hex ?)
        (string/join ? "")))


(defn- hex-to-str [hex-str]
  (let [buf (buffer)]
    (map |(buffer/format buf "%02x" $) hex-str)
    (string buf)))


(defn password-key
  "Generates a new hydrogen key for hashing passwords"
  []
  (hex-to-str (pwhash/keygen)))


(defn hash-password
  "Takes a password-key and a plaintext password"
  [password-key plaintext]
  (hex-to-str (pwhash/create plaintext (str-to-hex password-key))))


(defn verify-password
  "Verifies a plaintext password against a hashed one"
  [password-key hashed plaintext]
  (pwhash/verify (str-to-hex hashed) plaintext (str-to-hex password-key)))


(defn hash
  "Takes a string and creates a generic hash"
  [str]
  (hex-to-str (hash/hash hash/bytes str context)))


(defn encryption-key
  "Generates an encryption key"
  []
  (as-> (secretbox/keygen) ?
        (string ?)
        (hex-to-str ?)))


(defn encrypt
  "Encrypts a string with the given encryption-key"
  [encryption-key str]
  (let [encryption-key (str-to-hex encryption-key)]
    (as-> str ?
          (secretbox/encrypt ? (length encryption-key) context encryption-key)
          (string ?)
          (hex-to-str ?))))


(defn decrypt
  "Decrypts a string with the given encryption-key"
  [encryption-key cipher-text]
  (let [encryption-key (str-to-hex encryption-key)
        cipher-text (str-to-hex cipher-text)]
    (as-> cipher-text ?
          (secretbox/decrypt ? (length encryption-key) context encryption-key)
          (string ?))))


