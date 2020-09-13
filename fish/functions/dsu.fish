function dsu
    if count $argv > /dev/null
        if [ $history[$argv[1]] = "dsu" ]
            dsu (math $argv[1] + 1)
        else
            eval command sudo $history[$argv[1]]
        end
    else
         dsu 1
    end
end
