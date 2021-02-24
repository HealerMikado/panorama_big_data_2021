
## Making of Computer Science survival kit

### Brainstorm of themes

- [ ] Code profiling to prioritize optimization. Do not spend time to reduce the computation time of a function by 0.5 sec if another function take 10min. Try to optimize the slowest part of your code. 

  - [ ] Python profiling : `cProfile`. Give a lot of information, maybe too much. You have to filter to get only the high level function. An easier solution is to use `time.time`. You could use `timeit`, but it's a bad idea. `timeit` is for benchmarking, not profiling.

    ```python
    import time
    import cProfile
    import pstats
    from pstats import SortKey
    #----------------------------------------------------------------------
    def fast():
        """"""
        print("I run fast!")
        
    #----------------------------------------------------------------------
    def slow():
        """"""
        time.sleep(3)
        print("I run slow!")
        
    #----------------------------------------------------------------------
    def medium():
        """"""
        time.sleep(0.5)
        print("I run a little slowly...")
        
    #----------------------------------------------------------------------
    def main():
        """"""
        fast()
        slow()
        medium()
        
    if __name__=="__main__":
        
        cProfile.run('main()', 'restats')
        p = pstats.Stats('restats')
        p.sort_stats(SortKey.TIME).print_stats(10).print_stats('profiling.py')
    ```

    

- [ ] Good programming practices/tips :
  - [ ] Python :
    - [ ] Multithreading/multiprocessing are not so hard if the processes are independents
    - [ ] Use queue to pass data from one thread to another
    - [ ] Do not append to pandas dataframes ! Append to list then generate a DF from it
    - [ ] Open your resources once !
  - [ ] Do I really need all those 150 columns  ?
  - [ ] Filter before any computation
  - [ ] Proceed a very large dataset but I have independent problem ? Parallelization 
  - [ ] On big request to a db is better than 1000 small. Even the smallest request take time. This time cannot be reduce, so small time * 1000 = not so small time.
  - [ ] Do not download data If you do not need them. For example if your data are on a distance server, run the computation on the server THEN download the result. If you download the data on your computer then run the computation :
    - [ ] The downloading slow down the process
    - [ ] Your computer is likely to be less powerful than the distant server.
  - [ ] Low level language (like C/C++) are faster than high level one (python, java, R). But, there are more difficult to learn and usually code optimization is enough. But for easy tasks, knowing a little of bash is a good thing.
  
- [ ] awk (pronounced *hawk*) : super fast line by line processing unix command.


- [ ] Extract a max from gzip fixed length file. Awk is around two time faster than python. If we parallelize python it become faster than awk, but parallelized awk is still two time faster than parallelized  python. It's not really "big data processing" but for large, but not big data large file, there is simple way to speed up the process. Here is only $\mathcal{O}(n)$ process 
|                     | Small sample (30 files, 4.8 Mo) | Bigger sample (41 files, 1.2 Go) | Even bigger sample (48 files, 3Go) |
| ------------------- | ------------------------------- | -------------------------------- | ---------------------------------- |
| awk                 | 0.23 sec                        | 35 sec                           | 101 sec                            |
| awk parallelized    | 0.07 sec                        | 8 sec                            | 18 sec                             |
| python sequential   | 0.45 sec                        | 77 sec                           | 174 sec                            |
| python parallelized | 0.24 sec                        | 17 sec                           | 40 sec                             |

benchmark done with a :

- 12 logical core
- 16 Go Ram 
- Ubuntu 16.04

- [ ] Keep in mind some common bottlenecks :

  - [ ] Read/write from disk. A common HDD 30-150 MB/sec, SSD 500+ MB/sec. So switching to SSD can improve performances. Your disk are a bottleneck only when you use it a lot.
  - [ ] Network. Transfer very large data through a network take time. So just get what you need
  - [ ] CPU. You are doing to much computations, and your CPU are at its max capacity. No easy solution here. Parallelization, approximation, GPU are leads
  - [ ] Memory bottleneck. You do not have enough RAM -> crash. Increase your RAM, or be smart

  You can monitor your system with tools like windows tasks manager.

### Documents

A checkmark means that the the source has been read and its content has been extracted in the brainstorm section.

**Wikipédia:**

- [ ] awk : https://en.wikipedia.org/wiki/AWK

**Other websites:**

- [ ] Python profiler : https://docs.python.org/3/library/profile.html
- [ ] https://www.blog.pythonlibrary.org/2014/03/20/python-102-how-to-profile-your-code/
- [ ] https://towardsdatascience.com/finding-performance-bottlenecks-in-python-4372598b7b2c

**Books:**

- [ ] Hadoop the definitive guide (Chapter 2, analysing data with unix tools)

**Courses:**

- [ ] A course

### Structure