# Lab0 : notes

## Cloud computing

Rappeler :

- IaaS : infrastructure as a service (ex : S3, EC2)
- PaaS : plateforme as a service (exemple EMR dans les prochains TP)
- SaaS : software as a service (Google drive)

Chaque services à ses +/-

- IaaS : contrôle total, mais il faut tout gérer/installer soi même. A destination des personnes de l'informatique (data engineer, data architect)
- PaaS : Une partie de la maintenance/gestion est prise en charge, mais demandes des connaissances de base. Data scientist / data engineer / Data analyst / data architect
- SaaS : presque aucun contrôle, mais on a un service rendu rapidement.  Data scientist / Data analyst / 

## Benchmark

Sur 6Go de donnée, et avec 12 coeurs j'obtenais:

1. Python multithreadé
2. C compilé
3. Java
4. Awk
5. R
6. Cython 
7. python

Là comme il n'y aura qu'un coeur, python multithreadé sera plus long que python normalement. Pour le reste, l'ordre devrait être conservé.

Les messages à faire passer :

- Typé statiquement vs dynamiquement : typer dynamiquement ralenti car le type est déterminé au runtime
- Compilation à l'avance vs interprétation. La compilation prend du temps, mais le code produit est plus bas niveau et permet accélérer les temps d'exécution
-  Python vs Cython. Cython permet de compiler certains bouts de code pour avoir un code plus rapide. Mais cela demande de typer ses variables. Par contre ce n'est pas une solution miracle.
- Le C est bien plus complexe que python, et demande d'écrire beaucoup plus de code pour la même chose. Beaucoup de librairies python ont des bout de code en C, Cython pour allez plus vite (Numpy, Pandas)



