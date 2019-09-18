(import tester :prefix "" :exit true)
(import build/password :as password)

(deftest
  (test "a master key is generated"
    (nil? (password/master-key))))
