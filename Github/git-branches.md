# Git Branches

### Creating a New Branch
```bash
$ git branch
$ git branch (name of new branch)
$ git checkout (name of new branch)
$ git push origin (name of new branch)
```

### Merging branched branches to `master`
**Situation**: 
- You have a `master` branch, a `feature` branch, and a `feature2` branch that branches from the `feature` branch (NOT `master`)
- How do you safely merge the `feature` branch and `feature2` branch into `master` and delete these branches?

**Concept**:
1. Open PR for `feature` branch
2. Get code review back for `feature` and add and commit to `feature` as you resolve the code review
3. As you add and commit to `feature`, you have to also keep `feature2` in sync with `feature`. So as you add and commit in `feature`, `git pull` in `feature2` from `feature`
5. Once the code reviews are completed, merge `feature` branch into `master` 
6. You cannot delete `feature` branch yet since `feature2`'s parent branch is `feature`
7. Go to the PR for `feature2` and change `feature2`'s parent branch to `master` using the dropdown on Github
8. Now, `feature2` only depends on `master`, so you can now go to the PR for `feature` and safely delete the `feature` branch
9. Now do code review for `feature2` and merge into `master`.
10. Delete `feature2`.