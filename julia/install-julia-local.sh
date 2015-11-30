add-apt-repository ppa:staticfloat/juliareleases
apt-get update -y
apt-get install julia julia-doc -y
julia -E 'Pkg.update()'
