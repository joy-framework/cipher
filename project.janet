(declare-project
  :name "password"
  :description "A password hashing library for janet"
  :author "Sean Walker"
  :license "MIT"
  :dependencies [{:repo "https://github.com/joy-framework/tester" :tag "c14aff3591cb0aed74cba9b54d853cf0bf539ecb"}]
  :url "https://github.com/joy-framework/password"
  :repo "git+https://github.com/joy-framework/password")


(declare-native
  :name "password"
  :source @["password.c" "hydrogen.c"])
