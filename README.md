# Todo.vim

This is a minimal vim plugin for handling a simple todo file that look like this:

    [ ] This is a TODO item
    [X] This item is finished

It provides bindings for checking and unchecking items, a command to open the todo file and a
command to add a todo item to the file from anywhere in vim. That's all it does.

## USAGE

### Configure your todo file

    g:todo_vim_file_path = /path/to/todo/file

Defaults to `~/todo`.

### Open your todo file

    :Todo

### Add a todo item from anywhere in vim

    :Todo buy toilet paper

This will add "[ ] buy toilet paper" to your todo list. I have my todo file open pretty much all the
time and there are often unsaved changes, so I've tried to make sure this always does what you'd
want it to regardless of whether the buffer is open, modified, hidden, etc.

In other words, if the file is closed or open and modified, it'll add your todo directly to the file
and refresh the buffer. On the other hand if the file is open and there are unsaved changes, it'll
add the new todo to the modified buffer instead. In that case you'll have to manually save the
buffer.

### Mark items as done/not done

Use `]d` to mark an item as finished, and `[d` to reset it to unfinished. These bindings are set
on the 'todo' filetype, which is turned on for the '.todo' extension and for files called 'todo'

