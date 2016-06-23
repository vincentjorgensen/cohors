#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
base_dir=$DIR/..
provision_dir=$base_dir/centuriae
stela_dir=$base_dir/stelae
cf_dir=$base_dir/cf
bin_dir=$base_dir/bin
inventory=$base_dir/inventarium
site_file=$base_dir/site.yml

cmd=${0##*/}

function usage {
    cat <<EOF
Usage:
`readlink $0` [-c|-d] [-s <stela>] [-r <region>] [-e <environs>] 
    or
export CH_REGION=us-west-2
export CH_ENVIRONS=dev
export CH_STATE=present    # absent or -d to remove
`readlink $0` [stela]

The flags will override the environment variables
EOF
    exit
}

region=us-west-2
environs=dev
stela_state=present
provision=false
[[ -n $CH_REGION ]]     && region=$CH_REGION
[[ -n $CH_ENVIRONS ]]   && environs=$CH_ENVIRONS
[[ -n $CH_STATE ]]      && stela_state=$CH_ENVIRONS
[[ $cmd = procedite ]]  && stela_state=present && provision=true
[[ $cmd = discedite ]]  && stela_state=absent && provision=true
[[ $cmd = adsigna ]]    && provision=false
stela=$1
[[ -z $2 ]] && shift

while getopts ":s:r:e:cd" opt; do
    case $opt in
        c)
            stela_state=present
            ;;
        d)
            stela_state=absent
            ;;
        s)
            stela=$OPTARG
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

playbook=$site_file
extra_vars="region=$region environs=$environs base_dir=$base_dir"
limits="-l $stela"
if $provision; then
    playbook=$provision_dir/$stela.yml
    extra_vars="stela=$stela region=$region environs=$environs base_dir=$base_dir stela_state=$stela_state"
    limits=''
fi

[[ -z $region ]] && usage
[[ -z $stela ]] && usage
[[ -z $environs ]] && usage
[[ ! -e $playbook ]] && echo "$playbook must exist" && exit 1

#ch_file=$stela_dir/$stela.yml
#cf_file=$cf_dir/$region-$stela-$environs.cftemplate
#$bin_dir/y2j.py < $ch_file > $cf_file

ansible-playbook -vvv -i $inventory \
    --extra-vars "$extra_vars" \
    $playbook $limits $*

# End
