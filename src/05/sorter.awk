#!/bin/bash/awk -f

BEGIN{
    FS=" "
    FR="\n"
}
{
    FOR_SORT[$7" "$0] = $R
}
END{
l=asorti(FOR_SORT,SORTED)
for(i=1; i<=l; ++i){
printf("%s\n", FOR_SORT[SORTED[i]])
}
}