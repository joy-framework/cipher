# cipher

Hash passwords and encrypt strings with janet

## Install

Add to your `project.janet` file

```clojure
{:dependencies [{:repo "https://github.com/joy-framework/cipher" :tag "0.2.0"}]}
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

## Encryption

You can also encrypt strings!

```clojure
(let [key (cipher/encryption-key)]
  (as-> "hello" ?
        (cipher/encrypt key ?)
        (cipher/decrypt key ?))) => "hello"
```

## Generic hashing

```clojure
(cipher/hash "hello") => "7fde0696c922ba4e1348dd7fa32f957531b861a93d78eef120a6c1a62fa3d2df"
```

## Test

Run `jpm test` from the project folder.
