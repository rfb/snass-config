;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
             (gnu services desktop)
             (gnu services pm)
             (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules cups desktop networking ssh xorg)

(use-package-modules security-token)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list sof-firmware linux-firmware))

  (locale "en_CA.utf8")
  (timezone "America/Vancouver")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "snass")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "rfb")
                  (comment "Ryan Barber")
                  (group "users")
                  (home-directory "/home/rfb")
                  (supplementary-groups '("wheel"
                                          "netdev"
                                          "audio"
                                          "plugdev"
                                          "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "awesome")
                          (specification->package "nss-certs"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
    (cons*
      (service openssh-service-type)
      (set-xorg-configuration (xorg-configuration (keyboard-layout keyboard-layout)))
      (udev-rules-service 'fido2 libfido2 #:groups '("plugdev"))
      (service tlp-service-type)
      (service thermald-service-type)
    %desktop-services))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "9a10974b-fa2c-423c-b0dd-96d95a55dd9e"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "1D86-2E71"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems)))
