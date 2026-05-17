;;; docker.el --- Docker -*- lexical-binding: t; -*-

(use-package dockerfile-mode
  :mode ("Dockerfile\\'" "\\.dockerfile\\'"))

(use-package docker-compose-mode
  :mode ("docker-compose\\.ya?ml\\'"))

(provide 'docker)
;;; docker.el ends here
