(require 'ido)
(require 'gtags)

(defun k/jump-to-exported-symbol()
  (interactive)
  (k/jump-to-macro-symbol
   "EXPORT_SYMBOL(\\(.*\\));"  "Exported Symbol:"))

(defun k/jump-to-macro-symbol(regexp prompt)
  (interactive)
    (let ((results '())
          (selection nil)
          )
      (save-excursion
        (goto-char 0)
        (while (search-forward-regexp regexp nil t)
          (push
           (list (match-string 1)  (match-beginning 1) (match-end 1))
           results))
        (setf results (nreverse results))    
        (setf selection (ido-completing-read
                         prompt
                         (mapcar (lambda(l)  (car l)) results))))
        (loop for elt in results
              do
              (when (equal (car elt) selection)
                (goto-char (nth 1 elt))
                (gtags-find-tag-from-here)
                ))))
  

