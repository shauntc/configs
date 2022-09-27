export def "gu push" [] {
    let branch = (git branch --show-current | str trim)
    let remote = (git remote | str trim)
    git push --set-upstream $remote $branch
}

export def "gu branches" [user = 'shcampbe'] {
    git branch -a | lines | where -b { ($in | str contains $"users/($user)") || ($in | str contains $"user/($user)") } | str trim | wrap 'branch' | insert 'local' {$in.branch | str contains -n 'remotes/' } | update branch { $in.branch | str replace "remotes/origin/" ""}
}