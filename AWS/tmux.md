# Tmux
- Attaching and detaching session
- Runs different session on bash even if SSH connection is closed

## Commands

### Start a new session
```bash
$ tmux new -s <session-name>
```

### Detach from session (but remains in SSH)
```
CTRL + B, then just D
```

### Attach to session 
```bash
$ tmux attach -t <session-name>
```

### List sessions
```bash
$ tmux list-sessions
```

### Kill session
```bash
$ tmux kill-session -t <session-name>
```