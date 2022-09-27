export def "gu push" [] {
    let branch = (git branch --show-current | str trim)
    let remote = (git remote | str trim)
    git push --set-upstream $remote $branch
}

def not_empty [] {
    each {|value| (echo $value | str length) != 0}
}

def commit_date [] {
    each { |branch|
        let author_date = ((git log $branch -n 1 --format=%ad) | str trim)
        if ($author_date | not_empty) {
            $author_date | into datetime
        } else {
            let commiter_date = ((git log $branch -n 1 --format=%cd) | str trim)
            if ($commiter_date | not_empty) {
                $commiter_date | into datetime
            }
        }
    }

}

export def "gu branches" [user = 'shcampbe'] {
    git branch -a |
        lines |
        where -b { ($in | str contains $"users/($user)") || ($in | str contains $"user/($user)") } |
        str replace '\*' '' |
        str trim |
        wrap 'branch' |
        insert 'local' {$in.branch | str contains -n 'remotes/' } |
        insert 'last commit' { $in.branch | commit_date } |
        update 'branch' {$in.branch | str replace 'remotes/[^/]+/' ""}
}