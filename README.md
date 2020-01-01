# cipher

Hash passwords and encrypt strings with janet

## Install

Add to your `project.janet` file

```clojure
{:dependencies [{:repo "https://github.com/joy-framework/cipher" :tag "87fc9bc38b335d0f31c93d6c95f35b8a6abce6af"}]}
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
