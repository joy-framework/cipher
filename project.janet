(declare-project
  :name "cipher"
  :description "A password hashing and encryption library for janet"
  :author "Sean Walker"
  :license "MIT"
  :dependencies [{:repo "https://github.com/joy-framework/tester" :tag "c14aff3591cb0aed74cba9b54d853cf0bf539ecb"}]
  :url "https://github.com/joy-framework/cipher"
  :repo "git+https://github.com/joy-framework/cipher")


(declare-native
  :name "cipher"
  :source @["cipher.c" "hydrogen.c"])
