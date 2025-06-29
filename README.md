# SDA_tw_heuristics

## Instalation
Install Julia on linux by running the following command:
```
wget https://julialang-s3.julialang.org/bin/linux/x64/1.11/julia-1.11.5-linux-x86_64.tar.gz
tar zxvf julia-1.11.5-linux-x86_64.tar.gz
```
To add Julia's bin folder (with full path) to PATH environment variable, you can edit the ~/.bashrc (or ~/.bash_profile) file. Open the file in your favourite editor and add a new line as follows:
```
export PATH="$PATH:/path/to/<Julia directory>/bin"
```
or follow these instructions:

https://julialang.org/install/

or install it manualy:

https://julialang.org/downloads/platform/#linux_and_freebsd

If it was correctly installed and the PATH variable updated, after restarting the shell session, type in 
```
julia
```
and you shoud see the julia REPL.

## Running the project

Once you have julia sucessfuly installed, go back to the cmd and navigate to the folder "SDA_tw_heuristics/tw_heuristics/". Once in the folder, run:
```
julia
```
which shoud start the julia REPL, and then install project packages by running the following commands:
```
import Pkg; Pkg.instantiate()
```
After that, exit the julia REPL with Ctrl+D, and start the script with:
```
julia --project ./src/generate_graphs.jl
```
or
```
julia --project ./src/tw_heuristics.jl
```
to pass arguments, see more with:
```
julia --project ./src/generate_graphs.jl --help
```
or 
```
julia --project ./src/tw_heuristics.jl --help
```
You can choose n, p, size, and folder for generating data, and folder from which the graphs will be solved (folder should contain only .csv files describing graphs like the folowing example), and the method for computing elimination ordering.

## Input graph format

Graph .csv format: first line is number of nodes, every other line starts with the vertex, and then its neighbors, separated by ','.
```
5
1,2,
2,1,4,5
3,4,5
4,2,3,5
5,2,4
```

## Results

Resulting tree decomposition will be saved in the folder '/output/results/' in the folder with the name of the timestamp of when the programm was run. They will be divided in different folders for every method used. 

Result format:
```
N1,N2
N2,N3
N2,N4
N4,N5
N1,,5
N2,,5;4
N3,,5;4;3
N4,,5;4;2
N5,,1;2
```

## Statistics

Besides results, program computes tree width for every solution and aggregates them in .csv in folder in 'statistics/' with the same name as the folder from which the graphs were loaded
