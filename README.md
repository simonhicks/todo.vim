# Todo.vim

This is a minimal vim plugin for handling simple todo files that look like this:

    [ ] This is a TODO item
    [X] This item is finished

It provides bindings for checking and unchecking items, a command to open named todo files and a
command to add a todo item to each file from anywhere in vim. That's all it does.

## USAGE

### Configure your todo files

Here is my todo.vim config.

    let g:todo_vim_files = {
          \   'Todo': '~/todo',
          \   'Track': '~/track.todo'
          \ }

This sets up two ex commands `:Todo` and `:Track`, each one performing the same set of operations on
a todo file at the configured path.

The default configuration is `{ 'Todo': ~/todo }`

### Open your todo file

Assuming you're using the default config you can open your todo file like so:

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

### Move lines of text into a named todo file

You can move selected lines from any file or buffer into a named todo file by invoking the ex
command with a range. Maybe I should give an example...

Let's assume you're using my config shown above (with a `:Todo` file and a `:Track` file), and you have
the following in `~/todo`.

    [ ] update todo.vim readme for new feature
    [ ] email to Bob about next week

Imagine you've sent Bob the email, but you since you're waiting for his response you want to keep
this item around so you can continue to track the progress. Having said that, there's not actually
anything for you to do so keeping it in the todo list is misleading. That's what my track.todo file
is for - tasks for which the next action is someone else's responsibility, but that I want to keep
tabs on anyway.

So. In this case what I would do is select the line containing that item in my todo list (by
pressing `V`) and then invoking `:'<,'>Track` to move it to `~/track.todo`


### Mark items as done/not done

Use `]d` to mark an item as finished, and `[d` to reset it to unfinished. These bindings are set
on the 'todo' filetype, which is turned on for the '.todo' extension and for files called 'todo'

### Other thoughts

Since this is just a plain text file and there's nothing really clever being done to it, you can
also keep any other text in the file. I find that useful so I can do things like add notes about a
task or group todo items into categories under a title like this:

    Todo.vim
    [X] fix :Todo <task> for when file is hidden and saved
    [X] add multiple file configuration
    [ ] update readme with multiple file configuration


    Shopping
    [ ] Buy groceries
        - vegetables
        - meat
        - toilet paper
    [ ] birthday present for Will

Non todo-item lines like that can be transfered between files using `:'<,'>Todo` or `:'<,'>Track`
(or whatever), but they will be ignored if you try to mark them as done or not-done
