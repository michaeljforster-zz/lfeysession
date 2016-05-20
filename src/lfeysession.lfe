(defmodule lfeysession
  (export (new 3)
          (new 4)
          (new 5)
          (get 2)
          (replace 3)
          (delete 2)))

(include-lib "yaws/include/yaws_api.hrl")

;; find-session-cookie-val (arg any) -> '() | any
(defun find-session-cookie-val (arg-data cookie-name)
  (let ((headers (arg-headers arg-data)))
    (let ((cookie (headers-cookie headers)))
      (yaws_api:find_cookie_val cookie-name cookie))))

;; new (any any tuple-list) -> tuple
(defun new (cookie-name opaque options)
  (let ((cookie-val (yaws_api:new_cookie_session opaque)))
    (yaws_api:set_cookie cookie-name cookie-val options)))

;; new (any any integer tuple-list) -> tuple
(defun new (cookie-name opaque ttl options)
  (let ((cookie-val (yaws_api:new_cookie_session opaque ttl)))
    (yaws_api:set_cookie cookie-name cookie-val options)))

;; new (any any integer pid tuple-list) -> tuple
(defun new (cookie-name opaque ttl cleanup-pid options)
  (let ((cookie-val (yaws_api:new_cookie_session opaque ttl cleanup-pid)))
    (yaws_api:set_cookie cookie-name cookie-val options)))

;; get (arg any) => (tuple 'ok session) | (tuple 'error 'no_session) | (tuple 'error 'no-cookie)
(defun get (arg-data cookie-name)
  (case (find-session-cookie-val arg-data cookie-name)
    ('()
     #(error no-cookie))
    (cookie-val
     (yaws_api:cookieval_to_opaque cookie-val))))

;; replace (arg any any) -> 'true | 'error
(defun replace (arg-data cookie-name opaque)
  (let ((cookie-val (find-session-cookie-val arg-data cookie-name)))
    (yaws_api:replace_cookie_session cookie-val opaque)))

;; delete (arg any) -> 'true | 'nocleanup | #(yaws_session_end normal _ _)
(defun delete (arg-data cookie-name)
  (let ((cookie-val (find-session-cookie-val arg-data cookie-name)))
    (yaws_api:delete_cookie_session cookie-val)))
