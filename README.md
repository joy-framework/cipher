# cipher

Hash passwords and encrypt strings with janet

## Install

Add to your `project.janet` file

```clojure
{:dependencies [{:repo "https://github.com/joy-framework/cipher" :tag "58fbe201a3d7471e3491b2a0452a9631ac637998"}]}
```

## Use

Libhydrogen requires a master key for all hashing/encryption functions, so the first step is to generate it

```clojure
(import cipher)

(def key (cipher/password-key))
```

Now we can use that key when hashing a password

```clojure
(def hashed-password (cipher/hash-password key "correct horse battery staple"))
```

This returns a garbled string that represents the password. Then to verify a plaintext password
you call this

```clojure
(cipher/verify key hashed-password "correct horse battery staple")
```

This returns either true or false.

## Test

Run `jpm test` from the project folder.
