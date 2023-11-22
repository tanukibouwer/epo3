# EPO-3 Group 14

## Compiling the main chip project
To compile the main chip project, run the following steps in your x2go environment:
* Clone this repository to your x2go environment.
* Open a terminal in the repository's folder and run the following command: 
```bash
$ sh link.sh
```
* Check the output to make sure no errors have appeared.
* Now open the `main` folder in GoWithTheFlow.
* At the top menu bar in GoWithTheFlow, go to `Compile` -> `New VHDL files`.
* All VHDL file and components across all subsystems should now be present in GoWithTheFlow.

## Working on one subsystem.
You can use the `main` project to edit the subsytem if you so wish. The project may end up appearing very cluttered, though. Alternatively, edit the files outisde of GoWithTheFlow in their own folder with an editor of your choice. Or: Create a new GoWithTheFlow project _outside_ the repository and link/copy the VHDL files from the subsystem's folder to your project.
