;;; kzkn-defuns.el --- Custom functions

(defun google ()
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if (region-active-p)
        (buffer-substring (region-beginning) (region-end))
      (read-string "Query: ")))))

(defun buffer-current-line-string ()
  (save-excursion
    (buffer-substring (progn (beginning-of-line) (point))
                      (progn (end-of-line) (point)))))

(defun buffer-current-line-starts-with (prefix)
  (let ((line (buffer-current-line-string)))
    (and (<= (length prefix) (length line))
         (equal prefix (substring line 0 (length prefix))))))

(defun open-path ()
  (interactive)
  (save-excursion
    (let ((path (if (%thunar-path-p)
                    (buffer-current-line-string)
                  (%win-to-thunar))))
      (start-process "open-path" nil "/usr/bin/thunar" path))))

(defun %thunar-path-p ()
  (buffer-current-line-starts-with "smb:"))

(defun %win-to-thunar ()
  (let ((orig-path (buffer-current-line-string)))
    (with-temp-buffer
      (insert orig-path)
      (%replace-path-separators)
      (buffer-string))))

(defun %replace-path-separators ()
  (let ((end (progn (end-of-line) (point))))
    (beginning-of-line)
    (insert "smb:")
    (while (and (search-forward "\\" nil t) (<= (point) end))
      (replace-match "/"))))

(defun resize-window ()
  "Resize the current window."
  (interactive)
  (when (one-window-p)
    (error "Cannot resize sole window"))
  (catch 'done
    (while t
      (message "size[%dx%d]" (window-width) (window-height))
      (let ((c (read-char)))
        (condition-case nil
            (cond ((= c ?f) (enlarge-window-horizontally 2))
                  ((= c ?b) (shrink-window-horizontally 2))
                  ((= c ?n) (enlarge-window 2))
                  ((= c ?p) (shrink-window 2))
                  ((= c ?q)
                   (message "quit") (throw 'done t))
                  (t nil))
          (error nil))))))

(provide 'kzkn-defuns)
