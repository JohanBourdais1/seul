Basé sur le challenge Root-me "App - Système > LinKern ARM - syscall vulnérable"

Vous avez à votre disposition:
- Les fichiers de votre machine invitée (il n'y a ni besoin de les lire, ni de les modifier)
	- `run` : Bash script pour lancer la VM. Tout va se faire tout seul, cependant, prenez note des options `-s` et `-S`. (*Voir 1ere partie*)
	- `initramfs.img` : Le filesystem
	- `vexpress-v2p-ca9.dtb` : *Device Tree Blob*, fichier indiquant la configuration hardware pour le kernel
	- `passwd.img` : Un second filesystem qui sera monté automatiquement dans /passwd
	- `zImage` : Image compressée du kernel
- Un LKM (`ch54.ko`), sans les sources! Mais très simple
- Un conteneur Docker **commun à tous les TP** (`~/epita/docker`) comporte tous les outils dont vous aurez besoin
	- Construisez l'image une seule fois : `docker build -t epita_secl ~/epita/docker`
	- Lancez-la depuis ce dossier de TP : `docker run -it -v "$(pwd):/workspace" epita_secl`

# Prélude : 
Il s'agit d'un TP sur QEMU. QEMU fait boot une image d'un kernel Linux et vous donne un bash. Lancez `./run` et vous voilà dans la machine virtuelle. **Cependant, dans cette VM, il n'y a ni GDB, ni compilateur**.

1. **GDB** : Pour debug, vous pouvez ajouter dans les options de QEMU les options `-s` et `-S`
	- `-s` est un raccourci pour `-gdb tcp::1234` pour lancer un gdbserver sur le port 1234
	- `-S` va stop l'exécution de l'invité sur la première instruction
	- Vous pourrez alors vous connecter avec `gdb-multiarch`, en utilisant `target remote :1234` et n'oubliez pas `file` pour aussi charger les symboles de votre exploit!
	- Avec ce GDB, vous aurez une vision depuis le kernel; donc vous verrez le kernel mais aussi l'application userland (votre exploit) lorsqu'elle s'exécutera
2. **Compilateur** : Dans le conteneur, vous avez accès à `arm-linux-gnueabi-gcc`. Pensez à l'option `-nostdlib` pour vous abstraire de la libc. Vous allez avoir besoin de faire transiter votre exploit sur la machine. Une méthode pourra être d'utiliser pwntools avec l'exemple fournit (voir `exploit.py`)
- `arm-linux-gnueabi-gcc -Os -nostdlib -static -o exploit exploit.c`
# Phase 1 : Découverte de la faille
- Regardez rapidement le fichier `calc.c`,  observez comment vous servir du LKM depuis le userland
- Exécutez calc: `./calc 1 + 1`
- Ouvrez dans Ghidra le fichier `ch54.ko` 
- Réfléchissez aux points suivants, notez en les réponses dans votre compte-rendu
	- Quelle est la vulnérabilité?
	- Caractérisez votre primitive: écriture/lecture? (des limitations?)
	- Faites une notation CVSS 3.1
	- Trouvez une CWE adaptée (voir le site de MITRE, vous pouvez vous aider de l'IA, mais méfiez vous de la première réponse venue)
# Phase 2 : Exemple d'exploitation
## 1 - Ecriture
- Créez votre `exploit.c`, ajoutez en début de fonction une variable: `int z = 0xcafe` et affichez en hexadécimal cette variable à la fin de votre main.
- Utilisez la vulnérabilité pour écraser `z` avec une valeur contrôlée
- Gardez la version de ce code pour la joindre à votre compte-rendu
## 2 - Exécution
- Créez une fonction, qui ne contient qu'un syscall d'écriture sur `stdout` dans `exploit.c` et redirigez l'exécution sur celle-ci
- Gardez la version de ce code pour la joindre à votre compte-rendu

# Phase 3 : 
- Identifiez les adresses des fonctions kernel: `prepare_kernel_cred` et `commit_creds`
- Codez une fonction qui va effectuer ces deux appels
- Finissez cette fonction par lire le contenu du fichier `/passwd/passwd`
- Passez votre exploit sur la machine Root-Me
