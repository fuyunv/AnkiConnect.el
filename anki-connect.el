(require 'request)
(defconst ANKI-CONNECT-URL "http://127.0.0.1:8765"
  "URL for anki-connect")

(defun anki-connect-request (action params)
  "Commuicate with AnkiConnect.

PARAMS should be an alist"
  (let ((params (json-encode-alist params)))
    (request-response-data
     (request ANKI-CONNECT-URL
              :type "POST"
              :data (encode-coding-string (format "{\"action\" : %S,\"params\" : %s}" action params) 'utf-8)
              :parser 'json-read
              :sync t
              ))))

(defun anki-connect-deck-names ()
  "List decks"
  (append (anki-connect-request "deckNames" nil) nil))

(defun anki-connect-model-names ()
  "List models"
  (append  (anki-connect-request "modelNames" nil) nil))

(defun anki-connect-model-field-names (model)
  "List fields in MODOEL"
  (append (anki-connect-request "modelFieldNames"
                               `(("modelName" . ,model)))
          nil))
;; (completing-read nil (cons "" (anki-connect-model-field-names "单词本")))

(defun anki-connect-add-note (deck model field-alist)
  "Add a note to DECK

MODEL specify the format of the note.
FIELD-ALIST specify the content of the note."
  (anki-connect-request "addNote"
                       `(("note" . (("deckName" . ,deck)
                                    ("modelName" . ,model)
                                    ("fields" . ,field-alist)
                                    ("tags" . []))))))

;; (anki-connect-add-note "我的生词本" "单词本"
;;                      '(("拼写" . "Emacs")
;;                       ("意义" . "测试AnkiConnect")))

(provide 'anki-connect)
