;;; request-shim.el --- request.el shim usando url-retrieve (built-in) -*- lexical-binding: t; -*-

(require 'url)
(require 'json)
(require 'cl-lib)

(defconst request-shim--success-codes '(200 201 202 203 204))

(defun request-shim--plist-from-buffer ()
  "Parse HTTP response buffer into a plist mimicking request.el."
  (goto-char (point-min))
  (let (status-code status-text headers body-start)
    (when (re-search-forward "^\\(HTTP/[0-9.]+\\) \\([0-9]+\\) \\([^\r\n]*\\)" nil t)
      (setq status-code (string-to-number (match-string 2))
            status-text (match-string 3)))
    (while (re-search-forward "^\\([^:\r\n]+\\):[ \t]*\\([^\r\n]*\\)" nil t)
      (push (cons (match-string 1) (match-string 2)) headers))
    (setq headers (nreverse headers))
    (re-search-forward "^\r?\n" nil t)
    (setq body-start (point))
    (goto-char (point-max))
    (delete-region (point-min) (1- body-start))
    (let ((body (buffer-string)))
      `(:status-code ,status-code
                     :status-text ,status-text
                     :headers ,headers
                     :data ,body))))

(defun request (url &rest args)
  "Shim for request.el using built-in url-retrieve.
Args supported: :type, :data, :headers, :parser, :auth, :timeout, :success, :error."
  (let* ((method (upcase (symbol-name (or (plist-get args :type) 'GET))))
         (payload (plist-get args :data))
         (header-alist (plist-get args :headers))
         (parser (or (plist-get args :parser) #'buffer-string))
         (auth (plist-get args :auth))
         (timeout (plist-get args :timeout))
         (success-cb (plist-get args :success))
         (error-cb (plist-get args :error))
         (url-request-method method)
         (url-request-data (if (stringp payload)
                               payload
                             (when payload (json-encode payload))))
         (url-request-extra-headers
          (append (cl-loop for (k . v) in header-alist
                           collect (cons k v))
                  (when auth
                    `(("Authorization" .
                       ,(concat "Basic "
                                (base64-encode-string
                                 (concat (car auth) ":" (cadr auth)))))))))
         (url-request-coding-system 'utf-8)
         (url-buf nil))
    (setq url-buf
          (url-retrieve url
                        (lambda (status)
                          (condition-case err
                              (let ((parsed (with-current-buffer (current-buffer)
                                              (request-shim--plist-from-buffer)))
                                    (buffer (current-buffer)))
                                (if (memq (plist-get parsed :status-code)
                                          request-shim--success-codes)
                                    (progn
                                      (let ((response-data
                                             (with-current-buffer buffer
                                               (funcall parser))))
                                        (when success-cb
                                          (let ((fn success-cb))
                                            (condition-case nil
                                                (funcall fn :data
                                                         (if (stringp response-data)
                                                             response-data
                                                           response-data))
                                              (wrong-number-of-arguments
                                               (funcall fn :data
                                                        (if (stringp response-data)
                                                            response-data
                                                          response-data)
                                                        :response parsed)))))
                                        (let ((cb (plist-get args :done)))
                                          (when cb (funcall cb))))
                                      (kill-buffer buffer))
                                  (when error-cb
                                    (funcall error-cb
                                             :error-thrown
                                             (format "HTTP %s %s"
                                                     (plist-get parsed :status-code)
                                                     (or (plist-get parsed :status-text) "")))
                                    (kill-buffer buffer))))
                            (error
                             (when error-cb
                               (funcall error-cb :error-thrown err)))))
                        nil nil nil (and timeout (round (* timeout 1000)))))
    url-buf))

(provide 'request)
;;; request-shim.el ends here
