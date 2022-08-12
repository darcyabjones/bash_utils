# bash_utils

This is a set of bash scripts that are designed to be `source`'d and function a bit like libraries in other programming languages.


## Cleaner `source`-ing

There are two scripts that make `source` function bit like libraries.
Both need to be called at the top and bottom of the script with the `save` and `restore` subcommands to preserve as much info as possible.


### `import.sh`

`./import.sh` unsets any undesired variables that you've greated in your batch script, so that `source`-ing can be encapsulated a bit.
It also keeps track of any environment variables and functions that the module will overwrite, and saves the value so that it can be restored when then script finishes.

At the top of your script, you'll call

```
# You're going to create fn1 fn2 VAR1 and VAR2 in this script, so we preserve the current values first.
source ./import.sh save "${0}" fn1 fn2 VAR1 VAR2
```

The `${0}` bit is needed so that we can keep track of multiple "modules".

At the bottom of the script (after all of your variables are done) you can restore the variables 
and unset the things you don't want to keep like so.


```
source ./import.sh restore "${0}" fn1 VAR1 -- fn1 fn2 VAR1 VAR2
```

Again we have the subcommand `restore` and the current filename `${0}`, then we have two space separated lists.
The first is everything we want to keep, and the second should be everything that we defined in the module.
When you source the file, it will unset anything in the second list that isn't in the first.
In this case, it will unset `fn2` and `VAR2`.

It will also restore the values of any variables or functions that you passed to the `save` subcommand earlier.
Note that if you change something that isn't specified in the `save` subcommand, it won't be restored.

If you leave the first list empty, then nothing will be removed and you'll keep everything you've defined.

```
source ./import.sh restore "${0}" -- fn1 fn2 VAR1 VAR2
# is equivalent to
source ./import.sh restore "${0}" fn1 fn2 VAR1 VAR2 -- fn1 fn2 VAR1 VAR2
```

This is kind of the equivalent of `from library import *`.
If you have something defined in there that you don't want to be exported ever, you can just `unset` the variable yourself.
BUT if you want that value to be restored (i.e. if it's defined in some outer scope), you need to make sure it's in the call to `save`, so that it gets `restore`d.
Note that `restore` will only restore values that aren't specified in the list of things to import.
If you want to restore everything that was overwritten you can use `source ./import restoreall "${0}"`

So what you'll probably do is set the first list in the `restore` command to `${@}`, which means that any arguments the user provides to `./source yourscript.sh fn1 VAR2` will be kept.

It functions a bit like `from module import x, y` in python etc.
The idea is that you put this at the end of your own scripts that are designed to be sourced, and then you
can avoid contaminating peoples environments.
Unfortunately you can't really have private functions, because sourcing essentially evaluates the code in place so at run-time it will fail.



### `preserve_set.sh`

`./preserve_set.sh` memorises `set` options (e.g. `set -eu`) so that anything that you specify in the "module" won't affect the sourcing environment.
If you are using the import script, this is already happening so there's no need to run this again.


## Modules

There are a few functions defined that I seem to use a lot in `cli.sh` and `general.sh`.
I'll add some info at some point.

Since these use the `import.sh` script, you can actually load them and it will save some info about what you've saved and restore environment variables.

```
source ./general.sh isin

if isin 1  1 2 3 4
then
    echo "1" was in "1 2 3 4"
fi

# echo_stderr won't be available here
```


## Installation

I expect that you'll probably use this repo as a submodule in your own repo.
Then you can just find paths to these scripts from your own scriptnames (e.g. `source $(dirname $0)/bash_utils/general.sh`).
