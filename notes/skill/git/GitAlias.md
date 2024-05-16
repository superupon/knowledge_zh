# Useful Git Alias

这些alias需要在`~/.gitconfig`中进行配置

```bash
co = checkout
st = status
aa = add -A
ci = commit
br = branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate
cp = cherry-pick
hist = log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %Cgreen(%ci)%Creset %Cblue[%an]' --abbrev-commit --date=relative
```

## 如何传递参数到git alias中

```bash
git config --global alias.cmisc '!sh -c "git commit -m \"[misc] $1\""'
```

```bash
git cmisc "Your commit message here"
```
