#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
base_dir=$DIR/..
provision_dir=$base_dir/provision
cf_dir=$base_dir/cf

function usage {
    cat <<EOF
Usage:
$0 [-c|-d] [-s <stack>] [-r <region>] [-e <environs>] 
    or
export CH_REGION=us-west-2
export CH_ENVIRONS=dev
export CH_STATE=present    # absent or -d to remove
$0 [stack]

The flags will override the environment variables
EOF
    exit
}

region=us-west-2
environs=dev
stack_state=present
[[ -n $CH_REGION ]]   && region=$CH_REGION
[[ -n $CH_ENVIRONS ]] && environs=$CH_ENVIRONS
[[ -n $CH_STATE ]]    && stack_state=$CH_ENVIRONS
stack=$1
[[ -z $2 ]] && shift

while getopts ":s:r:e:cd" opt; do
    case $opt in
        c)
            stack_state=present
            ;;
        d)
            stack_state=absent
            ;;
        s)
            stack=$OPTARG
            ;;
        r)
            region=$OPTARG
            ;;
        e)
            environs=$OPTARG
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

playbook=$provision_dir/$stack.yml

[[ -z $region ]] && usage
[[ -z $stack ]] && usage
[[ -z $environs ]] && usage
[[ ! -e $playbook ]] && echo "$playbook must exist" && exit 1

ch_file=$base_dir/stacks/$stack.yml
cf_file=$base_dir/cf/$region-$stack-$environs.cftemplate
$base_dir/bin/y2j.py < $ch_file > $cf_file

ansible-playbook -vvvvv -i $base_dir/hosts \
    --extra-vars "stack=$stack region=$region environs=$environs base_dir=$base_dir stack_state=$stack_state" \
    $playbook $*

# End
