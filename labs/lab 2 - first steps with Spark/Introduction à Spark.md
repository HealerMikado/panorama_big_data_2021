---

---

# Outline

1. Launching a Spark cluster on AWS
3. First steps with Spark

# Création d'un cluster Spark sur AWS

First: **DO NOT FORGET TO TURN YOUR CLUSTER OFF A THE END OF THIS TUTORIAL!**

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

    It's possible you get an error like this one :
    
    > Résilié avec des erreursThe requested instance type m5.xlarge is not supported in the requested  availability zone. Learn more at  https://docs.aws.amazon.com/console/elasticmapreduce/ERROR_noinstancetype
    
    The physical resources of AWS's datacenters are not unlimited, and AWS keeps some room for manoeuvre for top priority users. So sometimes we, low priority users, cannot use some resources. If this problem happens, just recreate a cluster with a less powerful machin, like m4.xlarge
    
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

- [ ] La création du *notebook* doit être rapide. Une fois votre *notebook*  prêt cliquez sur `Ouvrir dans JupyterLab`. Cela ouvrira une interface JupyterLab pour rédiger des *notebooks*. Par défaut vous pouvez faire des *notebooks* :

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



**DO NOT FORGET TO TURN YOUR CLUSTER OFF A THE END OF THIS TUTORIAL!**


# First steps with Spark

👋 **3.1  Your first DataFrame —** Spark's main object class is the DataFrame, which is a distributed table. It is analogous to R's or Python (Pandas)'s data frames: one row represents an observation, one column represents a variable. But contrary to R or Python, Spark's DataFrames can be distributed over hundred of nodes.

### Data importation

Spark support multiple data formats, and ways to load them.

- data format : csv, json, parquet (an open source column oriented format)
- can read archive files
- schema detection or user defined schema. For static data, like a json file, schema detection can be use with good results.

Spark has multiple syntaxes to import data. Some are simple with no customisation, others are more complexes but you can specify options.

The simplest syntaxes to load a json or a csv file are :

```python
# JSON
json_df. = spark.read.json([location of the file])
# csv
csv_df = spark.read.csv([location of the file])

```

In the future, you may consult the [Data Source documentation](https://spark.apache.org/docs/latest/sql-data-sources.html) to have the complete description of Spark's reading abilities.

---

**✍Hands-on 1 ** 

- Load the json file store here : `s3://mon-super-bucket-06042021/tweets/tweets20210414-142842.jsonl.gz` and name you data frame `df_tweet_small`
    
    <small> ⚙️ This file is an a `JSONL` (JSON-line) format, which means that each line of it is a JSON object. A JSON object is just a Python dictionary or a JavaScript object and looks like this: `{ key1: value1, key2: ["array", "of", "many values]}`). This file has been compressed into a `GZ` archive, hence the `.jsonl.gz` ending. Also this file is not magically appearing in your S3 storage. It is hosted on one of your teacher's bucket and has been made public, so that you can access it.</small>
    
- It's possible to load multiple file a unique DF. It's useful when you have daily files and want to process them all. It's the same syntax as the previous one, just specify a folder. Like `s3://mon-super-bucket-06042021/tweets/`. name you data frame `df_tweet_big`

---

Now you have two dataframes 🎉.

Remember that **Spark is lazy**, in the sense that it will avoid at all cost to perform unnecessary operations and wait to the last moment for performing only the duly requested computations. (Maybe you remember that R is lazy in that sense, but Spark is one degree more lazy than R.)

- Knowing that, do you think that when you run `spark.read.json()`, the data is actually migrated from S3 to the cluster ? If you want some data to be actually loaded, you can use the `show(n)` method (omitting `n` defaults to 20).

Sparks has very loose constraints on what you can actually store in a data frame column. The objects we just imported are actually quite messy.

- Use the `printSchema()` method to see the structure of one object.

**Spark's data frames are immutable**: there is no method to alter one specific value once one is created. This on purpose: mutations are famously hard to track, and Spark want to track them in order to avoid unnecessary computations. Suppressing mutations is actually the the best way to track changes.

Also, **data frames are distributed over the cluster**: they are split into blocks, ill-named **partitions**[^partition], that are stored separately in the memory of the workers nodes. Since Spark is lazy evaluation, all reading and intermediary computation is only kept in memory as your data are being processed.

[^partition]: In mathematics and data science, the "partition" of set $E$ is usually any collection of subsets whose union makes $E$ and whose 2-by-2 intersections are empty. But in Spark a "partition" refers to **one** block, not the set of blocks. And even if we consider the set, when replication is enforced, intersections between blocks are not necessarily empty. However, the union of all the blocks do produce the full original set.

### DataFrame basic manipulations

If data frames are immutable, they can however be **_transformed_** in other data frames, in the sense that a modified copy is returned. Such **transformations** include: filtering, sampling, dropping columns, selecting columns, adding new columns...

First, you can get information about the columns with:

```python
df.columns       # get the column names
df.schema        # get the column names and their respective type
df.printSchema() # same, but human-readable
```

You can select columns with the `select()` method. It takes as argument a list of column name. For example :

```python
df_with_less_columns = df\
  .select("variable3","variable_four","variable-6")\

# Yes, you do need the ugly \ at the end of the line,
# if you want to chain methods between lines in Python
```

You can get nested columns easily with :

```py
df.select("parentField.nestedField")
```

To filter data you could use the `filter()` method. It take as input an expression that gets evaluated for each observation and should return a boolean. Sampling is performed with the `sample()` method. For example :

```python
df_with_less_rows = df\
  .sample(fraction=0.001)\
  .filter(df.variable1=="value")\
  .limit(100)
```


<!-- take() collect() limit() first() show() -->
<!-- lien vers la doc https://spark.apache.org/docs/3.1.1/api/python/reference/pyspark.sql.html#dataframe-apis -->

---

**✍Hands-on 2 ** 

- Define a data frame `tweet_author_hashtags`  with only the `auteur` and `hashtags` columns
- Print (few lines of) a data frame with only the `auteur`, `mentions`, and `urls` columns. (`mentions` and `urls` are both nested columns in `entities`.)
- Filter your first data frame and keep only tweets with more than 1 like. Give a name for this new, transformed data frame and print. Print (few lines of) it.

---

### Lazy evaluation

<!-- certains trucs de cette section sont redondants avec ce qu'il y avait avant -->

- What happens when you run `df_tweet_small`, like you would do in Python or R? Why?
- When you defined `tweet_author_hashtags` did you get any result at all? Did any of the instructions cause computation to actually happen? 

This is because Spark has what is known as **lazy evaluation**, in the sense that it will wait as much as it can before performing the actual computation. Said otherwise, when you run an instruction such as:

```python
tweet_author_hashtags = df_tweet_big.select("auteur","hashtags")
```

... you are not executing anything! Rather, you are building an **execution plan**, to be realised later.

Spark is quite extreme in its lazyness, since only a handful of methods called **actions**, by opposition to **transformations**, will trigger an execution. The most notable are:

1. `collect()`, explicitly asking Spark to fetch the resulting rows instead of to lazily wait for more instructions,
2. `take(n)`, asking for `n` first rows
3. `first()`, an alias for `take(1)`
4. `show()` and `show(n)`, human-friendly alternatives[^5]
5. `count()`, asking for the numbers of rows
6. all the "write" methods (write on file, write to database), see [here](https://spark.apache.org/docs/3.1.1/api/python/reference/pyspark.sql.html#input-and-output) for the list

[^5]: `first()` is exactly `take(1)` ([ref]( https://stackoverflow.com/questions/37495039/difference-between-spark-rdds-take1-and-first)) and show prints the result instead of returning it as a list of rows ([ref](https://stackoverflow.com/questions/53884994/what-is-the-difference-between-dataframe-show-and-dataframe-take-in-spark-t))

**This has advantages:** on huge data, you don't want to accidently perform a computation that is not needed. Also, Spark can optimize each **stage** of the execution in regard to what comes next. For instance, filters will be executed as early as possible, since it diminishes the number of rows on which to perform later operations. On the contrary, joins are very computation-intense and will be executed as late as possible. The resulting **execution plan** consists in a **directed acyclic graph** (DAG) that contains the tree of all required actions for a specific computation, ordered in the most effective fashion.

**This has also drawbacks.** Since the computation is optimized for the end result, the intermediate stages are discarded by default. For instance, in the following:

<!-- SOMETHING MISSING -->

### Basic DataFrame column manipulation 

<!-- Je réfléchis`a la volée. Est-ce qu'on grouperait pas comme ça:
(1) show, take, firs, collect et discussion sur la distribution des données ;
(2) drop, select, filter, et discussion sur la laziness ;
(3) sample, withColumn, etc. et discussion sur l'immutabilité 
? -->

You can add/update/rename column of a dataframe with spark :

- Drop : `df.drop(columnName : str )`
- Rename : `df.withColumnRenamed(oldName : str, newName : str)`
- Add/update : `df.withColumn(columnName : str, columnExpression)` 

For example

<!-- l'exemple avec flights ne fonctionne pas -> remplacer par un ex. sur les tweets ? -->

```python
overconfident_carriers = flights\
  .withColumn(        # computes new variable
    "OVERCONFIDENCE", # called "OVERCONFIDENCE"
    (flights.DEPARTURES_SCHEDULED - flights.DEPARTURES_PERFORMED)/flights.DEPARTURES_PERFORMED
   )

```

The column created by `withColumn()` can have multiple values for the same line. For example you can split an array of values to have one value per line. To do that you should use the `explode()` function. For instance :

```python
df.withColumn("new column", explode("array"))
```

<!-- je ne comprends pas entièrement l'usage de explode() ici ; et c'est pas tout à fait clair si c'est du PySpark (c'est le cas) ou si c'est du Python pur (il y a un explode en pandas par ex.); est-ce que je peux utiliser n'importe quel code python dans ColumnExpression — si tu en parles plus tards, mentionne le au passage, "for using actual Python code in the creation of new variables, see ... ". ; par ailleurs on se sera pas d'explode dans l'exo qui suit... ; et tu en reparles après-->

See [here](https://spark.apache.org/docs/3.1.1/api/python/reference/pyspark.sql.html#functions) for the list of all functions available in an expression.

**✍Hands-on 3** 

- Define a data frame with a column names `interaction_count`. This column is the sum of `like_count`, `reply_count` and `retweet_count`.
- Update the data frame you imported at the beginning of this lab and drop the `other` column

#### Array manipulation

Some columns often contain arrays (lists) of values instead of just one value. This may seem surprising but this actually quite natural. For instance, you may create an array of words from a text, or generate a list of random numbers for each observation, etc.

You may **create array of values** with:
- `split(text : string, delimiter : string)`, turning a text into an array of strings
- `explode(array : Array)` <!-- je crois avoir dini par comprende ce que ça fait et donc ça a le même rôle que explode() en pandas ; si je comprends bien, ça *détruit* un array, et ça le remplace par une répétition de la ligne entière du data.frame, avec chaque valeur de l'array originel...; en R ça corresopndrait à unnest() -->

You may **use array of values** with:
- `size(array : Array)`, getting the number of elements
- `array_contains(inputArray : Array, value)`, checking if some value appears

All this function must be imported first :

```python
from pyspark.sql.functions import split, explode, size, array_contains
```

**✍Hands-on 4** 

- Keep all the tweets with hashtags and for each remaining line, split the hashtag text into an array of hashtags
- Create a new column with the number of words of the `contenu` column. (Use `split()` + `size()`)
- Count how many tweet contain the `#COVID19` hashtag.

#### User definied function

For more advanced column manipulation you will need Spark's `udf()` function (user defined function). For instance, with only the previous syntax you cannot run complex processes like natural language processing over your tweets,<!-- I am not sure this is true anymore, see https://spark.apache.org/docs/3.1.1/api/python/reference/api/pyspark.ml.feature.Tokenizer.html#pyspark.ml.feature.Tokenizer ; but nevertheless true for "advanced, not implemented features" -->, even if you already have your function defined in python. For instance :

```python
# !!!! DOES NOT WORK !!!!
def to_lower_case(string):
	return string.lower()
	
df.withColumn("tweet_lower_case", to_lower_case(df.contenu))
```

will just crash. Keep in mind that Spark is a distributed system, and that Python is only installed on the central node, as a convenience to let you execute instructions on the executor nodes. But by default, pure Python functions can only be executed where Python is installed! We need `udf()` to enable Spark to send Python instructions to the worker nodes.

Let us see how it is done :

```python
# imports
from pyspark.sql.functions import udf
from pyspark.sql.functions import explode
from pyspark.sql.types import StringType

# pure python functions
def to_lower_case(string):
    return string.lower()

# user definid function
to_lower_case_udf = udf(
    lambda x: to_lower_case(x), StringType()
) #we use a lambda function to create the udf.

# df manipulation
df_tweet_small\
  .select("auteur","hashtags")\
  .filter("size(hashtags)!=0")\
  .withColumn("hashtag", explode("hashtags"))\
  .withColumn("hashtag", to_lower_case_udf("hashtag")).show(10)
```

---

**✍Hands-on 5** 

- Create an user defined function that counts how many words a tweet contains.

### Aggregation functions

Spark offer a variety of aggregation function :

- `count(column : string)` will count every not null value of the specify column. You cant use `count(1)` of `count("*")` to count every line (even row with only null values)

- `countDisctinct(column : string)` and `approx_count_distinct(column : string, percent_error: float)`. If the exact number is irrelevant, `approx_count_distinct()`should be preferred <!-- can we have a sense for why? -->

  ```python
  from pyspark.sql.function import count, countDistinct, approx_count_distinct
  
  df.select(count("col1")).show()
  df.select(countDistinct("col1")).show()
  df.select(approx_count_distinct("col1")).show()
  ```

- You have access to all other common functions `min()`, `max()`, `first()`, `last()`, `sum()`, `sumDistinct()`, `avg()` etc

---

**✍Hands-on 6**

- What is the min, max, average of `interaction_count`
- How many tweets have hashtags ? Distinct hashtags ? Try the approximative count with 0.1, 0.01 and 0.001 as maximum estimation error allowed.

### Grouping functions

Like SQL you can group row by a criteria with Spark. Just use the `groupBy(column : string)` method. Then you can compute some aggregation over those groups.

```python
df.groupBy("col1").agg(
  count("col2").alias("quantity") # alias is use to specify the name of the new column
).show() 
```

The `agg()` method can take multiples argument to compute multiple aggregation at once.

```python
df.groupBy("col1").agg(
	count("col2").alias("quantity"), min("col2").alias("min"), avg("col3").alias("avg3") ).show()
```

---

**✍Hands-on 6**

- Compute a data frame with the min, max and average retweet of each author. Then sort it (using the `sort(column : string)` method) and print it.
<!-- one exercice more ? -->

<!-- I can help with that tomorrow, but can we add a (short) exercise on the principle of parallelised computation, like last year with the sum and / or the meand ? It can be a purely theoretical exercice. -->


**DO NOT FORGET TO TURN YOUR CLUSTER OFF!**
