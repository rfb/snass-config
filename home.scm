;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu home services)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services shells)
             (gnu home services dotfiles))

(home-environment
 ;; Below is the list of packages that will show up in your
 ;; Home profile, under ~/.guix-home/profile.
 (packages (specifications->packages (list "alsa-utils"
                                           "curl"
                                           "docker"
                                           "emacs"
                                           "firefox"
                                           "font-borg-sans-mono"
                                           "git"
                                           "gnucash"
                                           "gnupg"
                                           "go"
                                           "google-chrome-stable"
                                           "google-cloud-sdk"
                                           "google-cloud-sdk"
                                           "gpodder"
                                           "guvcview"
                                           "jq"
                                           "kitty"
                                           "lynx"
                                           "make"
                                           "neovim"
                                           "neovim-packer"
                                           "password-store"
                                           "pavucontrol"
                                           "pinentry"
                                           "postgresql"
                                           "pwgen"
                                           "ripgrep"
                                           "shotwell"
                                           "slock"
                                           "slock"
                                           "unzip"
                                           "xss-lock"
                                           "zbar")))

 ;; Below is the list of Home services.  To search for available
 ;; services, run 'guix home search KEYWORD' in a terminal.
 (services
  (list
   (simple-service 'personal-env-variable-service
                   home-environment-variables-service-type
                   '(("EDITOR" . "nvim")))
   (service home-dotfiles-service-type
            (home-dotfiles-configuration
             (layout 'stow)
             (directories (list "./dotfiles"))))
   (service home-bash-service-type
            (home-bash-configuration
             (aliases '(("grep" . "grep --color=auto")
                        ("ip" . "ip -color=auto")
                        ("ll" . "ls -l")
                        ("ls" . "ls -p --color=auto")))
             (bashrc (list (local-file "./bashrc")))
             (bash-profile (list (local-file "./bash_profile"))))))))
