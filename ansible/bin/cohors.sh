#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
base_dir=$DIR/..
century_dir=$base_dir/centuries
stack_dir=$base_dir/cf_stacks
bin_dir=$base_dir/bin
inventory=$base_dir/inventory
site_file=$base_dir/site.yml

cmd=${0##*/}

function usage {
    cat <<EOF
Usage:
`readlink $0` [-c|-d] [-i|-p] [-s <stack>] [-r <region>] [-e <environs>] [-l <core|edge>]
    or
export CH_REGION=us-west-2
export CH_ENVIRONS=dev
export CH_SPOKE=core
export CH_STATE=present    # absent or -d to remove
`readlink $0` [stack]

The flags will override the environment variables
procedite: Alias for `readlink $0` -c (implies -p)
discedite: Alias for `readlink $0` -d (implies -p)
adsigna: Alias for `readlink $0` -o

 -i : Instantiate (CloudFormation)
 -p : Provision (playbooks and roles)
EOF
    exit
}

region=us-west-2
environs=dev
stack_state=present
instantiate=false
spoke=core
[[ -n $CH_REGION ]]     && region=$CH_REGION
[[ -n $CH_ENVIRONS ]]   && environs=$CH_ENVIRONS
[[ -n $CH_STATE ]]      && stack_state=$CH_ENVIRONS
[[ $cmd = procedite ]]  && stack_state=present && instantiate=true
[[ $cmd = discedite ]]  && stack_state=absent && instantiate=true
[[ $cmd = adsigna ]]    && instantiate=false
stack=$1
[[ -z $2 ]] && shift

while getopts ":s:r:e:l:cdop" opt; do
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
        l)
            spoke=$OPTARG
            ;;
        p)
            instantiate=false
            ;;
        i)
            instantiate=true
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

playbook=$site_file
extra_vars="region=$region environs=$environs base_dir=$base_dir spoke=$spoke"
limits="-l $stack"
if $instantiate; then
    playbook=$century_dir/$stack.yml
    extra_vars="stack=$stack region=$region environs=$environs base_dir=$base_dir stack_state=$stack_state spoke=$spoke"
    limits=''
fi

[[ -z $region ]] && usage
[[ -z $stack ]] && usage
[[ -z $environs ]] && usage
[[ -z $spoke ]] && usage
[[ ! -e $playbook ]] && echo "$playbook must exist" && exit 1

ansible-playbook -vvv -i $inventory \
    --extra-vars "$extra_vars" \
    $playbook $limits $*

# End
