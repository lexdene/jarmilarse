;; some util commands about git
(provide 'jarmilarse)

(eval-when-compile (require 'subr-x))

(defun jmls-command (command)
  "call command and return output"
  (string-trim (shell-command-to-string command)))

(defun jmls-remove-suffix (str tail)
  "remove suffix from string"
  (if
    (string-equal (substring str (- (string-bytes tail))) tail)
    (substring str 0 (- (string-bytes tail)))
    str)
)

(defun jmls-bufcl-copy ()
  "copy browser url for current line"
  (interactive)
  (let*
    ((line-number (line-number-at-pos))
     (revision (jmls-command "git rev-parse HEAD"))
     (branch (jmls-command "git rev-parse --abbrev-ref HEAD"))
     (remote (jmls-command (format "git config --get branch.%s.remote" branch)))
     (repo-url
       (jmls-remove-suffix
        (jmls-command (format "git config --get remote.%s.url" remote))
        ".git"))
     (project-root-dir (jmls-command "git rev-parse --show-toplevel"))
     (file-path (file-relative-name (buffer-file-name) project-root-dir))
     (bufcl
      (format "%s/blob/%s/%s#L%d" repo-url revision file-path line-number))
    )
    (progn
      (message bufcl)
      (kill-new bufcl)
    )
  )
)
