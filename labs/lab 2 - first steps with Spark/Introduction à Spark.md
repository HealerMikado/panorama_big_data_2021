---

---

# Outline

1. Launching a Spark cluster on AWS
2. HDFS, YARN and Spark
3. First steps with Spark
4. Map-and-reduce architecture

# Création d'un cluster Spark sur AWS

- [ ] Une fois connecté à la console AWS cherchez le service EMR pour *Elastic Map Reduce*. C'est la *Plateforme as a Service* qui permet de créer un cluster Hadoop dans AWS. Vous allez juste choisir la configuration de votre cluster, et AWS va créer toutes les VM, les mettre en réseau et installer toutes les applications choisie pour vous. Créer un cluster Hadoop à la main est laborieux et n'est pas réellement intéressant, c'est pourquoi les divers fournisseurs de services cloud proposent de telles PaaS 

- [ ] Vous allez arriver sur un écran similaire à celui-ci
  ![](img/emr_premiere_co.png)
  Les fois suivantes il ressemblera à cela
  ![](img/emr_accueil.png)
  Dans tous les cas cliquez sur `Créer un cluster`
  
- [ ] Sur la page suivante voici les configurations à saisir :

  - [ ] Nom du cluster : le nom que vous souhaitez. Le nom par défaut convient très bien

  - [ ] Journalisation : décochez ce paramètre. Il permet de sauvegarder les *log* (journaux) de votre cluster pour ensuite allez chercher la source d'une erreur. Mais pour ce TP cela ne sera pas utile

  - [ ] Mode de lancement : `Cluster`. La différence entre `Cluster` et `Exécution d'étape` est que `Cluster` permet interagir avec le cluster, alors que qu'`Exécution d'étape` créer un cluster, réalise lance un ou plusieurs scripts et s'arrête.  C'est parfait quand vous voulez lancer un "job" sur vos données. Le cluster se lance, fait les calculs puis va exporter les résultats et s'éteindre tout seul.

  - [ ] Libérée (Release en VO) : `emr-5.31.0`, donc l'avant dernière version 5.XX. La dernière à des problèmes pour l'utilisation de notebook.

  - [ ] Type d'instance : des `m5.xlarge` conviennent parfaitement. Si vous voulez vous pouvez essayer des machines plus puissantes, mais cela ne va pas impacter fortement les temps de calculs.

  - [ ] Nombre d'instance :  `3`, mais vous pouvez essayer avec plus d'instance (limitez vous à 6). 

    Pour vous donner une idée des prix unitaire des machines voici un tableau des instance m5.XX. Pour le prix du cluster, multipliez par le nombre de machine

    | Instance   | Prix unitaire par heure |
    | ---------- | ----------------------- |
    | m5.xlarge  | 0.24$                   |
    | m5.2xlarge | 0.48$                   |
    | m5.4xlarge | 0.96$                   |
    | m5.8xlarge | 1.86$                   |

  - [ ] Paire de clé EC2 : sélectionnez la clé du TP 0. Si vous n'en avez pas sélectionnez `Sans paire de clé EC2`. 

  - [ ] Puis cliquez sur `Créer un cluster`

    Voici ce à quoi vous devez arrivez :

    ![](img/emr_config.png)

    La création d'un cluster prend plus de temps que la création d'une machine unique (de l'ordre de quelques minutes). Car AWS doit lancer X machines avec des configurations lourdes, les mettre en réseau etc.

- [ ] Une fois le cluster passer en "En attente" ou "Stand by", allez dans blocs-notes, puis cliquez sur `Créer un bloc-notes`
  ![](img/bloc_note_accueil.png)

- [ ] Sur l'écran suivant vous allez devoir spécifier :

  - [ ] Un nom pour votre *notebook*
  - [ ] Le cluster que vous souhaitez utiliser. Noter que vous pouvez créer à la volée un cluster si vous le souhaitez
  - [ ] Le rôle de sécurité et les groupes associés au service. Nous allons garder les paramètres par défaut
  - [ ] L'endroit où sera stocké votre notebook sur S3. Cela peut servir à recharger un *notebook* fait plus tôt.
  - [ ] Un dépôt git si vous souhaitez versionner votre code.

  Voilà quoi devrait ressembler votre écran avant validation.

  ![](img/notebook_creation.png)

- [ ] La création du *notebook* doit être rapide. Une fois votre *notebook*  `prêt` cliquez sur `Ouvrir dans JupyterLab`. Cela ouvrira une interface JupyterLab pour rédiger des *notebooks*. Par défaut vous pouvez faire des *notebooks* :

  - [ ] Python3
  - [ ] PySpark : Spark avec python
  - [ ] Spark : Spark en Scala
  - [ ] SparkR : Spark en R.

  Créez un *notebook* pyspark et exécutez dans un cellule la ligne suivante :

  ```
  spark
  ```

  cela devrait produire la résultat suivant.
  ![](img/notebook_spark.png)

Pour des questions de sécurité, les liens vers l'interface Spark (*Spark UI*) et les journaux du driver (*Driver log*) ne fonctionnent pas. Il faut pour y accéder réaliser une connexion SSH + un transfert de port.

# Exercice 3. First steps with Spark

👋 **3.1  Your first DataFrame —** Spark's main object class is the DataFrame, which is a distributed table. It is analogous to R's or Python's data frames: one row represents an observation, one column represents a variable. But contrary to R or Python, Spark's DataFrames can be distributed over hundred of nodes.

- Run the following:

  ```python
  df = spark.read.format("parquet")
    .option("mode", "failFast")
    .option("header", "true") 
    .option("inferSchema", True) 
    .option("path", "file://path/to/file.csv.gz") 
    .load()
      
  df.cache()
  ```

  You have just created a data frame! 🎉

  Data frames are **immutable**: there is no method to alter one specific value once one is created. Also, data frames are **distributed**: they are split into blocks, ill-named **partitions**[^3], that are stored separately in the memory of the workers nodes.

  The input file is a parquet file. Parquet is an open source column-oriented format that provide storage optimization. Spark natively can create a DataFrames from a parquet file.

  Why do we cache the DataFrame ? And are there any other solutions ? <!-- Spark doesn't keep the "data" in memory, but only a way to get / process them. Caching the data make it possible to reuse the same DF multiple time without haveing to compute it. Because the data are stored on S3 every time spark process the data, it has to download them. A solution it to store localy the data.-->

[^3]: Usually a "partition" is an set of chunks that cover all the data, without any repetition between the chunks. But not in Spark!

🔨 **3.3 DataFrame manipulation —** Data frames are immutable, but they can be **_transformed_** in other data frames. Such **transformations** include: filtering, sampling, dropping columns, selecting columns, adding new columns...

- First, you can get information about the columns with:

  ```python
  flights.columns       # get the column names
  flights.schema        # get the column names and their respective type
  flights.printSchema() # same, but human-readable
  ```

- What does the following code do?

  ```python
  passengers_per_month = flights\
    .select("PASSENGERS","YEAR","MONTH")\
    .groupBy("YEAR","MONTH")\
    .sum("PASSENGERS")
  ```

- And this one?

  ```python
  flights_from_2018 = flights\
    .sample(fraction=0.001)\
    .filter(flights.YEAR==2018)\
    .limit(100)
  ```

- And this one?

  ```python
  overconfident_carriers = flights\
    .select("CARRIER", "DEPARTURES_SCHEDULED", "DEPARTURES_PERFORMED")\
    .withColumn(        # computes new variable
      "OVERCONFIDENCE", # called "OVERCONFIDENCE"
      (flights.DEPARTURES_SCHEDULED - flights.DEPARTURES_PERFORMED)/
      flights.DEPARTURES_PERFORMED
     )\
    .groupBy("CARRIER")\
    .sum("OVERCONFIDENCE")\
    .sort("sum(OVERCONFIDENCE)")
  ```

- Run each of the code sections.

`r emo::ji("sleeping")` **3.3 Lazy evaluation**

- What happens when you run `flights`, like you would do in Python or R? Why?
- At question **3.2**, did you get any result at all? Did any of the instructions cause computation to actually happen? (_**Hint:** look at the Spark console_)

This is because Spark has what is known as **lazy evaluation**, in the sense that it will wait as much as it can before performing the actual computation. Said otherwise, when you run an instruction such as:

```python
filtered_flights = flights.filter(fligths.YEAR==2018)
```

... you are not executing anything! Rather, you are building an **execution plan**, to be realised later.

Spark is quite extreme in its lazyness, since only a handful of methods called **actions**, by opposition to **transformations**, will trigger an execution. The most notable are:

1. `collect()`, explicitly asking Spark to fetch the resulting rows instead of to lazily wait for more instructions,
2. `take(n)`, asking for `n` first rows
3. `first()`, an alias for `take(1)`
4. `show()` and `show(n)`, human-friendly alternatives[^5]
5. `count()`, asking for the numbers of rows
6. all the "write" methods (write on file, write to database)

[^5]: `first()` is exactly `take(1)` ([ref]( https://stackoverflow.com/questions/37495039/difference-between-spark-rdds-take1-and-first)) and show prints the result instead of returning it as a list of rows ([ref](https://stackoverflow.com/questions/53884994/what-is-the-difference-between-dataframe-show-and-dataframe-take-in-spark-t))

**This has advantages:** on huge data, you don't want to accidently perform a computation that is not needed. Also, Spark can optimize each **stage** of the execution in regard to what comes next. For instance, filters will be executed as early as possible, since it diminishes the number of rows on which to perform later operations. On the contrary, joins are very computation-intense and will be executed as late as possible. The resulting **execution plan** consists in a **directed acyclic graph** (DAG) that contains the tree of all required actions for a specific computation, ordered in the most effective fasshion.

**This has also drawbacks.** Since the computation is optimized for the end result, the intermediate stages are discarded by default. For instance, in the following:

```python
# step 1
flights_overconfidence = flights\
  .withColumn(
    "OVERCONFIDENCE",
    (flights.DEPARTURES_SCHEDULED - flights.DEPARTURES_PERFORMED)/
    flights.DEPARTURES_PERFORMED
  )
# step 2
flights_overconfidence_2018 = flights_overconfidence\
  .filter(fligths.YEAR==2018)\
  .collect()
```

... the intermediate `flights_overconfidence` does not exist more after `collect()` have been called than before the call. Indeed, the values for other years than 2018 have not be computed at all!

- Now run:

  ```python
  passengers_per_month.show()
  flights_from_2018.count()
  overconfident_carriers.take(10)
  ```

  Was something executed this time?

- You can get the execution plan from the Spark console, or from Python with the `explain()` method. Try with `flights_from_2018.explain()`. Does the order of the stages make sense?

`r emo::ji("billed_hat")` **3.4 Practice**

The complete list of methods (transformations and actions) for data frames is listed [here](https://spark.apache.org/docs/latest/api/python/pyspark.sql.html?highlight=dataframe#pyspark.sql.DataFrame). The aggregation functions, such as `sum()`, `max()`, `mean()`... are listed [here](https://spark.apache.org/docs/latest/api/python/pyspark.sql.html?highlight=dataframe#module-pyspark.sql.functions).

- What are the 10 biggest airports of the USA in 2018? <!--
  flights\
  .filter(flights.YEAR==2018)\
  .groupBy("DEST")\
  .sum("PASSENGERS")\
  .orderBy("sum(PASSENGERS)", ascending=False)\
  .show(10)
  -->

- What is the longest regular flight served by each carrier in 2000? <!--
  flights\
  .filter(flights.YEAR==2000)\
  .groupBy("CARRIER")\
  .max("DISTANCE")\
  .show()
  Returning the DEST and ORIGIN of those flights is out of scope for this tutorial, since it requires to introduce window functions or "structs". At this stage, we may want to use:
  flights\
  .orderBy("DISTANCE", ascending=False)\
  .groupBy("CARRIER")\
  .agg(first(...),...) # could not find the proper syntax anyway
  but this is wrong, because first() is non-deterministic (it tries to minimize the use of the cluster, reading from the fewest nodes it can, thus returning only approximate solutions)
  See [here](https://stackoverflow.com/questions/33878370/how-to-select-the-first-row-of-each-group).
  -->

# Exercice 4. Map-and-reduce architecture

Manny computation algorithms can be expressed using two stages:

- a **map stage**, where the intructions can be applied element-wise, in the sense the if elements are arranged as a list, the operation on element $e$, does not depend on the value of $e'$
- a **reduce stage**, where the instructions obtained in the first stage are combined pairwise recursively ; each time a result is obtained from the first stage, it is combined with earlier results, as in an accumulator

The reduce function must be associative, and commutativity simplifies the reduce step even further. Typical exemples are addition and multiplication. Concatenation is associative, but not commutative.

`r emo::ji("man_teacher")` **4.1. Map-and-reduce exemples**

- Find two exemples of computation problems that decompose well under the map-and-reduce principle, and one that can't. <!-- Facile: moyenne, somme, techniques de Monte Carlo. Difficile: inversion de matrice. Impossible: travelling salesman. Opposition entre "embarassingly parallel problems" et "inherently sequential problems". -->

- The `count()` method is expressible as a _map-and-reduce_ algorithm. `flights.count()` is equivalent to the following code. Can you make clear how the job is executed? Is it faster?

  ```python
  # the map function is not available at the data frame level
  # we have to go down at the data set (RDD) level
  flights\
    .rdd\ 
    .map(lambda flight: 1)\
    .reduce(
      lambda accumulator, value:
        accumulator + value
    )
  # reduce is an action verb
  # we do not need an explicit collect()
  ```

- Explain the `lambda flight: 1` syntax. How do you call this kind of object? <!-- anonymous functions -->

- Look at the Spark console to see where the different stages of the computation actually happenned.

<!-- L'opération `reduce` est le plus souvent commutative puisque le résultat final doit être le même quel que soit l'ordre d'exécution des tâches du `map`. La distinction formelle entre `accumulator` et `value` est donc plus pédagogique qu'autre chose. -->

`r emo::ji("soccer")` **4.2. Practice** 

- Compute the total number of passengers transported following the map-and-reduce principle. Is it faster than <!-- 
  flights\
  .rdd\
  .map(lambda flight: flight.DISTANCE)\ # ONLY CHANGE HERE!
  .reduce(
    lambda accumulator, value:
      accumulator + value
  )
  -->

- What does the following code do?

  ```python
  def my_function( a, b ) :
    return b if b > a else a
  
  flights\
    .rdd\
    .map(lambda flight: flight.AIR_TIME)\
    .reduce( my_function )
  ```

- The _map_ stage may as well return a tupple (FR: n-uplet), as long as the you have an corresponding well chosen _reduce_ stage. For instance, what does the following do?

  ```python
  flights\
    .rdd\
    .map(lambda flight: (flight.AIR_TIME, flight.CARRIER))\
    .reduce(lambda a, b: a if a[0] > b[0] else b)
  ```

- How would you recode the `mean()` function in two succesive map-and-reduce operations? Is it possible with only one?

- What about the variance? <!-- open problem -->