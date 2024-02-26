(use-modules (gnu)
             (gnu services desktop)
             (gnu services pm)
             (gnu services databases)
             (gnu services sound)
             (nongnu packages linux)
             (nongnu system linux-initrd))

(use-service-modules cups desktop networking ssh xorg)

(use-package-modules security-token)

(define add-click-finger-click-method
"Section \"InputClass\"
  Identifier \"Touchpads\"
  MatchIsTouchpad \"on\"

  Driver \"libinput\"
  Option \"ClickMethod\" \"clickfinger\"
EndSection")

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list sof-firmware linux-firmware))

  (locale "en_CA.utf8")
  (timezone "America/Vancouver")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "snass")

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

  (packages (append (specifications->packages (list "awesome"
                                                  "nss-certs"
                                                  "tlp"
                                                  "pulseaudio"
                                                  "xinput"
                                                  "libinput"))
                    %base-packages))
  (services
    (cons*
      (service openssh-service-type)
      (service postgresql-service-type
               (postgresql-configuration
                 (postgresql (specification->package "postgresql@15.4"))))
      (set-xorg-configuration
        (xorg-configuration
          (keyboard-layout keyboard-layout)
          (extra-config
            (list add-click-finger-click-method))))
      (udev-rules-service 'fido2 libfido2 #:groups '("plugdev"))
      (service tlp-service-type)
      (service thermald-service-type)
      (modify-services
        %desktop-services
        (guix-service-type
          config => (guix-configuration
                      (inherit config)
                      (substitute-urls
                        (append (list "https://substitutes.nonguix.org")
                                %default-substitute-urls))
                      (authorized-keys
                        (append (list (local-file "./nonguix-signing-key.pub"))
                                %default-authorized-guix-keys)))))))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "9a10974b-fa2c-423c-b0dd-96d95a55dd9e"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

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
