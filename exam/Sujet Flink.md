# Sujet Flink

lien : https://flink.apache.org/flink-architecture.html

1. Dans quel cas utiliser Flink ? 
2. Des exemple de stream autre que les stream cités ?
3. C'est quoi un bounded stream ? A quel moment un traitement s'exécute sur un bounded stream ?
4. Une idée à quoi sert un ressource manager et pourquoi Flink en a besoin ?
5. Qu'est ce que c'est que les REST calls ? Est-ce spécifique au big data ?
6. Comment augmenter la capacité d'un cluster Flink ?
7. Si un un noeud du cluster rencontre un problème et éteint, comment Flink récupère-t-il les données qu'il avait ? 
8. As-tu déjà utilisé une application qui répond aux même cas d'utilisation que Flink ?

# Sujet Kafka

lien : https://kafka.apache.org/intro

1. Dans quel cas utiliser kafka ?
2. Des exemple de stream autre que les stream cités ?
3. Puis-je stoker des données avec kafka ?
4. Quel sont les types de server de kafka ?
5. Comment un topic est-il stocké ?
6. Dois-je apprendre un nouveau langage pour utiliser kafka ?
7. Une idée de système de stockage distribué ?
8. Différence entre Spark Streaming et kafka ?

# Sujet Ibotta (s'arrêter à "Features")

lien : https://medium.com/building-ibotta/train-sklearn-100x-faster-bec530fc1f45


6. Est-ce que la taille des données est un problème pour Ibotta? [Non: "small to medium sized data (100k to 1M records) with many iterations of simple classifiers to fit for hyperparameter tuning, ensembles and multi-class solutions."]

1. "At Ibotta we train a lot of machine learning models [in order to] make predictions for millions of users as they interact with our mobile app."
-> Quels possibles goulots d'étranglement rencontrerait Ibotta?

2. "As compute gets cheaper" -> Concrètement, quelles sont les évolutions récentes?
-> 

3. "The bulk of time is spent training multiple iterations of a model on multiple iterations of a dataset using meta-estimators like grid search or ensembles." -> À ton avis, la parallélisation est-elle facile sur une telle tâche? [attendu: embarassingly parallel problem]

4. "It takes only 3.4 seconds with sk-dist on a Spark cluster with over a hundred cores. The total task time of this job is 7.2 minutes, meaning it would take this long to train on a single machine with no parallelization." -> Expliquer le fonctionnement de Spark.

5. "the number of required fits for hyperparameter tuning adds up quickly." -> 

6. "Spark still has advantages like fine tuned memory specification for executors, fault tolerance, as well as cost control options like using spot instances for worker nodes." -> Expliquer ce qu'est la tolérance aux fautes. Qu'est-ce qu'une "spot instance" ?

7. La façon de distribuer de sk-dist serait-elle adaptée à dde grands jeux de données? [Non: il faut envoyer les données sur chaque exécuteur.]

8. "The bottom line is that we want to distribute models, not data." -> Quels sont les enjeux supplémentaires liées à la distribution des données?



