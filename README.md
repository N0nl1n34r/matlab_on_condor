# `matlab_on_condor`

This repository provides Matlab source code to run embarassingly parallel problems on a HTCondor system.

## Installing

1. Download or clone the repository. 

2. Start Matlab and add the folder `matlab_on_condor` to your path (using either a right-click in the file manager or using the Matlab command `addpath`).

3. That's it! You can test if everything is working correctly by running

```
condor.options('set', 'no_nodes', 10);  
condor.execute(@condor.tasks.identity, ...  
               condor.parfuns.identity, ...  
               condor.reducefuns.sum)
```
from the console. The output should be `55`.

## Usage
The main function of the package is called

```
condor.execute(funfile, parfun, reducefun)
```
and takes three arguments:  

* ```funfile``` (short for function file): A ```char```-array with the path to a file containing a function or the name of a function which should be run on the condor nodes. The task function on the ```i```th node is called with the input arguments defined by ```parfun(i)```. The number of nodes can be set by calling ```condor.options('set', 'no_nodes', <number>)``` beforehand. Example: If one wanted to run the function ```foo``` defined in the file ```foo.m``` on the HTCondor system, ```funfile``` can be set to either ```'foo'``` (function name) or ```'foo.m'``` (path to file) but neither to ```@foo``` (function handle) nor ```'@foo'``` (function handle as ```char```-array).  
* ```parfun``` (short for parameter function): A function handle which takes one integer argument (the job number) and returns a cell array with input arguments with which the function specified by ```funfile``` run on the corresponding node number will be called.  
* ```reducefun``` (short for reduce function): A function handle which takes at least ```condor.options('no_nodes')``` number of input arguments and returns one output argument. It will be called with the return values of the function calls on the condor nodes and the return value of the reduce function will be the return value of ```condor.execute```.  


There are helper functions available for the construction of parameter and reduce functions. Details can be found in the documentation of the according files.

## Author

* **Denis Hessel**
* e-mail: d.hessel@wwu.de


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* Phong-Minh Timmy Ly for providing me with a starting point on how to use the HTCondor system.

