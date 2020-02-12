(declare-project
  :name "cipher"
  :description "A password hashing and encryption library for janet"
  :author "Sean Walker"
  :license "MIT"
  :version "0.2.0"
  :dependencies [{:repo "https://github.com/joy-framework/tester" :tag "0.2.1"}
                 {:repo "https://github.com/janet-lang/jhydro" :tag "d4423658a15275a815be2bef49b4e0030c18d8d4"}]
  :url "https://github.com/joy-framework/cipher"
  :repo "git+https://github.com/joy-framework/cipher")

(declare-source
  :source @["src/cipher.janet"])
