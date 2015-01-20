# Todo.vim

This is a minimal vim plugin for handling a simple todo file that look like this:

    [ ] This is a TODO item
    [X] This item is finished

It provides bindings for checking and unchecking items, a command to open the todo file and a
command to add a todo item to the file from anywhere in vim. That's all it does.

## USAGE

### Configure your todo file

    g:todo_vim_file_path = /path/to/todo/file

Defaults to `~/todo`

### Open your todo file

    :Todo

### Add a todo item from anywhere in vim

    :Todo buy toilet paper

This will add "[ ] buy toilet paper" to your todo list. I have my todo file open pretty much all the
time and there are often unsaved changes, so I've tried to make sure this command should pretty much
always do what you'd want it to regardless of whether the buffer is open, modified, hidden, etc.

### Mark items as done/not done

Use `]d` to mark an item as finished, and `[d` to reset it to unfinished

