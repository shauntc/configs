# set upstream and push the current branch
export def "gu push" [] {
    let branch = (git branch --show-current | str trim)
    let remote = (git remote | str trim)
    git push --set-upstream $remote $branch
}

def not_empty [] { each {|value| (echo $value | str length) != 0} }

def commit_date [] { each { |branch| (git log $branch -n 1 --format=%ad) | str trim | into datetime } }

# get all branches for a user
export def "gu branches" [user = 'shcampbe'] {
    git branch -a |
        lines |
        filter { ($in | str contains $"users/($user)") or ($in | str contains $"user/($user)") } |
        str replace '\*' '' |
        str trim |
        wrap 'branch' |
        insert 'last commit' { $in.branch | commit_date } |
        sort-by 'last commit' -r |
        update 'branch' { $in.branch | str replace 'remotes/[^/]+/' "" } |
        group-by 'branch' |
        transpose branch 'last commit' |
        update 'last commit' { $in.'last commit' | get 'last commit'.0 }
}