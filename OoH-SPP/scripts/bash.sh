#test () {
#	LD_PRELOAD=./libSlimGuard.so ../test/main_size  8 163840
#}

#test
ws=0
 ((ws++))

    case "$ws" in
        1)
            WSS="10MB"
            ;;
        2)
            WSS="100MB"
            ;;
        3)
            WSS="250MB"
            ;;
        4)
            WSS="500MB"
            ;;
        5)
            WSS="1GB"
            ;;
    esac

    echo $WSS

for profile in *standard
    do
	    ((ws++))
	    echo $ws
	    cd $profile
	    ls
	    cd ..
    done
