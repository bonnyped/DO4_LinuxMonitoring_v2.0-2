#!bin/bash/awk -f

BEGIN{
    FS=" "
    FR="\n"
}
{
    if($8~/^[4|5][0-9]+/)
    print $0
}
END{}
