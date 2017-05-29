# Todo.vim

This is a minimal vim plugin for handling simple todo files that look like this:

    [ ] This is a TODO item
    [ ] ! This is a high priority TODO item
    [X] This item is finished

It provides bindings for checking/unchecking items, adding/removing the bang, a command to open
named todo files, a command to add a todo item to each file from anywhere in vim and syntax
highlighting to make high priority items stand out.

## USAGE

### Configure your todo files

Here is my todo.vim config.

    let g:todo_vim_files = {
          \   'Todo': '~/todo',
          \   'Track': '~/track.todo'
          \ }
    let g:todo_vim_project_todo = "./project.todo"

The `g:todo_vim_files` setting sets up two ex commands `:Todo` and `:Track`, each one performing the
same set of operations on a todo file at the configured path. These paths are considered global, and
will be converted to absolute paths when you start vim. Putting relative paths here is almost always
a mistake.

The default configuration for `g:todo_vim_files` is `{ 'Todo': ~/todo }`

The `g:todo_vim_project_todo` setting creates a command `:ProjectTodo`, which will perform the same
set of operations on a todo file at the configured path *as a relative path* (relative to vim's
`pwd`). This can be used for project specific todo lists, stored at the root of a project directory.

### Open your todo file

Assuming you're using the default config you can open your todo file like so:

    :Todo

### Add a todo item from anywhere in vim

    :Todo buy toilet paper

This will add `[ ] buy toilet paper` to your todo list. I have my todo file open pretty much all the
time and there are often unsaved changes, so I've tried to make sure this always does what you'd
want it to regardless of whether the buffer is open, modified, hidden, etc.

In other words, if the file is closed or open and unmodified, it'll add your todo directly to the file
and refresh the buffer. On the other hand if the file is open and there are unsaved changes, it'll
add the new todo to the modified buffer instead. In that case you'll have to manually save the
buffer.

You can also run that same command with a bang to add a high priority item...

    :Todo! buy toilet paper

That will add `[ ] ! buy toilet paper` to your todo list.

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


### Default keybindings

In files with the `todo` filetype, by default `[d` / `]d` are mapped to uncheck/check the current
line respectively, and `[p` / `]p` are mapped to remove/add the "!" indicator for high priority
items. `[[` and `]]` are mapped to jump to the previous or next high priority item.

If you'd rather set up your own mappings, set `g:todo_vim_no_mappings` to something non-zero
and todo.vim won't set up any mappings and you can use the following functions:

- `todo#check(lnum)`: Mark the item on line `a:lnum` as complete.
- `todo#uncheck(lnum)`: Mark the item on line `a:lnum` as incomplete.
- `todo#toggle(lnum)`: Toggle the completeness state of the item on line `a:lnum`.
- `todo#highpriority(lnum)`: Add the high priority flag to the item on line `a:lnum`.
- `todo#lowpriority(lnum)`: Remove the high priority flag from the item on line `a:lnum`. 
- `todo#togglepriority(lnum)`: Toggle the high priority flag on the item on line `a:lnum`.
- `todo#jumptopriority(lnum, direction)`: Jump to the next/previous line after/before `a:lnum` which
  contains an item flagged as high priority. If `a:direction` is `'next'` it will jump forwards
  (down the screen). Otherwise it will jump backwards.

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

If your todo list gets too long, it's quite nice to be able to fold items too. Personally I fold by
paragraphs (i.e. a block of text with no empty lines in it is a single fold). You can do that by
adding the following lines to `~/.vim/ftplugin/todo.vim`

    setlocal foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'0':1
    setlocal foldmethod=expr


