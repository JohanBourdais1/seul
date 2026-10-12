## 1

il n'y a pas de vérification au moment de l'écriture de r, l'utilisateur peut donc écrire la valeur qu'il veut à l'adresse qu'il veut.

c'est une primitive d'écriture arbitraire, le syscall ne renvoie jamais le contenu d'une adresse mémoire, il n'y a donc pas de primitive de lecture.

CVSS:3.0/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H
7.8
(High)

CWE-123: Write-what-where Condition

Description:

Any condition where the attacker has the ability to write an arbitrary value to an arbitrary location, often as the result of a buffer overflow.


80042464 l'addresse de prepare_kernel_cred
80042148 l'addresse de commit_creds
