 #!/bin/bash
 curl -L https://github.com/BennyOe/arch_install/blob/main/xenlism-grub-arch-2k.tar.gz?raw=true > /tmp/
    tar xvz /tmp/xenlism-grub-arch-2k.tar.gz
    chmod +x /tmp/xenlism-grub-arch-2k/install.sh
    source /tmp/xenlism-grub-arch-2k/install.sh
