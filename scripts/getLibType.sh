input=$1;

awk '{if ($1~"expected_format"){print $2}}' $input | sed 's/,//g' | sed 's/"//g'