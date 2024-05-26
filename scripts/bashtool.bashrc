function count_files() {
    find . -maxdepth 1 -type d ! -name ".*" | while read -r dir;
    do 
        realname=$(basename "$dir");
        printf "%-10s: " "$realname"; 
        find "$dir" -type f | awk -F. '{print $NF}' | sort | uniq -c | awk '{printf "(%s) ", $0} END {print ""}';
    done
}
