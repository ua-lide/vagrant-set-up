target='a.out'
executable='a.out'
while getopts "o:f:i:nca:w:" option
do
	case $option in
		o)
			options=${OPTARG}
			;;
		a)
			arguments=${OPTARG}
			;;
    c)
      compilationUniquement=true
      ;;
		t)
			target=${OPTARG}
	esac
done

make ${target}

if [ -x $executable ]
then
	./${executable} ${arguments}
	res=$?
	echo "LIDE ==== Fin du programme avec le code $res====="
fi