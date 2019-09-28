# cipher

Hash passwords and encrypt strings with janet

## Install

Add to your `project.janet` file

```clojure
{:dependencies [{:repo "https://github.com/joy-framework/cipher" :tag ""}]}
```

## Use

Libhydrogen requires a master key for all hashing/encryption functions, so the first step is to generate it

```clojure
(def master-key (cipher/master-key))
```

Now we can use that master key when hashing a password

```clojure
(import cipher)

(def hashed-password (cipher/hash master-key "correct horse battery staple"))
```

This returns a garbled string that represents the password. Then to verify a plaintext password
you call this

```clojure
(cipher/verify master-key hashed-password "correct horse battery staple")
```

This returns either true or false.

## Test

Run `jpm test` from the project folder.
