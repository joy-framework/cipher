(declare-project
  :name "cipher"
  :description "A password hashing and encryption library for janet"
  :author "Sean Walker"
  :license "MIT"
  :version "0.2.0"
  :dependencies ["https://github.com/joy-framework/jhydro"]
  :url "https://github.com/joy-framework/cipher"
  :repo "git+https://github.com/joy-framework/cipher")

(declare-source
  :source @["src/cipher.janet"])
