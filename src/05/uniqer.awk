#!/bin/bash/awk -f

BEGIN{}
{
    a[$1]++ 
}
END{
for (b in a){
    print b
    }
}